import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trazza/core/providers/supabase_client_provider.dart';
import 'package:trazza/features/auth/application/providers/auth_provider.dart';
import 'package:trazza/features/budget/data/budget_repository.dart';
import 'package:trazza/features/budget/domain/models/active_period_budget.dart';
import 'package:trazza/features/budget/domain/models/budget_model.dart';
import 'package:trazza/features/expenses/domain/models/expense_model.dart';
import 'package:trazza/features/expenses/providers/expense_provider.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(supabaseClientProvider));
});

final budgetProvider =
    StateNotifierProvider<BudgetNotifier, AsyncValue<BudgetModel?>>((ref) {
      final repository = ref.watch(budgetRepositoryProvider);
      final userId = ref.watch(currentUserProvider)?.id;
      return BudgetNotifier(repository, userId);
    });

class BudgetNotifier extends StateNotifier<AsyncValue<BudgetModel?>> {
  final BudgetRepository repository;
  final String? userId;
  bool isDisposed = false;

  BudgetNotifier(this.repository, this.userId)
    : super(const AsyncValue.loading()) {
    Future<void>.microtask(loadBudget);
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  Future<void> loadBudget() async {
    if (isDisposed) return;
    if (userId == null) {
      state = const AsyncValue.data(null);
      return;
    }
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => repository.getBudget(userId!));
    if (!isDisposed) state = result;
  }

  Future<BudgetModel> saveBudget({
    required double amount,
    required String periodType,
  }) async {
    if (isDisposed) {
      throw StateError('The budget provider is no longer active.');
    }
    final currentUserId = userId;
    if (currentUserId == null) {
      throw StateError('An authenticated user is required to save a budget.');
    }

    final existingBudget = state.valueOrNull;
    state = const AsyncValue.loading();
    try {
      final budget = await repository.upsertBudget(
        BudgetModel(
          id: existingBudget?.id ?? '',
          userId: currentUserId,
          amount: amount,
          periodType: periodType,
          updatedAt: DateTime.now(),
        ),
      );
      if (!isDisposed) state = AsyncValue.data(budget);
      return budget;
    } catch (error, stackTrace) {
      if (!isDisposed) state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

class BudgetPeriodRange {
  final DateTime start;
  final DateTime endExclusive;
  final String label;

  const BudgetPeriodRange({
    required this.start,
    required this.endExclusive,
    required this.label,
  });
}

BudgetPeriodRange calculatePeriodRange(DateTime now, String periodType) {
  final monthStart = DateTime(now.year, now.month);
  final nextMonthStart = DateTime(now.year, now.month + 1);
  final monthName = DateFormat('MMMM', 'es_CO').format(now);
  final capitalizedMonth =
      '${monthName[0].toUpperCase()}${monthName.substring(1)}';

  if (periodType == 'biweekly') {
    if (now.day <= 15) {
      return BudgetPeriodRange(
        start: monthStart,
        endExclusive: DateTime(now.year, now.month, 16),
        label: '1ª Quincena de $capitalizedMonth',
      );
    }
    return BudgetPeriodRange(
      start: DateTime(now.year, now.month, 16),
      endExclusive: nextMonthStart,
      label: '2ª Quincena de $capitalizedMonth',
    );
  }

  return BudgetPeriodRange(
    start: monthStart,
    endExclusive: nextMonthStart,
    label: 'Presupuesto Mensual',
  );
}

ActivePeriodBudget calculateActivePeriodBudget({
  required BudgetModel? budget,
  required List<ExpenseModel> expenses,
  required DateTime now,
}) {
  final periodType = budget?.periodType ?? 'monthly';
  final budgetAmount = budget?.amount ?? 0;
  final periodRange = calculatePeriodRange(now, periodType);
  final spentAmount = expenses
      .where(
        (expense) =>
            expense.transactionType == 'expense' &&
            !expense.expenseDate.isBefore(periodRange.start) &&
            expense.expenseDate.isBefore(periodRange.endExclusive),
      )
      .fold<double>(0, (total, expense) => total + expense.amount);
  final remainingAmount = budgetAmount - spentAmount;
  final percentageFree = budgetAmount <= 0
      ? 0.0
      : (remainingAmount / budgetAmount * 100).clamp(0.0, 100.0).toDouble();

  return ActivePeriodBudget(
    budgetAmount: budgetAmount,
    spentAmount: spentAmount,
    remainingAmount: remainingAmount,
    percentageFree: percentageFree,
    periodLabel: periodRange.label,
    periodType: periodType,
    periodStart: periodRange.start,
    periodEnd: periodRange.endExclusive.subtract(const Duration(days: 1)),
  );
}

final activePeriodBudgetProvider = Provider<AsyncValue<ActivePeriodBudget>>((
  ref,
) {
  final budgetAsync = ref.watch(budgetProvider);
  final expensesAsync = ref.watch(expensesProvider);

  return budgetAsync.when(
    data: (budget) => expensesAsync.when(
      data: (expenses) => AsyncValue.data(
        calculateActivePeriodBudget(
          budget: budget,
          expenses: expenses,
          now: DateTime.now(),
        ),
      ),
      error: (error, stackTrace) =>
          AsyncValue<ActivePeriodBudget>.error(error, stackTrace),
      loading: () => const AsyncValue.loading(),
    ),
    error: (error, stackTrace) =>
        AsyncValue<ActivePeriodBudget>.error(error, stackTrace),
    loading: () => const AsyncValue.loading(),
  );
});

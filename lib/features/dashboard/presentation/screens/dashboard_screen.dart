import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/domain/models/expense_model.dart';
import 'package:trazza/features/expenses/providers/expense_provider.dart';
import 'package:trazza/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:trazza/features/dashboard/presentation/widgets/hero_budget_card.dart';
import 'package:trazza/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:trazza/features/dashboard/presentation/widgets/recent_transactions_list.dart';

class DashboardScreen extends ConsumerWidget {
  final VoidCallback? onScanReceiptPressed;
  final VoidCallback? onCategoriesPressed;
  final VoidCallback? onSetBudgetPressed;
  final VoidCallback? onExportCsvPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onViewAllTransactionsPressed;
  final ValueChanged<ExpenseModel>? onTransactionPressed;

  const DashboardScreen({
    super.key,
    this.onScanReceiptPressed,
    this.onCategoriesPressed,
    this.onSetBudgetPressed,
    this.onExportCsvPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onViewAllTransactionsPressed,
    this.onTransactionPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expensesProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              onNotificationPressed: onNotificationPressed,
              onProfilePressed: onProfilePressed ??
                  () => context.go('/profile'),
            ),
            Expanded(
              child: expensesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No se pudieron cargar tus gastos. Inténtalo de nuevo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.onSurfaceVariant),
                    ),
                  ),
                ),
                data: (expenses) {
                  final sortedExpenses = [...expenses]
                    ..sort(
                      (first, second) =>
                          second.expenseDate.compareTo(first.expenseDate),
                    );
                  final recentActivity = sortedExpenses.take(5).toList();
                  final totalExpenses = expenses.fold<double>(
                    0,
                    (total, expense) => total + expense.amount,
                  );

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HeroBudgetCard(
                          totalExpenses: totalExpenses,
                          expenseCount: expenses.length,
                        ),
                        const SizedBox(height: 16),
                        QuickActionsRow(
                          onScanReceiptPressed: onScanReceiptPressed ??
                              () => context.push('/scan-receipt'),
                          onCategoriesPressed: onCategoriesPressed,
                          onSetBudgetPressed: onSetBudgetPressed,
                          onExportCsvPressed: onExportCsvPressed,
                        ),
                        const SizedBox(height: 20),
                        RecentTransactionsList(
                          expenses: recentActivity,
                          onViewAllPressed: onViewAllTransactionsPressed ??
                              () => context.go('/expense-history'),
                          onTransactionTap: onTransactionPressed,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

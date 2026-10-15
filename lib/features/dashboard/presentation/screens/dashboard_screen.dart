import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/budget/domain/models/active_period_budget.dart';
import 'package:trazza/features/budget/providers/budget_provider.dart';
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
    final activeBudgetAsync = ref.watch(activePeriodBudgetProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              onNotificationPressed: onNotificationPressed,
              onProfilePressed:
                  onProfilePressed ?? () => context.go('/profile'),
            ),
            Expanded(
              child: expensesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
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
                  return activeBudgetAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No se pudo cargar tu presupuesto. Inténtalo de nuevo.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    data: (periodBudget) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HeroBudgetCard(periodBudget: periodBudget),
                          const SizedBox(height: 16),
                          QuickActionsRow(
                            onScanReceiptPressed:
                                onScanReceiptPressed ??
                                () => context.push('/scan-receipt'),
                            onCategoriesPressed: onCategoriesPressed,
                            onSetBudgetPressed:
                                onSetBudgetPressed ??
                                () => _showBudgetDialog(
                                  context,
                                  ref,
                                  periodBudget,
                                ),
                            onExportCsvPressed: onExportCsvPressed,
                          ),
                          const SizedBox(height: 20),
                          RecentTransactionsList(
                            expenses: recentActivity,
                            onViewAllPressed:
                                onViewAllTransactionsPressed ??
                                () => context.go('/expense-history'),
                            onTransactionTap: onTransactionPressed,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
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

Future<void> _showBudgetDialog(
  BuildContext context,
  WidgetRef ref,
  ActivePeriodBudget activeBudget,
) async {
  final existingBudget = ref.read(budgetProvider).valueOrNull;
  final amountController = TextEditingController(
    text: (existingBudget?.amount ?? activeBudget.budgetAmount).toStringAsFixed(
      0,
    ),
  );
  var periodType = existingBudget?.periodType ?? 'monthly';
  var isSaving = false;
  String? errorMessage;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
        title: const Text('Configurar presupuesto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              decoration: InputDecoration(
                labelText: 'Monto en COP',
                prefixText: r'$ ',
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'monthly', label: Text('Mensual')),
                ButtonSegment<String>(
                  value: 'biweekly',
                  label: Text('Quincenal'),
                ),
              ],
              selected: {periodType},
              onSelectionChanged: isSaving
                  ? null
                  : (selection) =>
                        setDialogState(() => periodType = selection.first),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: isSaving
                ? null
                : () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: isSaving
                ? null
                : () async {
                    final amount = double.tryParse(
                      amountController.text.trim(),
                    );
                    if (amount == null || amount <= 0) {
                      setDialogState(
                        () => errorMessage = 'Ingresa un monto válido.',
                      );
                      return;
                    }
                    setDialogState(() {
                      isSaving = true;
                      errorMessage = null;
                    });
                    try {
                      await ref
                          .read(budgetProvider.notifier)
                          .saveBudget(amount: amount, periodType: periodType);
                      if (dialogContext.mounted) {
                        Navigator.of(dialogContext).pop();
                      }
                    } catch (_) {
                      if (dialogContext.mounted) {
                        setDialogState(() {
                          isSaving = false;
                          errorMessage = 'No se pudo guardar el presupuesto.';
                        });
                      }
                    }
                  },
            child: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Guardar'),
          ),
        ],
      ),
    ),
  );

  amountController.dispose();
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/add_expense_sheet.dart';

class AddExpenseScreen extends ConsumerWidget {
  final Future<void> Function(ExpenseData data)? onSaveExpense;
  final VoidCallback? onScanReceiptPressed;

  const AddExpenseScreen({
    super.key,
    this.onSaveExpense,
    this.onScanReceiptPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Container(
            color: Colors.black.withValues(alpha: 0.35),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AddExpenseSheet(
              onSaveExpense: onSaveExpense,
              onScanReceiptPressed: onScanReceiptPressed,
            ),
          ),
        ],
      ),
    );
  }
}

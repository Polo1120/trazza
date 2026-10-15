import 'package:flutter/material.dart';
import 'package:trazza/features/expenses/presentation/widgets/add_expense_sheet.dart';

class AddExpenseScreen extends StatelessWidget {
  final Future<void> Function(ExpenseData data)? onSaveExpense;
  final VoidCallback? onScanReceiptPressed;

  const AddExpenseScreen({
    super.key,
    this.onSaveExpense,
    this.onScanReceiptPressed,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: Container(color: Colors.black.withValues(alpha: 0.35)),
            ),
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

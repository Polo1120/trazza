import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_history_models.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_transaction_card.dart';

class ExpenseDateGroup extends StatelessWidget {
  final ExpenseGroup group;
  final ValueChanged<ExpenseItem>? onItemTap;

  const ExpenseDateGroup({
    super.key,
    required this.group,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateGroupHeader(
          label: group.dateLabel,
          formattedTotal: group.formattedTotal,
          isToday: group.isToday,
        ),
        const SizedBox(height: 8),
        ...group.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExpenseTransactionCard(
              item: item,
              onTap: onItemTap != null ? () => onItemTap!(item) : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateGroupHeader extends StatelessWidget {
  final String label;
  final String formattedTotal;
  final bool isToday;

  const _DateGroupHeader({
    required this.label,
    required this.formattedTotal,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isToday
                      ? AppTheme.primaryContainer
                      : AppTheme.outlineVariant,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceColor,
                ),
              ),
            ],
          ),
          Text(
            formattedTotal,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

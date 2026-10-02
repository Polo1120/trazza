import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_history_models.dart';

class ExpenseTransactionCard extends StatelessWidget {
  final ExpenseItem item;
  final VoidCallback? onTap;

  const ExpenseTransactionCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: AppTheme.primaryColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _CategoryIcon(
                icon: item.icon,
                iconColor: item.iconColor,
                backgroundColor: item.iconBackgroundColor,
              ),
              const SizedBox(width: 12),
              Expanded(child: _ItemInfo(item: item)),
              const SizedBox(width: 8),
              _AmountDisplay(amountCents: item.amountCents),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const _CategoryIcon({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: iconColor),
    );
  }
}

class _ItemInfo extends StatelessWidget {
  final ExpenseItem item;

  const _ItemInfo({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfaceColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            if (item.time.isNotEmpty) ...[
              Text(
                item.time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              _dot(),
            ],
            if (item.subtitle.isNotEmpty)
              Flexible(
                child: Text(
                  item.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            _dot(),
            _PaymentBadge(label: item.paymentMethod),
            if (item.hasOcrReceipt) ...[
              const SizedBox(width: 6),
              _OcrBadge(),
            ],
          ],
        ),
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '•',
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppTheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String label;

  const _PaymentBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.onSurfaceColor,
        ),
      ),
    );
  }
}

class _OcrBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.receipt_outlined,
          size: 13,
          color: AppTheme.secondaryColor,
        ),
        const SizedBox(width: 2),
        Text(
          'OCR',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.secondaryColor,
          ),
        ),
      ],
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  final int amountCents;

  const _AmountDisplay({required this.amountCents});

  String get formattedAmount {
    final value = (amountCents / 100).abs().round();
    final formatted = value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '- \$$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formattedAmount,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfaceColor,
          ),
        ),
        Text(
          'COP',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

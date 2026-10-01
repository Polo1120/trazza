import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class WeeklySpendingChart extends StatelessWidget {
  final String weekLabel;
  final String totalSpending;
  final String peakAmount;
  final VoidCallback? onTap;

  const WeeklySpendingChart({
    super.key,
    this.weekLabel = 'Semana 42',
    this.totalSpending = '\$382.000',
    this.peakAmount = '\$94.000',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gastos de la semana',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Total: $totalSpending COP',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    weekLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 1,
                      color: AppTheme.surfaceContainer,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const _ChartBar(
                        dayLabel: 'L',
                        fillRatio: 0.38,
                        barColor: AppTheme.surfaceContainerHighest,
                      ),
                      const _ChartBar(
                        dayLabel: 'M',
                        fillRatio: 0.48,
                        barColor: AppTheme.surfaceContainerHighest,
                      ),
                      const _ChartBar(
                        dayLabel: 'M',
                        fillRatio: 0.30,
                        barColor: AppTheme.surfaceContainerHighest,
                      ),
                      const _ChartBar(
                        dayLabel: 'J',
                        fillRatio: 0.72,
                        barColor: AppTheme.primaryContainer,
                        isHighlighted: true,
                      ),
                      _ChartBar(
                        dayLabel: 'V',
                        fillRatio: 0.95,
                        barColor: AppTheme.primaryColor,
                        isPeak: true,
                        isHighlighted: true,
                        peakLabel: peakAmount,
                      ),
                      const _ChartBar(
                        dayLabel: 'S',
                        fillRatio: 0.60,
                        barColor: AppTheme.secondaryFixedDim,
                      ),
                      const _ChartBar(
                        dayLabel: 'D',
                        fillRatio: 0.25,
                        barColor: AppTheme.surfaceContainerHighest,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final String dayLabel;
  final double fillRatio;
  final Color barColor;
  final bool isHighlighted;
  final bool isPeak;
  final String? peakLabel;

  const _ChartBar({
    required this.dayLabel,
    required this.fillRatio,
    required this.barColor,
    this.isHighlighted = false,
    this.isPeak = false,
    this.peakLabel,
  });

  @override
  Widget build(BuildContext context) {
    const double maxHeight = 100;
    final double barHeight = maxHeight * fillRatio;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isPeak && peakLabel != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  peakLabel!,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onPrimaryColor,
                  ),
                ),
              ),
              Transform.rotate(
                angle: 0.785398,
                child: Container(
                  width: 6,
                  height: 6,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          )
        else
          const SizedBox(height: 20),
        const SizedBox(height: 4),
        Container(
          width: 16,
          height: barHeight,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            boxShadow: isPeak
                ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          dayLabel,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
            color: isHighlighted
                ? AppTheme.primaryColor
                : AppTheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

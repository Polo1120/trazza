import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class HeroBudgetCard extends StatelessWidget {
  final String monthLabel;
  final int spentPercentage;
  final String availableAmount;
  final String currencyCode;
  final String spentAmount;
  final String limitAmount;
  final int remainingDays;
  final String dailyPace;
  final VoidCallback? onTap;

  const HeroBudgetCard({
    super.key,
    this.monthLabel = 'OCTUBRE',
    this.spentPercentage = 45,
    this.availableAmount = '\$1.750.000',
    this.currencyCode = 'COP',
    this.spentAmount = '\$1.515.000',
    this.limitAmount = '\$3.265.000',
    this.remainingDays = 18,
    this.dailyPace = '+\$35.000/día',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progressFraction = (spentPercentage / 100).clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryFixed.withValues(alpha: 0.2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'PRESUPUESTO DISPONIBLE · $monthLabel',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.secondaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$spentPercentage% gastado',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: availableAmount,
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                            color: AppTheme.onSurfaceColor,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: currencyCode,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Container(
                            height: 10,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            height: 10,
                            width: constraints.maxWidth * progressFraction,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$spentAmount gastados',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Límite: $limitAmount',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: AppTheme.secondaryColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Restan $remainingDays días',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.onSurfaceColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.trending_up_rounded,
                                size: 15,
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Ritmo saludable ($dailyPace)',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

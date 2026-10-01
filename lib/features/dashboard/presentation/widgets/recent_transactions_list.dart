import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class TransactionItemData {
  final String title;
  final String categoryAndTime;
  final String amount;
  final String paymentMethod;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  const TransactionItemData({
    required this.title,
    required this.categoryAndTime,
    required this.amount,
    required this.paymentMethod,
    required this.icon,
    this.iconColor = AppTheme.primaryColor,
    this.iconBackgroundColor = AppTheme.surfaceContainer,
  });
}

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionItemData> transactions;
  final VoidCallback? onViewAllPressed;
  final ValueChanged<TransactionItemData>? onTransactionTap;

  const RecentTransactionsList({
    super.key,
    this.transactions = defaultTransactions,
    this.onViewAllPressed,
    this.onTransactionTap,
  });

  static const List<TransactionItemData> defaultTransactions = [
    TransactionItemData(
      title: 'Éxito Calle 80',
      categoryAndTime: 'Alimentación y Mercado · Hoy, 2:15 PM',
      amount: '-\$142.500',
      paymentMethod: 'Bancolombia',
      icon: Icons.shopping_cart_outlined,
      iconColor: AppTheme.primaryColor,
      iconBackgroundColor: AppTheme.surfaceContainer,
    ),
    TransactionItemData(
      title: 'Transmilenio / TuLlave',
      categoryAndTime: 'Transporte · Hoy, 8:30 AM',
      amount: '-\$29.500',
      paymentMethod: 'Nequi',
      icon: Icons.directions_bus_outlined,
      iconColor: AppTheme.secondaryColor,
      iconBackgroundColor: Color(0x336CF8BB),
    ),
    TransactionItemData(
      title: 'Juan Valdez Café',
      categoryAndTime: 'Café y Antojos · Ayer, 4:20 PM',
      amount: '-\$14.800',
      paymentMethod: 'Efectivo',
      icon: Icons.coffee_rounded,
      iconColor: AppTheme.primaryColor,
      iconBackgroundColor: AppTheme.surfaceContainer,
    ),
    TransactionItemData(
      title: 'Farmatodo Chicó',
      categoryAndTime: 'Salud y Farmacia · Ayer, 11:10 AM',
      amount: '-\$48.200',
      paymentMethod: 'Tarjeta Débito',
      icon: Icons.medication_outlined,
      iconColor: AppTheme.primaryColor,
      iconBackgroundColor: AppTheme.surfaceContainer,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gastos recientes',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceColor,
              ),
            ),
            InkWell(
              onTap: onViewAllPressed,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver todos',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
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
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: AppTheme.surfaceContainerLow,
            ),
            itemBuilder: (context, index) {
              final item = transactions[index];
              final bool isAlternate = index % 2 == 1;

              return Material(
                color: isAlternate
                    ? AppTheme.surfaceBright.withValues(alpha: 0.5)
                    : AppTheme.surfaceContainerLowest,
                child: InkWell(
                  onTap: () => onTransactionTap?.call(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.iconBackgroundColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.iconColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.onSurfaceColor,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.categoryAndTime,
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
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.amount,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onSurfaceColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              item.paymentMethod,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

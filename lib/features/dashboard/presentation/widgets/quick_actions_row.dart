import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback? onScanReceiptPressed;
  final VoidCallback? onCategoriesPressed;
  final VoidCallback? onSetBudgetPressed;
  final VoidCallback? onExportCsvPressed;

  const QuickActionsRow({
    super.key,
    this.onScanReceiptPressed,
    this.onCategoriesPressed,
    this.onSetBudgetPressed,
    this.onExportCsvPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _ActionButton(
            label: 'Escanear Factura',
            icon: Icons.photo_camera_outlined,
            backgroundColor: AppTheme.primaryContainer,
            foregroundColor: AppTheme.onPrimaryColor,
            iconColor: AppTheme.onPrimaryColor,
            onPressed: onScanReceiptPressed,
          ),
          const SizedBox(width: 8),
          _ActionButton(
            label: 'Categorías',
            icon: Icons.category_outlined,
            backgroundColor: AppTheme.surfaceContainerLowest,
            foregroundColor: AppTheme.onSurfaceColor,
            iconColor: AppTheme.primaryColor,
            onPressed: onCategoriesPressed,
          ),
          const SizedBox(width: 8),
          _ActionButton(
            label: 'Fijar Presupuesto',
            icon: Icons.tune_rounded,
            backgroundColor: AppTheme.surfaceContainerLowest,
            foregroundColor: AppTheme.onSurfaceColor,
            iconColor: AppTheme.secondaryColor,
            onPressed: onSetBudgetPressed,
          ),
          const SizedBox(width: 8),
          _ActionButton(
            label: 'Exportar CSV',
            icon: Icons.download_rounded,
            backgroundColor: AppTheme.surfaceContainerLowest,
            foregroundColor: AppTheme.onSurfaceColor,
            iconColor: AppTheme.onSurfaceVariant,
            onPressed: onExportCsvPressed,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      elevation: 0.5,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: iconColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class DetectedExpenseForm extends StatelessWidget {
  final TextEditingController totalAmountController;
  final TextEditingController merchantController;
  final TextEditingController dateController;
  final String selectedCategory;
  final String categoryEmoji;
  final String selectedPaymentMethod;
  final String taxBreakdown;
  final List<String> categoryTags;
  final ValueChanged<String>? onPaymentMethodChanged;
  final VoidCallback? onCategoryPressed;
  final VoidCallback? onTaxBreakdownEdit;
  final VoidCallback onConfirmExpense;
  final VoidCallback? onRescanOrDiscard;
  final bool isSubmitting;

  const DetectedExpenseForm({
    super.key,
    required this.totalAmountController,
    required this.merchantController,
    required this.dateController,
    this.selectedCategory = 'Alimentación y Mercado',
    this.categoryEmoji = '🛒',
    this.selectedPaymentMethod = 'bancolombia',
    this.taxBreakdown = 'IVA 19% incl. (\$20.023 COP)',
    this.categoryTags = const ['#Hogar', '#Supermercado', '#CanastaFamiliar'],
    this.onPaymentMethodChanged,
    this.onCategoryPressed,
    this.onTaxBreakdownEdit,
    required this.onConfirmExpense,
    this.onRescanOrDiscard,
    this.isSubmitting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
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
                  Text(
                    'MONTO TOTAL DETECTADO',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.outlineColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 13,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Confirmado',
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
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: TextField(
                      controller: totalAmountController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                        color: AppTheme.primaryColor,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Text(
                    'COP',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outlineColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      taxBreakdown,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    InkWell(
                      onTap: onTaxBreakdownEdit,
                      child: Row(
                        children: [
                          Text(
                            'Editar desglose',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.tune_rounded,
                            size: 14,
                            color: AppTheme.secondaryColor,
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
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
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
                  Text(
                    'Comercio / Establecimiento',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outlineColor,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 14,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Auto-detectado',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 20,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: merchantController,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onSurfaceColor,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: AppTheme.outlineColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
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
              Text(
                'Fecha y Hora del Comprobante',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.outlineColor,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: AppTheme.outlineColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onSurfaceColor,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppTheme.secondaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
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
                  Text(
                    'Categoría del Gasto',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outlineColor,
                    ),
                  ),
                  Text(
                    'Recomendada',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: onCategoryPressed,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            categoryEmoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            selectedCategory,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.expand_more_rounded,
                        color: AppTheme.onPrimaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    'Tags: ',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outlineColor,
                    ),
                  ),
                  for (final tag in categoryTags) ...[
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
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
                  Text(
                    'Método de Pago Utilizado',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outlineColor,
                    ),
                  ),
                  Text(
                    'Voucher detectado',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.outlineColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _PaymentChip(
                      id: 'bancolombia',
                      title: 'Bancolombia',
                      subtitle: 'Débito ••4921',
                      icon: Icons.credit_card_rounded,
                      isSelected: selectedPaymentMethod == 'bancolombia',
                      onTap: () => onPaymentMethodChanged?.call('bancolombia'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PaymentChip(
                      id: 'nequi',
                      title: 'Nequi',
                      subtitle: 'Disponible',
                      icon: Icons.phone_iphone_rounded,
                      isSelected: selectedPaymentMethod == 'nequi',
                      onTap: () => onPaymentMethodChanged?.call('nequi'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PaymentChip(
                      id: 'cash',
                      title: 'Efectivo',
                      subtitle: 'Bolsillo',
                      icon: Icons.payments_outlined,
                      isSelected: selectedPaymentMethod == 'cash',
                      onTap: () => onPaymentMethodChanged?.call('cash'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color: AppTheme.secondaryColor,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Guardado seguro en Supabase (Row Level Security activo)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onConfirmExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryContainer,
              foregroundColor: AppTheme.onPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.onPrimaryColor,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Confirmar Gasto (\$${totalAmountController.text} COP)',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: TextButton.icon(
            onPressed: isSubmitting ? null : onRescanOrDiscard,
            icon: const Icon(
              Icons.document_scanner_outlined,
              size: 18,
              color: AppTheme.onSurfaceVariant,
            ),
            label: Text(
              'Re-escanear o Descartar Factura',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentChip({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isSelected ? AppTheme.primaryColor : AppTheme.surfaceContainerLow;
    final textColor =
        isSelected ? AppTheme.onPrimaryColor : AppTheme.onSurfaceColor;
    final subtextColor = isSelected
        ? AppTheme.primaryFixedDim
        : AppTheme.outlineColor;
    final iconColor = isSelected ? AppTheme.onPrimaryColor : AppTheme.outlineColor;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: subtextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

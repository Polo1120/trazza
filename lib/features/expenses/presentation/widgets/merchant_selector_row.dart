import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class MerchantSelectorRow extends StatelessWidget {
  final List<String> merchants;
  final String? selectedMerchant;
  final ValueChanged<String> onMerchantSelected;

  const MerchantSelectorRow({
    super.key,
    this.merchants = defaultMerchants,
    required this.selectedMerchant,
    required this.onMerchantSelected,
  });

  static const List<String> defaultMerchants = [
    'Juan Valdez',
    'D1',
    'Éxito',
    'Rappi',
    'Tostao',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Comercio:',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppTheme.outlineColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (int i = 0; i < merchants.length; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  _MerchantTag(
                    name: merchants[i],
                    isSelected: selectedMerchant == merchants[i],
                    onTap: () => onMerchantSelected(merchants[i]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MerchantTag extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _MerchantTag({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppTheme.secondaryContainer
        : AppTheme.surfaceContainerLow;

    final textColor = isSelected
        ? AppTheme.onSecondaryContainer
        : AppTheme.onSurfaceColor;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

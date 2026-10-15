import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/profile/domain/models/category_model.dart';

class CategoryChipsRow extends StatelessWidget {
  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<CategoryModel> onCategorySelected;

  const CategoryChipsRow({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'CATEGORÍA RÁPIDA',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
                letterSpacing: 0.8,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  size: 14,
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(width: 2),
                Text(
                  '1-Tap',
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (int index = 0; index < categories.length; index++) ...[
                if (index > 0) const SizedBox(width: 8),
                _CategoryChip(
                  category: categories[index],
                  isSelected: selectedCategoryId == categories[index].id,
                  onTap: () => onCategorySelected(categories[index]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  Color get _categoryColor {
    final value = category.colorHex.replaceFirst('#', '');
    final normalized = value.length == 6 ? 'FF$value' : value;
    return Color(int.tryParse(normalized, radix: 16) ?? 0xFF6750A4);
  }

  String get _categoryEmoji {
    final categoryValue = '${category.name} ${category.iconName}'.toLowerCase();
    if (categoryValue.contains('salario') || categoryValue.contains('sueldo')) {
      return '💼';
    }
    if (categoryValue.contains('freelance')) {
      return '💻';
    }
    if (categoryValue.contains('invers')) {
      return '📈';
    }
    if (categoryValue.contains('venta')) {
      return '🏷️';
    }
    if (categoryValue.contains('reembolso') ||
        categoryValue.contains('devolu')) {
      return '🎁';
    }
    if (categoryValue.contains('comida') ||
        categoryValue.contains('food') ||
        categoryValue.contains('restaurant')) {
      return '🍔';
    }
    if (categoryValue.contains('vivienda') ||
        categoryValue.contains('home') ||
        categoryValue.contains('house')) {
      return '🏠';
    }
    if (categoryValue.contains('transporte') ||
        categoryValue.contains('transport') ||
        categoryValue.contains('bus')) {
      return '🚗';
    }
    if (categoryValue.contains('ocio') ||
        categoryValue.contains('entretenimiento') ||
        categoryValue.contains('entertainment')) {
      return '🎉';
    }
    if (categoryValue.contains('mercado') ||
        categoryValue.contains('groceries') ||
        categoryValue.contains('market')) {
      return '🛒';
    }
    switch (category.iconName.toLowerCase()) {
      case 'coffee':
        return '☕';
      case 'pharmacy':
      case 'health':
        return '💊';
      case 'services':
      case 'bolt':
        return '⚡';
      default:
        return '📌';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColor;
    final backgroundColor = isSelected
        ? categoryColor.withValues(alpha: 0.14)
        : AppTheme.surfaceContainer;
    final textColor = isSelected ? categoryColor : AppTheme.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      elevation: isSelected ? 1 : 0,
      shadowColor: categoryColor.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_categoryEmoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                category.name,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

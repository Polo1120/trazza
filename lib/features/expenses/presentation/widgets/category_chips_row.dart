import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class CategoryItem {
  final String id;
  final String name;
  final String emoji;
  final int presetAmount;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.presetAmount,
  });
}

class CategoryChipsRow extends StatelessWidget {
  final List<CategoryItem> categories;
  final CategoryItem? selectedCategory;
  final ValueChanged<CategoryItem> onCategorySelected;

  const CategoryChipsRow({
    super.key,
    this.categories = defaultCategories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<CategoryItem> defaultCategories = [
    CategoryItem(
      id: 'coffee',
      name: 'Café',
      emoji: '☕',
      presetAmount: 15000,
    ),
    CategoryItem(
      id: 'lunch',
      name: 'Almuerzo',
      emoji: '🍔',
      presetAmount: 18000,
    ),
    CategoryItem(
      id: 'transport',
      name: 'Bus / Metro',
      emoji: '🚌',
      presetAmount: 3200,
    ),
    CategoryItem(
      id: 'groceries',
      name: 'Mercado',
      emoji: '🛒',
      presetAmount: 45000,
    ),
    CategoryItem(
      id: 'pharmacy',
      name: 'Farmacia',
      emoji: '💊',
      presetAmount: 22000,
    ),
    CategoryItem(
      id: 'services',
      name: 'Servicios',
      emoji: '⚡',
      presetAmount: 60000,
    ),
  ];

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
              for (int i = 0; i < categories.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                _CategoryChip(
                  item: categories[i],
                  isSelected: selectedCategory?.id == categories[i].id,
                  onTap: () => onCategorySelected(categories[i]),
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
  final CategoryItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppTheme.primaryFixed
        : AppTheme.surfaceContainer;

    final textColor = isSelected
        ? AppTheme.primaryColor
        : AppTheme.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      elevation: isSelected ? 1 : 0,
      shadowColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.emoji,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 6),
              Text(
                item.name,
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

enum ExpenseFilter {
  all,
  thisWeek,
  categories,
  paymentMethods,
  highAmount,
}

class FilterChipData {
  final ExpenseFilter filter;
  final String label;
  final int? count;
  final bool hasDropdown;

  const FilterChipData({
    required this.filter,
    required this.label,
    this.count,
    this.hasDropdown = false,
  });
}

class HistoryFilterChips extends StatelessWidget {
  final ExpenseFilter selectedFilter;
  final ValueChanged<ExpenseFilter> onFilterSelected;
  final int totalCount;

  const HistoryFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.totalCount = 0,
  });

  static List<FilterChipData> buildChips(int totalCount) {
    return [
      FilterChipData(
        filter: ExpenseFilter.all,
        label: 'Todos',
        count: totalCount,
      ),
      const FilterChipData(
        filter: ExpenseFilter.thisWeek,
        label: 'Esta semana',
      ),
      const FilterChipData(
        filter: ExpenseFilter.categories,
        label: 'Categorías',
        hasDropdown: true,
      ),
      const FilterChipData(
        filter: ExpenseFilter.paymentMethods,
        label: 'Métodos de pago',
        hasDropdown: true,
      ),
      const FilterChipData(
        filter: ExpenseFilter.highAmount,
        label: 'Mayor a \$50.000',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final chips = buildChips(totalCount);

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = selectedFilter == chip.filter;

          return _FilterChipItem(
            data: chip,
            isSelected: isSelected,
            onTap: () => onFilterSelected(chip.filter),
          );
        },
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final FilterChipData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppTheme.primaryContainer
        : AppTheme.surfaceContainerLowest;
    final textColor = isSelected
        ? AppTheme.onPrimaryColor
        : AppTheme.onSurfaceVariant;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(999),
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              if (data.count != null && isSelected) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${data.count}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onPrimaryColor,
                    ),
                  ),
                ),
              ],
              if (data.hasDropdown) ...[
                const SizedBox(width: 2),
                Icon(
                  Icons.expand_more_rounded,
                  size: 16,
                  color: textColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class DashboardBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onAddExpensePressed;

  const DashboardBottomNavBar({
    super.key,
    this.currentIndex = 0,
    required this.onItemSelected,
    required this.onAddExpensePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Inicio',
                isSelected: currentIndex == 0,
                onTap: () => onItemSelected(0),
              ),
              _NavItem(
                icon: Icons.receipt_long_rounded,
                label: 'Historial',
                isSelected: currentIndex == 1,
                onTap: () => onItemSelected(1),
              ),
              _CenterActionButton(
                onPressed: onAddExpensePressed,
              ),
              _NavItem(
                icon: Icons.pie_chart_outline_rounded,
                label: 'Estadísticas',
                isSelected: currentIndex == 2,
                onTap: () => onItemSelected(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Perfil',
                isSelected: currentIndex == 3,
                onTap: () => onItemSelected(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? AppTheme.primaryColor : AppTheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CenterActionButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryContainer.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppTheme.onPrimaryColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}

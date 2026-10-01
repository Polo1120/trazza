import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class NumericKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspacePressed;

  const NumericKeypad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(['1', '2', '3']),
        const SizedBox(height: 6),
        _buildRow(['4', '5', '6']),
        const SizedBox(height: 6),
        _buildRow(['7', '8', '9']),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _KeypadButton(
                label: '.000',
                isSpecial: true,
                onTap: () => onKeyPressed('000'),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _KeypadButton(
                label: '0',
                onTap: () => onKeyPressed('0'),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _KeypadButton(
                icon: Icons.backspace_outlined,
                onTap: onBackspacePressed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: _KeypadButton(
              label: keys[i],
              onTap: () => onKeyPressed(keys[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isSpecial;
  final VoidCallback onTap;

  const _KeypadButton({
    this.label,
    this.icon,
    this.isSpecial = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSpecial
          ? AppTheme.surfaceContainer
          : AppTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppTheme.surfaceContainerHigh,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: icon != null
              ? Icon(
                  icon,
                  size: 20,
                  color: AppTheme.onSurfaceVariant,
                )
              : Text(
                  label!,
                  style: GoogleFonts.inter(
                    fontSize: isSpecial ? 14 : 22,
                    fontWeight: isSpecial ? FontWeight.w700 : FontWeight.w500,
                    color: AppTheme.onSurfaceColor,
                  ),
                ),
        ),
      ),
    );
  }
}

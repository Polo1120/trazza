import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class OcrProcessingView extends StatelessWidget {
  final VoidCallback? onCancel;

  const OcrProcessingView({
    super.key,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryContainer.withValues(alpha: 0.12),
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryContainer.withValues(alpha: 0.25),
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryContainer,
                  ),
                  child: const Icon(
                    Icons.document_scanner_rounded,
                    color: AppTheme.onPrimaryColor,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Analizando Factura con OCR',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Extrayendo comercio, fecha, desglose de ítems e IVA de acuerdo con la DIAN...',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppTheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 140,
              child: LinearProgressIndicator(
                backgroundColor: AppTheme.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
                minHeight: 4,
              ),
            ),
            if (onCancel != null) ...[
              const SizedBox(height: 28),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.outlineColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

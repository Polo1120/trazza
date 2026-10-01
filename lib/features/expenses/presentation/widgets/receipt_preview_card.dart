import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/receipt_photo_modal.dart';

class ReceiptPreviewCard extends StatelessWidget {
  final String receiptImageUrl;
  final String merchantName;
  final String taxId;
  final String formattedDate;
  final int accuracyPercentage;
  final List<String> detectedLineItems;
  final VoidCallback? onViewPhoto;

  const ReceiptPreviewCard({
    super.key,
    required this.receiptImageUrl,
    this.merchantName = 'Éxito S.A.',
    this.taxId = 'NIT 890.900.608-9 · Chapinero',
    this.formattedDate = '12 Oct 2024 · 06:45 PM',
    this.accuracyPercentage = 98,
    this.detectedLineItems = const [
      'Leche Alquería x2',
      'Café Sello Rojo 500g',
      'Frutas varias',
    ],
    this.onViewPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.verified_rounded,
                    size: 18,
                    color: AppTheme.secondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'OCR Completado',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppTheme.secondaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$accuracyPercentage% precisión',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onViewPhoto ??
                        () => ReceiptPhotoModal.show(
                              context,
                              receiptImageUrl: receiptImageUrl,
                            ),
                    child: Container(
                      width: 76,
                      height: 92,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            receiptImageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.receipt_long_rounded,
                              size: 32,
                              color: AppTheme.outlineColor,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppTheme.primaryColor.withValues(alpha: 0.75),
                                ],
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.only(bottom: 4),
                            child: const Icon(
                              Icons.receipt_long_rounded,
                              size: 16,
                              color: AppTheme.onPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Factura detectada',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 14,
                                  color: AppTheme.secondaryColor,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'DIAN',
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
                        const SizedBox(height: 6),
                        Text(
                          merchantName,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.onSurfaceColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          taxId,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formattedDate,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.outlineColor,
                              ),
                            ),
                            InkWell(
                              onTap: onViewPhoto ??
                                  () => ReceiptPhotoModal.show(
                                        context,
                                        receiptImageUrl: receiptImageUrl,
                                      ),
                              child: Row(
                                children: [
                                  Text(
                                    'Ver foto',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.secondaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.zoom_in_rounded,
                                    size: 14,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (detectedLineItems.isNotEmpty) ...[
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      Text(
                        'Detectados:',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.outlineColor,
                        ),
                      ),
                      const SizedBox(width: 6),
                      for (final item in detectedLineItems) ...[
                        Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                size: 13,
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

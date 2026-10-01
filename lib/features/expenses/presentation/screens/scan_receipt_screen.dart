import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/detected_expense_form.dart';
import 'package:trazza/features/expenses/presentation/widgets/ocr_processing_view.dart';
import 'package:trazza/features/expenses/presentation/widgets/receipt_preview_card.dart';

class ScannedReceiptData {
  final String merchant;
  final String totalAmount;
  final String date;
  final String category;
  final String paymentMethod;
  final String receiptImageUrl;
  final String taxBreakdown;
  final List<String> detectedLineItems;

  const ScannedReceiptData({
    required this.merchant,
    required this.totalAmount,
    required this.date,
    required this.category,
    required this.paymentMethod,
    required this.receiptImageUrl,
    required this.taxBreakdown,
    this.detectedLineItems = const [],
  });
}

class ScanReceiptScreen extends ConsumerStatefulWidget {
  final String? initialReceiptImageUrl;
  final Future<void> Function(ScannedReceiptData data)? onConfirmExpense;

  const ScanReceiptScreen({
    super.key,
    this.initialReceiptImageUrl,
    this.onConfirmExpense,
  });

  @override
  ConsumerState<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends ConsumerState<ScanReceiptScreen> {
  static const String _defaultImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBCyiVWAPszCIZEMo_ANsLDip6mUcvu2gecrwGuAvGAh7Uer-QXRyCyaJBZGQqSE9Rr3u5Zb9RZlltS13v1xgE_7Pt7mOYVq9SUP8uNsrHNdeV-HMiAY7PdOqHHWE3eYVV64pm3kq90IOQMUJcIjnNGclHfqt_-nBFAju_XLYr8YDxorUlzVxBarrvOjYvPmYFARw9krH6dB7fiZ5-qJPB9fBzQnfdrkgeeks2_UMH-oO-x1H3HVe7UAQ';

  late final TextEditingController _merchantController;
  late final TextEditingController _totalAmountController;
  late final TextEditingController _dateController;
  final ImagePicker _imagePicker = ImagePicker();

  String _receiptImageUrl = _defaultImageUrl;
  String _selectedCategory = 'Alimentación y Mercado';
  String _selectedPaymentMethod = 'bancolombia';
  bool _isProcessingOcr = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController(text: 'Almacenes Éxito - Chapinero');
    _totalAmountController = TextEditingController(text: '125.400');
    _dateController = TextEditingController(text: '12 Oct 2024 · 06:45 PM');
    if (widget.initialReceiptImageUrl != null) {
      _receiptImageUrl = widget.initialReceiptImageUrl!;
    }
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _totalAmountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (file != null) {
        setState(() {
          _isProcessingOcr = true;
          _receiptImageUrl = file.path;
        });

        await Future.delayed(const Duration(milliseconds: 1400));

        if (mounted) {
          setState(() {
            _isProcessingOcr = false;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isProcessingOcr = false;
        });
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceContainerLowest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Seleccionar Factura',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.onSurfaceColor,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: Text(
                  'Tomar foto con la cámara',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppTheme.primaryColor,
                ),
                title: Text(
                  'Elegir de la galería',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleConfirmExpense() async {
    final amountText = _totalAmountController.text.trim();
    if (amountText.isEmpty || _isSubmitting) return;

    final data = ScannedReceiptData(
      merchant: _merchantController.text.trim(),
      totalAmount: amountText,
      date: _dateController.text.trim(),
      category: _selectedCategory,
      paymentMethod: _selectedPaymentMethod,
      receiptImageUrl: _receiptImageUrl,
      taxBreakdown: 'IVA 19% incl. (\$20.023 COP)',
      detectedLineItems: const [
        'Leche Alquería x2',
        'Café Sello Rojo 500g',
        'Frutas varias',
      ],
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.onConfirmExpense != null) {
        await widget.onConfirmExpense!(data);
      }
      if (mounted) {
        Navigator.of(context).pop(data);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppTheme.onSurfaceColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                color: AppTheme.onPrimaryColor,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Revisión de Factura',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            color: AppTheme.primaryColor,
            onPressed: _showImageSourceDialog,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isProcessingOcr
            ? OcrProcessingView(
                onCancel: () {
                  setState(() {
                    _isProcessingOcr = false;
                  });
                },
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    ReceiptPreviewCard(
                      receiptImageUrl: _receiptImageUrl,
                      merchantName: _merchantController.text,
                      formattedDate: _dateController.text,
                    ),
                    const SizedBox(height: 16),
                    DetectedExpenseForm(
                      totalAmountController: _totalAmountController,
                      merchantController: _merchantController,
                      dateController: _dateController,
                      selectedCategory: _selectedCategory,
                      selectedPaymentMethod: _selectedPaymentMethod,
                      isSubmitting: _isSubmitting,
                      onPaymentMethodChanged: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                      onConfirmExpense: _handleConfirmExpense,
                      onRescanOrDiscard: _showImageSourceDialog,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }
}

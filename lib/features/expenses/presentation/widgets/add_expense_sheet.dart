import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/category_chips_row.dart';
import 'package:trazza/features/expenses/presentation/widgets/merchant_selector_row.dart';
import 'package:trazza/features/expenses/presentation/widgets/numeric_keypad.dart';
import 'package:trazza/features/expenses/presentation/screens/scan_receipt_screen.dart';

class ExpenseData {
  final int amount;
  final CategoryItem category;
  final String? merchant;
  final String account;
  final DateTime date;

  const ExpenseData({
    required this.amount,
    required this.category,
    this.merchant,
    required this.account,
    required this.date,
  });
}

class AddExpenseSheet extends ConsumerStatefulWidget {
  final int baseBudget;
  final Future<void> Function(ExpenseData data)? onSaveExpense;
  final VoidCallback? onScanReceiptPressed;

  const AddExpenseSheet({
    super.key,
    this.baseBudget = 1850000,
    this.onSaveExpense,
    this.onScanReceiptPressed,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    int baseBudget = 1850000,
    Future<void> Function(ExpenseData data)? onSaveExpense,
    VoidCallback? onScanReceiptPressed,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddExpenseSheet(
        baseBudget: baseBudget,
        onSaveExpense: onSaveExpense,
        onScanReceiptPressed: onScanReceiptPressed,
      ),
    );
  }

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  static const List<String> _accounts = [
    'Bancolombia •• 4912',
    'Nequi (Disponible)',
    'Efectivo en Billetera',
  ];

  String _rawAmount = '15000';
  CategoryItem? _selectedCategory;
  String? _selectedMerchant = 'Juan Valdez';
  int _selectedAccountIndex = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = CategoryChipsRow.defaultCategories.first;
  }

  int get _numericAmount => int.tryParse(_rawAmount) ?? 0;

  bool get _isFormValid => _numericAmount > 0 && _selectedCategory != null;

  String _formatCurrency(int value) {
    return NumberFormat.decimalPattern('es_CO').format(value);
  }

  void _handleKeypadPress(String key) {
    setState(() {
      if (key == '000') {
        if (_rawAmount != '0' && _rawAmount.length <= 6) {
          _rawAmount += '000';
        }
      } else {
        if (_rawAmount == '0') {
          _rawAmount = key;
        } else if (_rawAmount.length < 9) {
          _rawAmount += key;
        }
      }
    });
  }

  void _handleBackspacePress() {
    setState(() {
      if (_rawAmount.length > 1) {
        _rawAmount = _rawAmount.substring(0, _rawAmount.length - 1);
      } else {
        _rawAmount = '0';
      }
    });
  }

  void _handleCategorySelect(CategoryItem category) {
    setState(() {
      _selectedCategory = category;
      if (_rawAmount == '0' || _rawAmount.isEmpty) {
        _rawAmount = category.presetAmount.toString();
      }
    });
  }

  void _handleMerchantSelect(String merchant) {
    setState(() {
      _selectedMerchant = _selectedMerchant == merchant ? null : merchant;
    });
  }

  void _toggleAccount() {
    setState(() {
      _selectedAccountIndex = (_selectedAccountIndex + 1) % _accounts.length;
    });
  }

  Future<void> _submitExpense() async {
    if (!_isFormValid || _isSubmitting) return;

    final data = ExpenseData(
      amount: _numericAmount,
      category: _selectedCategory!,
      merchant: _selectedMerchant,
      account: _accounts[_selectedAccountIndex],
      date: DateTime.now(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (widget.onSaveExpense != null) {
        await widget.onSaveExpense!(data);
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
    final remainingBudget = (widget.baseBudget - _numericAmount).clamp(
      0,
      widget.baseBudget,
    );
    final formattedAmount = _formatCurrency(_numericAmount);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.outlineVariant.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.secondaryFixedDim,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nuevo Gasto',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: AppTheme.onSurfaceVariant,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.surfaceContainer,
                      minimumSize: const Size(32, 32),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'COP • PESOS COLOMBIANOS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formattedAmount,
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                  Container(
                    width: 3,
                    height: 28,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryFixedDim,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: 'Presupuesto restante después: '),
                    TextSpan(
                      text: '\$ ${_formatCurrency(remainingBudget)}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CategoryChipsRow(
                selectedCategory: _selectedCategory,
                onCategorySelected: _handleCategorySelect,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Material(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: _toggleAccount,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  color: AppTheme.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cuenta Débito',
                                      style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: AppTheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      _accounts[_selectedAccountIndex],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.onSurfaceColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.expand_more_rounded,
                                size: 18,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: Material(
                      color: AppTheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: widget.onScanReceiptPressed ??
                            () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ScanReceiptScreen(),
                                ),
                              );
                            },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.photo_camera_outlined,
                                size: 18,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Factura',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              NumericKeypad(
                onKeyPressed: _handleKeypadPress,
                onBackspacePressed: _handleBackspacePress,
              ),
              const SizedBox(height: 12),
              MerchantSelectorRow(
                selectedMerchant: _selectedMerchant,
                onMerchantSelected: _handleMerchantSelect,
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isFormValid && !_isSubmitting
                      ? _submitExpense
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryContainer,
                    disabledBackgroundColor:
                        AppTheme.surfaceContainerHigh.withValues(alpha: 0.6),
                    foregroundColor: AppTheme.onPrimaryColor,
                    disabledForegroundColor:
                        AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
                    elevation: _isFormValid ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSubmitting
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
                              'Guardar Gasto (\$$formattedAmount COP)',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/auth/application/providers/auth_provider.dart';
import 'package:trazza/features/expenses/domain/models/expense_model.dart';
import 'package:trazza/features/expenses/providers/expense_provider.dart';
import 'package:trazza/features/expenses/presentation/widgets/category_chips_row.dart';
import 'package:trazza/features/expenses/presentation/widgets/numeric_keypad.dart';
import 'package:trazza/features/profile/domain/models/category_model.dart';
import 'package:trazza/features/profile/providers/category_provider.dart';

class ExpenseData {
  final int amount;
  final String transactionType;
  final CategoryModel category;
  final String? merchant;
  final String account;
  final DateTime date;
  const ExpenseData({
    required this.amount,
    required this.transactionType,
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

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet>
    with SingleTickerProviderStateMixin {
  static const List<String> accounts = [
    'Transferencia',
    'Nequi',
    'Efectivo en Billetera',
  ];
  String rawAmount = '0';
  CategoryModel? selectedCategory;
  String? selectedCategoryId;
  final TextEditingController descriptionController = TextEditingController();
  String selectedAccountId = 'Transferencia';
  String transactionType = 'expense';
  DateTime selectedDate = DateTime.now();
  bool isSaving = false;
  late final AnimationController cursorController;
  @override
  void initState() {
    super.initState();
    cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    cursorController.dispose();
    super.dispose();
  }

  int get numericAmount => int.tryParse(rawAmount) ?? 0;
  bool get _isFormValid =>
      numericAmount > 0 &&
      selectedCategoryId != null &&
      descriptionController.text.trim().isNotEmpty;
  String _formatCurrency(int value) {
    return NumberFormat.decimalPattern('es_CO').format(value);
  }

  void _handleKeypadPress(String key) {
    setState(() {
      if (key == '000') {
        if (rawAmount != '0' && rawAmount.length <= 6) {
          rawAmount += '000';
        }
      } else {
        if (rawAmount == '0') {
          rawAmount = key;
        } else if (rawAmount.length < 9) {
          rawAmount += key;
        }
      }
    });
  }

  void _handleBackspacePress() {
    setState(() {
      if (rawAmount.length > 1) {
        rawAmount = rawAmount.substring(0, rawAmount.length - 1);
      } else {
        rawAmount = '0';
      }
    });
  }

  void _handleCategorySelect(CategoryModel category) {
    setState(() {
      selectedCategory = category;
      selectedCategoryId = category.id;
    });
  }

  void _handleTransactionTypeSelect(String value) {
    if (transactionType == value) return;
    setState(() {
      transactionType = value;
      selectedCategory = null;
      selectedCategoryId = null;
    });
  }

  void _handleAccountSelected(int index) {
    setState(() {
      selectedAccountId = accounts[index];
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> saveExpense() async {
    if (!_isFormValid || isSaving) return;
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      _showErrorSnackBar('Inicia sesión para guardar un gasto.');
      return;
    }
    final amount = double.tryParse(rawAmount);
    if (amount == null || amount <= 0) {
      _showErrorSnackBar('Ingresa un monto válido.');
      return;
    }
    final data = ExpenseData(
      amount: numericAmount,
      transactionType: transactionType,
      category: selectedCategory!,
      merchant: descriptionController.text.trim(),
      account: selectedAccountId,
      date: selectedDate,
    );
    final expenseModel = ExpenseModel(
      userId: currentUser.id,
      transactionType: transactionType,
      categoryId: selectedCategoryId,
      amount: amount,
      expenseDate: selectedDate,
      description: descriptionController.text.trim(),
      paymentMethod: selectedAccountId,
    );
    setState(() => isSaving = true);
    var isClosing = false;
    try {
      await ref.read(expenseRepositoryProvider).addExpense(expenseModel);
      if (!mounted) return;
      ref.invalidate(expensesProvider);
      if (widget.onSaveExpense != null) {
        await widget.onSaveExpense!(data);
      }
      if (!mounted) return;
      isClosing = true;
      Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        _showErrorSnackBar('No se pudo guardar el gasto: $error');
      }
    } finally {
      if (mounted && !isClosing) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: AppTheme.errorColor, content: Text(message)),
    );
  }

  Widget _buildTransactionTypeOption({
    required String label,
    required IconData icon,
    required String value,
  }) {
    final isSelected = transactionType == value;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: () => _handleTransactionTypeSelect(value),
        borderRadius: BorderRadius.circular(999),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child: Icon(
                  icon,
                  key: ValueKey('$value-$isSelected'),
                  size: 11,
                  color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOut,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(
      categoriesByTypeProvider(transactionType),
    );
    final remainingBudget = transactionType == 'expense'
        ? (widget.baseBudget - numericAmount).clamp(0, widget.baseBudget)
        : widget.baseBudget + numericAmount;
    final formattedAmount = _formatCurrency(numericAmount);
    const monthAbbreviations = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    final dateText = DateUtils.isSameDay(selectedDate, DateTime.now())
        ? 'Hoy, ${selectedDate.day} ${monthAbbreviations[selectedDate.month - 1]}'
        : '${selectedDate.day} ${monthAbbreviations[selectedDate.month - 1]}';
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
                      FadeTransition(
                        opacity: Tween<double>(begin: 0.35, end: 1).animate(
                          CurvedAnimation(
                            parent: cursorController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.secondaryFixedDim,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nueva Transacción',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurfaceColor,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
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
              const SizedBox(height: 10),
              Container(
                height: 36,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F4F7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isExpense = transactionType == 'expense';
                    return Stack(
                      children: [
                        AnimatedAlign(
                          alignment: isExpense
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeInOutCubic,
                          child: Container(
                            width: constraints.maxWidth / 2,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTransactionTypeOption(
                                label: 'Gasto',
                                icon: Icons.arrow_downward_rounded,
                                value: 'expense',
                              ),
                            ),
                            Expanded(
                              child: _buildTransactionTypeOption(
                                label: 'Ingreso',
                                icon: Icons.arrow_upward_rounded,
                                value: 'income',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'COP • PESOS COLOMBIANOS',
                style: GoogleFonts.inter(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                  color: AppTheme.outlineColor,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$ ',
                    style: GoogleFonts.inter(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                  Text(
                    formattedAmount,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.2,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.2, end: 1).animate(
                      CurvedAnimation(
                        parent: cursorController,
                        curve: Curves.easeInOut,
                      ),
                    ),
                    child: Container(
                      width: 2,
                      height: 30,
                      margin: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: RichText(
                  key: ValueKey(transactionType),
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: transactionType == 'expense'
                            ? 'Presupuesto restante después: '
                            : 'Presupuesto disponible: ',
                      ),
                      TextSpan(
                        text: '\$ ${_formatCurrency(remainingBudget)} COP',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Material(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    onTap: () => selectDate(context),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.outlineVariant.withValues(
                            alpha: 0.55,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            size: 14,
                            color: AppTheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateText,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.onSurfaceColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.expand_more_rounded,
                            size: 16,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );
                  return SizeTransition(
                    sizeFactor: curvedAnimation,
                    alignment: Alignment.topCenter,
                    child: FadeTransition(
                      opacity: curvedAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(curvedAnimation),
                        child: child,
                      ),
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(transactionType),
                  child: categoriesAsync.when(
                    loading: () => const SizedBox(
                      height: 48,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => Text(
                      'No se pudieron cargar las categorías.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    data: (categories) => categories.isEmpty
                        ? Text(
                            transactionType == 'income'
                                ? 'Aún no tienes categorías de ingresos disponibles.'
                                : 'Aún no tienes categorías de gastos disponibles.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          )
                        : CategoryChipsRow(
                            categories: categories,
                            selectedCategoryId: selectedCategoryId,
                            onCategorySelected: _handleCategorySelect,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Material(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      child: PopupMenuButton<int>(
                        onSelected: _handleAccountSelected,
                        itemBuilder: (context) => [
                          for (int index = 0; index < accounts.length; index++)
                            PopupMenuItem<int>(
                              value: index,
                              child: Row(
                                children: [
                                  Expanded(child: Text(accounts[index])),
                                  if (accounts[index] == selectedAccountId)
                                    const Icon(
                                      Icons.check_rounded,
                                      color: AppTheme.primaryColor,
                                    ),
                                ],
                              ),
                            ),
                        ],
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
                                      selectedAccountId,
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
                        onTap:
                            widget.onScanReceiptPressed ??
                            () {
                              if (!mounted) return;
                              final router = GoRouter.of(context);
                              Navigator.of(context).pop();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                router.push('/scan-receipt');
                              });
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
              SizedBox(
                height: 42,
                child: TextField(
                  controller: descriptionController,
                  onChanged: (_) => setState(() {}),
                  textCapitalization: TextCapitalization.sentences,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurfaceColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Comercio o nota (ej. Éxito, D1, Rappi)',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.outlineColor,
                    ),
                    prefixIcon: const Icon(Icons.storefront_outlined, size: 16),
                    prefixIconConstraints: const BoxConstraints(minWidth: 36),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceContainerLow,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 420),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final curvedAnimation = CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                    reverseCurve: Curves.easeInCubic,
                  );
                  return SizeTransition(
                    sizeFactor: curvedAnimation,
                    alignment: Alignment.topCenter,
                    child: FadeTransition(
                      opacity: curvedAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(curvedAnimation),
                        child: child,
                      ),
                    ),
                  );
                },
                child: transactionType == 'expense'
                    ? Padding(
                        key: const ValueKey('expense-suggestions'),
                        padding: const EdgeInsets.only(top: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              Text(
                                'Sugeridos:',
                                style: GoogleFonts.inter(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 6),
                              for (final suggestion in [
                                'Juan Valdez',
                                'D1',
                                'Éxito',
                                'Rappi',
                                'Tostao',
                              ]) ...[
                                if (suggestion != 'Juan Valdez')
                                  const SizedBox(width: 8),
                                ActionChip(
                                  label: Text(suggestion),
                                  onPressed: () {
                                    setState(() {
                                      descriptionController.text = suggestion;
                                      descriptionController
                                          .selection = TextSelection.collapsed(
                                        offset:
                                            descriptionController.text.length,
                                      );
                                    });
                                  },
                                  backgroundColor: AppTheme.surfaceContainerLow,
                                  side: BorderSide.none,
                                  labelStyle: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('income-suggestions'),
                      ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _isFormValid && !isSaving ? saveExpense : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    disabledBackgroundColor: AppTheme.surfaceContainerHigh
                        .withValues(alpha: 0.6),
                    foregroundColor: AppTheme.onPrimaryColor,
                    disabledForegroundColor: AppTheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                    elevation: _isFormValid ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSaving
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
                              transactionType == 'expense'
                                  ? 'Guardar Gasto (\$$formattedAmount COP)'
                                  : 'Guardar Transacción',
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

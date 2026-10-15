import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/domain/models/expense_model.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_date_group.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_history_models.dart';
import 'package:trazza/features/expenses/presentation/widgets/history_filter_chips.dart';
import 'package:trazza/features/expenses/presentation/widgets/history_search_bar.dart';
import 'package:trazza/features/expenses/providers/expense_provider.dart';

class ExpenseHistoryScreen extends ConsumerWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        bottom: false,
        child: ref.watch(expensesProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No pudimos cargar tus gastos. Intenta de nuevo más tarde.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: AppTheme.onSurfaceVariant),
              ),
            ),
          ),
          data: (expenses) => _HistoryContent(expenses: expenses),
        ),
      ),
    );
  }
}

class _HistoryContent extends StatefulWidget {
  final List<ExpenseModel> expenses;

  const _HistoryContent({required this.expenses});

  @override
  State<_HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<_HistoryContent> {
  final TextEditingController searchController = TextEditingController();
  ExpenseFilter selectedFilter = ExpenseFilter.all;
  String searchQuery = '';
  bool showExportToast = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ExpenseModel> get filteredExpenses {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    return widget.expenses.where((expense) {
      final searchableText = '${expense.description ?? ''} ${expense.categoryId ?? ''} ${expense.paymentMethod ?? ''} ${expense.amount}'.toLowerCase();
      final matchesSearch = searchableText.contains(searchQuery);
      final matchesFilter = switch (selectedFilter) {
        ExpenseFilter.all => true,
        ExpenseFilter.thisWeek => !expense.expenseDate.isBefore(startOfWeek),
        ExpenseFilter.categories => expense.categoryId != null,
        ExpenseFilter.paymentMethods => expense.paymentMethod?.isNotEmpty ?? false,
        ExpenseFilter.highAmount => expense.amount > 50000,
      };
      return matchesSearch && matchesFilter;
    }).toList();
  }

  List<ExpenseGroup> groupExpensesByDate(List<ExpenseModel> expenses) {
    final groupedExpenses = <DateTime, List<ExpenseModel>>{};
    for (final expense in expenses) {
      final date = expense.expenseDate.toLocal();
      final dateKey = DateTime(date.year, date.month, date.day);
      groupedExpenses.putIfAbsent(dateKey, () => []).add(expense);
    }
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final yesterdayKey = todayKey.subtract(const Duration(days: 1));
    final sortedDates = groupedExpenses.keys.toList()..sort((a, b) => b.compareTo(a));
    return sortedDates.map((date) {
      final isToday = date == todayKey;
      final isYesterday = date == yesterdayKey;
      final dateLabel = isToday
          ? 'Hoy, ${_formatDate(date)}'
          : isYesterday
              ? 'Ayer, ${_formatDate(date)}'
              : _formatDate(date);
      final items = groupedExpenses[date]!.map(_toExpenseItem).toList();
      final total = groupedExpenses[date]!.fold<double>(0, (sum, expense) => sum + expense.amount);
      return ExpenseGroup(
        dateLabel: dateLabel,
        formattedTotal: NumberFormat.currency(locale: 'es_CO', symbol: r'$ ', decimalDigits: 0).format(total),
        isToday: isToday,
        items: items,
      );
    }).toList();
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${date.day} ${monthNames[date.month - 1]}';
  }

  ExpenseItem _toExpenseItem(ExpenseModel expense) {
    final expenseDate = expense.expenseDate.toLocal();
    return ExpenseItem(
      id: expense.id ?? '${expense.userId}_${expense.expenseDate.toIso8601String()}',
      title: (expense.description?.trim().isNotEmpty ?? false)
          ? expense.description!.trim()
          : 'Gasto',
      subtitle: expense.categoryId ?? '',
      time: DateFormat('hh:mm a').format(expenseDate),
      paymentMethod: expense.paymentMethod ?? '',
      amountCents: (expense.amount * 100).round(),
      icon: Icons.receipt_long_rounded,
      iconColor: AppTheme.primaryColor,
      iconBackgroundColor: AppTheme.primaryFixedDim.withValues(alpha: 0.3),
      hasOcrReceipt: expense.receiptImageUrl != null,
      isIncome: expense.transactionType == 'income',
    );
  }

  void _onExportPressed() {
    HapticFeedback.lightImpact();
    setState(() => showExportToast = true);
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) setState(() => showExportToast = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = groupExpensesByDate(filteredExpenses);
    final totalCount = widget.expenses.length;
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _HistoryAppBar(totalCount: totalCount),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              sliver: SliverToBoxAdapter(
                child: HistorySearchBar(
                  searchController: searchController,
                  onChanged: (value) => setState(() => searchQuery = value.toLowerCase().trim()),
                  onClear: () {
                    searchController.clear();
                    setState(() => searchQuery = '');
                  },
                  onScanPressed: () => context.push('/scan-receipt'),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              sliver: SliverToBoxAdapter(
                child: HistoryFilterChips(
                  selectedFilter: selectedFilter,
                  onFilterSelected: (filter) => setState(() => selectedFilter = filter),
                  totalCount: totalCount,
                ),
              ),
            ),
            if (groups.isEmpty)
              SliverFillRemaining(
                child: _EmptyState(isFiltered: searchQuery.isNotEmpty || selectedFilter != ExpenseFilter.all),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                sliver: SliverList.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) => ExpenseDateGroup(group: groups[index]),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              sliver: SliverToBoxAdapter(child: _ExportSection(onExport: _onExportPressed)),
            ),
          ],
        ),
        _ExportToast(visible: showExportToast),
      ],
    );
  }
}

class _HistoryAppBar extends StatelessWidget {
  final int totalCount;

  const _HistoryAppBar({required this.totalCount});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppTheme.surfaceColor.withValues(alpha: 0.85),
      elevation: 0,
      floating: true,
      pinned: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurfaceColor),
        onPressed: () => context.go('/'),
      ),
      title: null,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Historial de Movimientos', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.onSurfaceColor, height: 1.2), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('Revisa y filtra tus transacciones en Colombia', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: AppTheme.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(999)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.secondaryColor, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('$totalCount gastos', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.onSurfaceColor)),
              ]),
            ),
          ],
        ),
      ),
      expandedHeight: 90,
      shadowColor: Colors.black.withValues(alpha: 0.04),
    );
  }
}

class _ExportSection extends StatelessWidget {
  final VoidCallback onExport;

  const _ExportSection({required this.onExport});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Material(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onExport,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.download_rounded, size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text('Descargar Extracto (PDF / Excel)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceColor)),
            ]),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.verified_user_rounded, size: 16, color: AppTheme.secondaryColor),
        const SizedBox(width: 6),
        Text('Tus gastos, siempre a la mano', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.onSurfaceVariant)),
      ]),
    ]);
  }
}

class _EmptyState extends StatelessWidget {
  final bool isFiltered;

  const _EmptyState({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(color: AppTheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.receipt_long_rounded, size: 32, color: AppTheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Text(isFiltered ? 'Sin resultados' : 'No hay gastos registrados', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceColor)),
        if (isFiltered) ...[
          const SizedBox(height: 4),
          Text('Intenta con otra búsqueda o filtro', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppTheme.onSurfaceVariant)),
        ],
      ]),
    );
  }
}

class _ExportToast extends StatelessWidget {
  final bool visible;

  const _ExportToast({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 104,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(color: const Color(0xFF293040), borderRadius: BorderRadius.circular(999), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))]),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.check_circle_rounded, size: 18, color: AppTheme.secondaryFixed),
              const SizedBox(width: 10),
              Text('Preparando tu extracto...', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFFEDF0FF))),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_date_group.dart';
import 'package:trazza/features/expenses/presentation/widgets/expense_history_models.dart';
import 'package:trazza/features/expenses/presentation/widgets/history_filter_chips.dart';
import 'package:trazza/features/expenses/presentation/widgets/history_search_bar.dart';

final _sampleExpenseGroups = [
  ExpenseGroup(
    dateLabel: 'Hoy, 1 Octubre',
    formattedTotal: '\$21.200 COP',
    isToday: true,
    items: [
      ExpenseItem(
        id: 'exp_001',
        title: 'Almuerzo Corrientazo',
        subtitle: 'Rest. Doña Luz',
        time: '12:45 PM',
        paymentMethod: 'Nequi',
        amountCents: 1800000,
        icon: Icons.lunch_dining_rounded,
        iconColor: AppTheme.onSecondaryContainer,
        iconBackgroundColor: AppTheme.secondaryContainer.withValues(alpha: 0.4),
      ),
      ExpenseItem(
        id: 'exp_002',
        title: 'Pasaje Bus SITP',
        subtitle: 'Tarjeta TuLlave',
        time: '07:30 AM',
        paymentMethod: 'Efectivo',
        amountCents: 320000,
        icon: Icons.directions_bus_rounded,
        iconColor: AppTheme.primaryColor,
        iconBackgroundColor: AppTheme.primaryFixedDim.withValues(alpha: 0.3),
      ),
    ],
  ),
  ExpenseGroup(
    dateLabel: 'Ayer, 30 Septiembre',
    formattedTotal: '\$1.214.800 COP',
    items: [
      ExpenseItem(
        id: 'exp_003',
        title: 'Pago Arriendo Apto 402',
        subtitle: 'Transf.',
        time: '',
        paymentMethod: 'Bancolombia',
        amountCents: 120000000,
        icon: Icons.real_estate_agent_rounded,
        iconColor: AppTheme.tertiaryColor,
        iconBackgroundColor: const Color(0xFFFFDAD7).withValues(alpha: 0.5),
      ),
      ExpenseItem(
        id: 'exp_004',
        title: 'Juan Valdez Café Torres Unidas',
        subtitle: 'Capuccino + Croissant',
        time: '04:15 PM',
        paymentMethod: 'Nequi',
        amountCents: 1480000,
        icon: Icons.local_cafe_rounded,
        iconColor: AppTheme.secondaryColor,
        iconBackgroundColor: AppTheme.secondaryContainer.withValues(alpha: 0.3),
      ),
    ],
  ),
  ExpenseGroup(
    dateLabel: '28 Septiembre',
    formattedTotal: '\$89.500 COP',
    items: [
      ExpenseItem(
        id: 'exp_005',
        title: 'Éxito Express Chapinero',
        subtitle: 'Canasta básica',
        time: '',
        paymentMethod: 'Tarjeta Débito',
        amountCents: 8950000,
        icon: Icons.shopping_cart_rounded,
        iconColor: AppTheme.onSecondaryContainer,
        iconBackgroundColor: AppTheme.secondaryFixed.withValues(alpha: 0.4),
        hasOcrReceipt: true,
      ),
    ],
  ),
];

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  ExpenseFilter selectedFilter = ExpenseFilter.all;
  String searchQuery = '';
  bool showExportToast = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<ExpenseGroup> get filteredGroups {
    if (searchQuery.isEmpty && selectedFilter == ExpenseFilter.all) {
      return _sampleExpenseGroups;
    }

    return _sampleExpenseGroups
        .map((group) {
          final matchedItems = group.items.where((item) {
            final matchesSearch = searchQuery.isEmpty ||
                item.title.toLowerCase().contains(searchQuery) ||
                item.subtitle.toLowerCase().contains(searchQuery) ||
                item.paymentMethod.toLowerCase().contains(searchQuery);

            final matchesFilter = _itemMatchesFilter(item);

            return matchesSearch && matchesFilter;
          }).toList();

          return matchedItems.isEmpty
              ? null
              : ExpenseGroup(
                  dateLabel: group.dateLabel,
                  formattedTotal: group.formattedTotal,
                  isToday: group.isToday,
                  items: matchedItems,
                );
        })
        .whereType<ExpenseGroup>()
        .toList();
  }

  bool _itemMatchesFilter(ExpenseItem item) {
    switch (selectedFilter) {
      case ExpenseFilter.all:
        return true;
      case ExpenseFilter.thisWeek:
        return item.id == 'exp_001' || item.id == 'exp_002';
      case ExpenseFilter.categories:
        return true;
      case ExpenseFilter.paymentMethods:
        return true;
      case ExpenseFilter.highAmount:
        return item.amountCents >= 5000000;
    }
  }

  int get totalVisibleCount =>
      filteredGroups.fold(0, (sum, g) => sum + g.items.length);

  void _onSearchChanged(String value) {
    setState(() => searchQuery = value.toLowerCase().trim());
  }

  void _onClearSearch() {
    searchController.clear();
    setState(() => searchQuery = '');
  }

  void _onFilterSelected(ExpenseFilter filter) {
    setState(() => selectedFilter = filter);
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
    final groups = filteredGroups;
    final totalCount = _sampleExpenseGroups.fold(
      0,
      (sum, g) => sum + g.items.length,
    );

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
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
                      onChanged: _onSearchChanged,
                      onClear: _onClearSearch,
                      onScanPressed: () {
                        context.push('/scan-receipt');
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  sliver: SliverToBoxAdapter(
                    child: HistoryFilterChips(
                      selectedFilter: selectedFilter,
                      onFilterSelected: _onFilterSelected,
                      totalCount: totalCount,
                    ),
                  ),
                ),
                if (groups.isEmpty)
                  const SliverFillRemaining(child: _EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    sliver: SliverList.separated(
                      itemCount: groups.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        return ExpenseDateGroup(group: groups[index]);
                      },
                    ),
                  ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  sliver: SliverToBoxAdapter(
                    child: _ExportSection(onExport: _onExportPressed),
                  ),
                ),
              ],
            ),
            _ExportToast(visible: showExportToast),
          ],
        ),
      ),
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
                  Text(
                    'Historial de Movimientos',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceColor,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Revisa y filtra tus transacciones en Colombia',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.secondaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Oct 2024 · $totalCount movs',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                ],
              ),
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
    return Column(
      children: [
        Material(
          color: AppTheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onExport,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.download_rounded,
                    size: 20,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Descargar Extracto (PDF / Excel)',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_rounded,
              size: 16,
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(width: 6),
            Text(
              'Datos encriptados bajo estándares financieros de Colombia',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 32,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin resultados',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.onSurfaceColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Intenta con otra búsqueda o filtro',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
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
        opacity: visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF293040),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppTheme.secondaryFixed,
                ),
                const SizedBox(width: 10),
                Text(
                  'Generando extracto de Octubre...',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFEDF0FF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/dashboard/presentation/widgets/dashboard_bottom_nav_bar.dart';
import 'package:trazza/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:trazza/features/dashboard/presentation/widgets/hero_budget_card.dart';
import 'package:trazza/features/dashboard/presentation/widgets/insight_banner.dart';
import 'package:trazza/features/dashboard/presentation/widgets/lifestyle_card.dart';
import 'package:trazza/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:trazza/features/dashboard/presentation/widgets/recent_transactions_list.dart';
import 'package:trazza/features/dashboard/presentation/widgets/weekly_spending_chart.dart';
import 'package:trazza/features/expenses/presentation/widgets/add_expense_sheet.dart';
import 'package:trazza/features/expenses/presentation/screens/scan_receipt_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final VoidCallback? onScanReceiptPressed;
  final VoidCallback? onCategoriesPressed;
  final VoidCallback? onSetBudgetPressed;
  final VoidCallback? onExportCsvPressed;
  final VoidCallback? onAddExpensePressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onViewAllTransactionsPressed;
  final ValueChanged<TransactionItemData>? onTransactionPressed;
  final ValueChanged<int>? onNavigationIndexChanged;

  const DashboardScreen({
    super.key,
    this.onScanReceiptPressed,
    this.onCategoriesPressed,
    this.onSetBudgetPressed,
    this.onExportCsvPressed,
    this.onAddExpensePressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onViewAllTransactionsPressed,
    this.onTransactionPressed,
    this.onNavigationIndexChanged,
  });

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentNavIndex = 0;

  void _handleNavigationIndexChanged(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    widget.onNavigationIndexChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            DashboardHeader(
              onNotificationPressed: widget.onNotificationPressed,
              onProfilePressed: widget.onProfilePressed,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const InsightBanner(),
                    const SizedBox(height: 16),
                    const HeroBudgetCard(),
                    const SizedBox(height: 16),
                    QuickActionsRow(
                      onScanReceiptPressed: widget.onScanReceiptPressed ??
                          () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ScanReceiptScreen(),
                                ),
                              ),
                      onCategoriesPressed: widget.onCategoriesPressed,
                      onSetBudgetPressed: widget.onSetBudgetPressed,
                      onExportCsvPressed: widget.onExportCsvPressed,
                    ),
                    const SizedBox(height: 20),
                    const WeeklySpendingChart(),
                    const SizedBox(height: 20),
                    const LifestyleCard(),
                    const SizedBox(height: 20),
                    RecentTransactionsList(
                      onViewAllPressed: widget.onViewAllTransactionsPressed,
                      onTransactionTap: widget.onTransactionPressed,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DashboardBottomNavBar(
        currentIndex: _currentNavIndex,
        onItemSelected: _handleNavigationIndexChanged,
        onAddExpensePressed: widget.onAddExpensePressed ??
            () => AddExpenseSheet.show(context),
      ),
    );
  }
}

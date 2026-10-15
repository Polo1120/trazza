class ActivePeriodBudget {
  final double budgetAmount;
  final double spentAmount;
  final double remainingAmount;
  final double percentageFree;
  final String periodLabel;
  final String periodType;
  final DateTime periodStart;
  final DateTime periodEnd;

  const ActivePeriodBudget({
    required this.budgetAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.percentageFree,
    required this.periodLabel,
    required this.periodType,
    required this.periodStart,
    required this.periodEnd,
  });

  double get spentPercentage => budgetAmount <= 0
      ? 0
      : (spentAmount / budgetAmount).clamp(0.0, 1.0).toDouble();
}

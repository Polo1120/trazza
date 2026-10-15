class BudgetModel {
  final String id;
  final String userId;
  final double amount;
  final String periodType;
  final DateTime? updatedAt;

  const BudgetModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.periodType,
    this.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      periodType: json['period_type'] as String,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'user_id': userId,
      'amount': amount,
      'period_type': periodType,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}

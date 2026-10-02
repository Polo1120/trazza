class ExpenseModel {
  final String? id;
  final String userId;
  final String? categoryId;
  final double amount;
  final DateTime expenseDate;
  final String? description;
  final String? receiptImageUrl;

  const ExpenseModel({
    this.id,
    required this.userId,
    this.categoryId,
    required this.amount,
    required this.expenseDate,
    this.description,
    this.receiptImageUrl,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expense_date'].toString()),
      description: json['description'] as String?,
      receiptImageUrl: json['receipt_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String(),
      'description': description,
      'receipt_image_url': receiptImageUrl,
    };
  }
}

class ExpenseModel {
  final String? id;
  final String userId;
  final String transactionType;
  final String? categoryId;
  final double amount;
  final DateTime expenseDate;
  final String? description;
  final String? paymentMethod;
  final String? receiptImageUrl;

  const ExpenseModel({
    this.id,
    required this.userId,
    this.transactionType = 'expense',
    this.categoryId,
    required this.amount,
    required this.expenseDate,
    this.description,
    this.paymentMethod,
    this.receiptImageUrl,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      transactionType: json['transaction_type'] as String? ?? 'expense',
      categoryId: json['category_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expense_date'].toString()),
      description: json['description'] as String?,
      paymentMethod: json['payment_method'] as String?,
      receiptImageUrl: json['receipt_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'transaction_type': transactionType,
      'category_id': categoryId,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String(),
      'description': description,
      'payment_method': paymentMethod,
      'receipt_image_url': receiptImageUrl,
    };
  }
}

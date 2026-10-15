import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trazza/features/expenses/domain/models/expense_model.dart';

class ExpenseRepository {
  final SupabaseClient client;

  const ExpenseRepository(this.client);

  Future<void> addExpense(ExpenseModel expense) async {
    await client.from('expenses').insert(expense.toJson());
  }

  Future<List<ExpenseModel>> getExpenses() async {
    final user = client.auth.currentUser;
    if (user == null) return [];

    final rows = await client
        .from('expenses')
        .select()
        .eq('user_id', user.id)
        .order('expense_date', ascending: false);

    return rows.map(ExpenseModel.fromJson).toList();
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trazza/features/budget/domain/models/budget_model.dart';

class BudgetRepository {
  final SupabaseClient client;

  const BudgetRepository(this.client);

  Future<BudgetModel?> getBudget(String userId) async {
    final row = await client
        .from('budgets')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return row == null ? null : BudgetModel.fromJson(row);
  }

  Future<BudgetModel> upsertBudget(BudgetModel budget) async {
    final row = await client
        .from('budgets')
        .upsert(budget.toJson(), onConflict: 'user_id')
        .select()
        .single();
    return BudgetModel.fromJson(row);
  }
}

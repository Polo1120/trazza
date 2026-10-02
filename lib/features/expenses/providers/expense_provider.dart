import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trazza/core/providers/supabase_client_provider.dart';
import 'package:trazza/features/expenses/data/expense_repository.dart';
import 'package:trazza/features/expenses/domain/models/expense_model.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref.watch(supabaseClientProvider));
});

final expensesProvider = FutureProvider<List<ExpenseModel>>((ref) {
  return ref.watch(expenseRepositoryProvider).getExpenses();
});

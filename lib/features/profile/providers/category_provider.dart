import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trazza/core/providers/supabase_client_provider.dart';
import 'package:trazza/features/profile/data/category_repository.dart';
import 'package:trazza/features/profile/domain/models/category_model.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(supabaseClientProvider));
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});

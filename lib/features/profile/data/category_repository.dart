import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trazza/features/profile/domain/models/category_model.dart';

class CategoryRepository {
  final SupabaseClient client;

  const CategoryRepository(this.client);

  Future<List<CategoryModel>> getCategories() async {
    final rows = await client.from('categories').select().order('name');
    return rows.map(CategoryModel.fromJson).toList();
  }
}

class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String iconName;
  final String colorHex;
  final bool isCustom;

  const CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.isCustom,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      isCustom: json['is_custom'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'icon_name': iconName,
      'color_hex': colorHex,
      'is_custom': isCustom,
    };
  }
}

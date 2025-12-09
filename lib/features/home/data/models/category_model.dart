class CategoryModel {
  final int categoryId;
  final String name;
  final String description;
  final int incidentCount;

  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.incidentCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json['category_id'],
      name: json['name'],
      description: json['description'],
      incidentCount: json['_count']['incidents'],
    );
  }
}

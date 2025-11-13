class CategoryModel {
  String categoryUid;
  String name;
  String imageUrl;
  CategoryModel({
    required this.categoryUid,
    required this.imageUrl,
    required this.name,
  });
  Map<String, dynamic> toMap() {
    return {
      "categoryUid": categoryUid,
      "name": name,
      "imageUrl": imageUrl,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryUid: map['categoryUid'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      name: map['name'] ?? 'Unknown',
    );
  }
}

class CategoryModel {
  String categoryUid;
  String name;
  List<String> imageUrls; // Changed from single imageUrl

  CategoryModel({
    required this.categoryUid,
    required this.name,
    required this.imageUrls,
  });

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      "categoryUid": categoryUid,
      "name": name,
      "imageUrls": imageUrls, // store as array
    };
  }

  /// Create model from Map (Firestore)
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryUid: map['categoryUid'] ?? '',
      name: map['name'] ?? 'Unknown',
      imageUrls: List<String>.from(
        map['imageUrls'] ?? [],
      ), // default empty list
    );
  }
}

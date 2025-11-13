import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItemModel {
  final String foodItemId;
  final String name;
  final String imageUrl;
  final int prepTimeMinutes; // preparation time in minutes
  final double calories; // calorie count
  final String description; // description text
  final double price; // full price
  final String category; // category name only
  final bool isCompo; // true = combo, false = individual
  final bool isTodayOffer; // true if under “Today Offer”
  final bool isHalfAvailable; // whether half portion exists
  final double? halfPrice; // nullable; only if half available
  final bool isBestSeller; // bestseller flag

  const FoodItemModel({
    required this.foodItemId,
    required this.name,
    required this.imageUrl,
    this.prepTimeMinutes = 0,
    this.calories = 0.0,
    this.description = "",
    this.price = 0.0,
    this.category = "",
    this.isCompo = false,
    this.isTodayOffer = false,
    this.isHalfAvailable = false,
    this.halfPrice,
    this.isBestSeller = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "foodItemId": foodItemId,
      "name": name,
      "imageUrl": imageUrl,
      "prepTimeMinutes": prepTimeMinutes,
      "calories": calories,
      "description": description,
      "price": price,
      "category": category,
      "isCompo": isCompo,
      "isTodayOffer": isTodayOffer,
      "isHalfAvailable": isHalfAvailable,
      "halfPrice": halfPrice,
      "isBestSeller": isBestSeller,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  factory FoodItemModel.fromMap(Map<String, dynamic> map) {
    return FoodItemModel(
      foodItemId: map["foodItemId"] ?? "",
      name: map["name"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      prepTimeMinutes: map["prepTimeMinutes"] is int
          ? map["prepTimeMinutes"]
          : int.tryParse(map["prepTimeMinutes"]?.toString() ?? "0") ?? 0,
      calories: (map["calories"] as num?)?.toDouble() ?? 0.0,
      description: map["description"] ?? "",
      price: (map["price"] as num?)?.toDouble() ?? 0.0,
      category: map["category"] ?? "",
      isCompo: map["isCompo"] ?? false,
      isTodayOffer: map["isTodayOffer"] ?? false,
      isHalfAvailable: map["isHalfAvailable"] ?? false,
      halfPrice: (map["halfPrice"] as num?)?.toDouble(),
      isBestSeller: map["isBestSeller"] ?? false,
    );
  }

  FoodItemModel copyWith({
    String? foodItemId,
    String? name,
    String? imageUrl,
    int? prepTimeMinutes,
    double? calories,
    String? description,
    double? price,
    String? category,
    bool? isCompo,
    bool? isTodayOffer,
    bool? isHalfAvailable,
    double? halfPrice,
    bool? isBestSeller,
  }) {
    return FoodItemModel(
      foodItemId: foodItemId ?? this.foodItemId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      calories: calories ?? this.calories,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isCompo: isCompo ?? this.isCompo,
      isTodayOffer: isTodayOffer ?? this.isTodayOffer,
      isHalfAvailable: isHalfAvailable ?? this.isHalfAvailable,
      halfPrice: halfPrice ?? this.halfPrice,
      isBestSeller: isBestSeller ?? this.isBestSeller,
    );
  }
}

class OrderFoodModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double halfPrice;
  final int quantity;
  final bool isHalf;
  final bool isHalfAvailable;
  final bool isTodayOffer;

  const OrderFoodModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.halfPrice,
    required this.quantity,
    required this.isHalf,
    required this.isHalfAvailable,
    required this.isTodayOffer,
  });

  double get unitPrice => isHalf && isHalfAvailable ? halfPrice : price;
  double get totalPrice => unitPrice * quantity;
  String get plateLabel =>
      isHalfAvailable ? (isHalf ? "Half" : "Full") : "Full";

  factory OrderFoodModel.fromMap(Map<String, dynamic> map) {
    return OrderFoodModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '-',
      imageUrl: map['imageUrl']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      halfPrice: (map['halfPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      isHalf: map['isHalf'] == true,
      isHalfAvailable: map['isHalfAvailable'] == true,
      isTodayOffer: map['isTodayOffer'] == true,
    );
  }
}

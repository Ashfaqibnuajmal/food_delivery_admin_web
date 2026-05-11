import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/orders/data/model/order_food_model.dart';

class OrderModel {
  final String orderId;
  final String userName;
  final String phoneNumber;
  final String deliveryAddress;
  final String orderStatus;
  final String paymentMethod;
  final double subTotal;
  final double discount;
  final double totalAmount;
  final String formattedDate;
  final List<OrderFoodModel> foodItems;

  const OrderModel({
    required this.orderId,
    required this.userName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.orderStatus,
    required this.paymentMethod,
    required this.subTotal,
    required this.discount,
    required this.totalAmount,
    required this.formattedDate,
    required this.foodItems,
  });

  String get shortOrderId {
    return orderId.length > 8
        ? '#${orderId.substring(0, 8).toUpperCase()}'
        : '#$orderId';
  }

  String formatAmount(double val) {
    return val % 1 == 0 ? '₹${val.toInt()}' : '₹$val';
  }

  String get formattedSubTotal => formatAmount(subTotal);
  String get formattedDiscount => formatAmount(discount);
  String get formattedTotal => formatAmount(totalAmount);

  factory OrderModel.fromMap(String docId, Map<String, dynamic> map) {
    // Parse date
    String formattedDate = "Unknown";
    try {
      final raw = map['createdAt'];
      DateTime dt;
      if (raw is Timestamp) {
        dt = raw.toDate();
      } else if (raw is String) {
        dt = DateTime.parse(raw);
      } else {
        throw Exception();
      }
      formattedDate = DateFormat('MMM dd, yyyy — hh:mm a').format(dt);
    } catch (_) {
      formattedDate = "Invalid date";
    }

    // Parse food items
    final rawItems = map['foodItems'] as List<dynamic>? ?? [];
    final foodItems = rawItems
        .map((e) => OrderFoodModel.fromMap(e as Map<String, dynamic>))
        .toList();

    return OrderModel(
      orderId: docId,
      userName: map['userName']?.toString() ?? '-',
      phoneNumber: map['phoneNumber']?.toString() ?? '-',
      deliveryAddress: map['deliveryAddress']?.toString() ?? '-',
      orderStatus: map['orderStatus']?.toString() ?? 'Making',
      paymentMethod: map['paymentMethod']?.toString() ?? '-',
      subTotal: (map['subTotal'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      formattedDate: formattedDate,
      foodItems: foodItems,
    );
  }
}

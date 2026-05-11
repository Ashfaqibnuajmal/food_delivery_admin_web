import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/orders/data/model/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream a single order by ID
  Stream<OrderModel> getOrderById(String orderId) {
    return _firestore.collection('Orders').doc(orderId).snapshots().map((doc) {
      if (!doc.exists) throw Exception("Order not found");
      return OrderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    });
  }

  /// Stream all orders, newest first
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection('Orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('Orders').doc(orderId).update({
      'orderStatus': newStatus,
    });
  }
}

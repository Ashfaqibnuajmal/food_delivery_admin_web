import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/dashboard/data/models/order_stat_model.dart';

class DashboardStatsService {
  final FirebaseFirestore _firestore;

  DashboardStatsService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  String _dateOnly(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  num _toNumber(dynamic value) {
    if (value is num) return value;

    if (value is String) {
      return num.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    }

    return 0;
  }

  Stream<OrderStatModel> ordersBetweenStream({
    required DateTime start,
    required DateTime end,
  }) {
    return _firestore
        .collection('Orders')
        .where('createdAt', isGreaterThanOrEqualTo: _dateOnly(start))
        .where('createdAt', isLessThan: _dateOnly(end))
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs;

          // count all orders regardless of status
          final ordersCount = orders.length;

          // sum totalAmount only for Delivered orders
          final salesTotal = orders
              .where((doc) => doc.data()['orderStatus'] == 'Delivered')
              .fold<num>(
                0,
                (sum, doc) => sum + _toNumber(doc.data()['totalAmount']),
              );

          return OrderStatModel(
            ordersCount: ordersCount,
            salesTotal: salesTotal,
          );
        });
  }

  Stream<num> dueBalanceStream() {
    return _firestore.collection('DueUsers').snapshots().map((snapshot) {
      return snapshot.docs.fold<num>(
        0,
        // ignore: avoid_types_as_parameter_names
        (sum, doc) => sum + _toNumber(doc.data()['balance']),
      );
    });
  }

  Stream<int> usersCountStream() {
    return _firestore
        .collection('Users')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  String trendText(num current, num previous) {
    if (previous == 0 && current == 0) return '0%';
    if (previous == 0) return '+100%';

    final percent = ((current - previous) / previous) * 100;
    final prefix = percent >= 0 ? '+' : '';

    return '$prefix${percent.toStringAsFixed(1)}%';
  }

  bool trendUp(num current, num previous) {
    return current >= previous;
  }

  Future<Map<String, int>> getOrderStatusCounts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .get();

    final Map<String, int> counts = {
      'Making': 0,
      'Packing': 0,
      'Out for Delivery': 0,
      'Delivered': 0,
    };

    for (final doc in snapshot.docs) {
      final status = doc.data()['orderStatus'] as String? ?? '';
      if (counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
      }
    }

    return counts;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/dashboard/data/models/dashboard_models.dart';

class DashboardService {
  final FirebaseFirestore _firestore;

  DashboardService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  String _dateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
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

          final salesTotal = orders
              .where((doc) => doc.data()['orderStatus'] == 'Delivered')
              .fold<num>(
                0,
                (sum, doc) => sum + _toNumber(doc.data()['totalAmount']),
              );

          return OrderStatModel(
            ordersCount: orders.length,
            salesTotal: salesTotal,
          );
        });
  }

  Stream<num> dueBalanceStream() {
    return _firestore
        .collection('DueUsers')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<num>(
            0,
            (sum, doc) => sum + _toNumber(doc.data()['balance']),
          ),
        );
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

  bool trendUp(num current, num previous) => current >= previous;

  Future<Map<String, int>> getOrderStatusCounts() async {
    final snapshot = await _firestore.collection('Orders').get();

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

  Future<List<DailyRevenue>> getWeeklyRevenue() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    final snapshot = await _firestore
        .collection('Orders')
        .where('createdAt', isGreaterThanOrEqualTo: weekStart.toIso8601String())
        .get();

    final Map<int, double> dayTotals = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0,
    };

    for (final doc in snapshot.docs) {
      final data = doc.data();
      if ((data['orderStatus'] as String? ?? '') != 'Delivered') continue;

      final createdAtStr = data['createdAt'] as String? ?? '';
      if (createdAtStr.isEmpty) continue;

      final createdAt = DateTime.tryParse(createdAtStr);
      if (createdAt == null) continue;

      final totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;

      if (createdAt.isAfter(weekStart.subtract(const Duration(seconds: 1)))) {
        dayTotals[createdAt.weekday] =
            (dayTotals[createdAt.weekday] ?? 0) + totalAmount;
      }
    }

    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return List.generate(7, (i) {
      return DailyRevenue(
        day: dayNames[i],
        totalAmount: dayTotals[i + 1] ?? 0.0,
        date: weekStart.add(Duration(days: i)),
      );
    });
  }

  Future<double> getMonthlyTotal() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    final snapshot = await _firestore
        .collection('Orders')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: monthStart.toIso8601String(),
        )
        .get();

    double total = 0.0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if ((data['orderStatus'] as String?) != 'Delivered') continue;
      total += (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }
}

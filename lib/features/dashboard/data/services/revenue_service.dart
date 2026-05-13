import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/dashboard/data/models/daily_revenue.dart';

class RevenueService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DailyRevenue>> getWeeklyRevenue() async {
    final now = DateTime.now();

    // Find this week's Monday (weekday: 1=Mon ... 7=Sun)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    // Fetch ALL orders from this week onwards
    // createdAt is stored as ISO string → string compare works correctly
    final snapshot = await _firestore
        .collection('Orders')
        .where('createdAt', isGreaterThanOrEqualTo: weekStart.toIso8601String())
        .get();

    // Initialize all 7 days with 0
    // Map key = weekday number (1=Mon, 7=Sun)
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

      // Only count Delivered orders
      final status = data['orderStatus'] as String? ?? '';
      if (status != 'Delivered') continue;

      final createdAtStr = data['createdAt'] as String? ?? '';
      if (createdAtStr.isEmpty) continue;

      final createdAt = DateTime.tryParse(createdAtStr);
      if (createdAt == null) continue;

      final totalAmount = (data['totalAmount'] as num?)?.toDouble() ?? 0.0;
      final weekday = createdAt.weekday; // 1=Mon, 7=Sun

      // Only count if within this week
      if (createdAt.isAfter(weekStart.subtract(const Duration(seconds: 1)))) {
        dayTotals[weekday] = (dayTotals[weekday] ?? 0) + totalAmount;
      }
    }

    // Build list from Mon → Sun
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return List.generate(7, (i) {
      final weekday = i + 1; // 1=Mon ... 7=Sun
      return DailyRevenue(
        day: dayNames[i],
        totalAmount: dayTotals[weekday] ?? 0.0,
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
}

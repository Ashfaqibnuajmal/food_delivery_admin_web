import 'package:user_app/features/dashboard/data/models/order_stat_model.dart';
import 'package:user_app/features/dashboard/data/services/dashboard_stat_service.dart';

class DashboardStatController {
  final DashboardStatsService _statsService;

  DashboardStatController({DashboardStatsService? statsService})
    : _statsService = statsService ?? DashboardStatsService();

  Stream<OrderStatModel> getTodayStats() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    return _statsService.ordersBetweenStream(
      start: todayStart,
      end: tomorrowStart,
    );
  }

  Stream<OrderStatModel> getYesterdayStats() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    return _statsService.ordersBetweenStream(
      start: yesterdayStart,
      end: todayStart,
    );
  }

  Stream<num> getDueBalance() {
    return _statsService.dueBalanceStream();
  }

  Stream<int> getUsersCount() {
    return _statsService.usersCountStream();
  }

  String trendText(num current, num previous) {
    return _statsService.trendText(current, previous);
  }

  bool trendUp(num current, num previous) {
    return _statsService.trendUp(current, previous);
  } // cache it so StatelessWidget rebuilds don't re-fetch

  Future<Map<String, int>>? _orderStatusFuture;

  Future<Map<String, int>> getOrderStatusCounts() {
    _orderStatusFuture ??= _statsService.getOrderStatusCounts();
    return _orderStatusFuture!;
  }
}

import 'package:user_app/features/dashboard/data/models/dashboard_models.dart';
import 'package:user_app/features/dashboard/data/services/dashboard_service.dart';

class DashboardController {
  final DashboardService _service;

  DashboardController({DashboardService? service})
    : _service = service ?? DashboardService();

  Stream<OrderStatModel> getTodayStats() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    return _service.ordersBetweenStream(start: todayStart, end: tomorrowStart);
  }

  Stream<OrderStatModel> getYesterdayStats() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    return _service.ordersBetweenStream(start: yesterdayStart, end: todayStart);
  }

  Stream<num> getDueBalance() => _service.dueBalanceStream();

  Stream<int> getUsersCount() => _service.usersCountStream();

  String trendText(num current, num previous) =>
      _service.trendText(current, previous);

  bool trendUp(num current, num previous) =>
      _service.trendUp(current, previous);

  Future<Map<String, int>>? _orderStatusFuture;

  Future<Map<String, int>> getOrderStatusCounts() {
    _orderStatusFuture ??= _service.getOrderStatusCounts();
    return _orderStatusFuture!;
  }

  Future<(List<DailyRevenue>, double)>? _revenueFuture;

  Future<(List<DailyRevenue>, double)> getRevenueData() {
    _revenueFuture ??=
        Future.wait([
          _service.getWeeklyRevenue(),
          _service.getMonthlyTotal(),
        ]).then(
          (results) => (results[0] as List<DailyRevenue>, results[1] as double),
        );
    return _revenueFuture!;
  }

  double getMaxAmount(List<DailyRevenue> data) {
    if (data.isEmpty) return 1.0;
    return data.map((e) => e.totalAmount).reduce((a, b) => a > b ? a : b);
  }

  double getWeekTotal(List<DailyRevenue> data) {
    return data.fold(0.0, (sum, e) => sum + e.totalAmount);
  }

  double getBarHeight(double amount, double maxAmount) {
    if (maxAmount <= 0) return 3.0;
    return ((amount / maxAmount) * 80).clamp(amount > 0 ? 5.0 : 3.0, 80.0);
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day && date.month == now.month;
  }

  void refresh() {
    _revenueFuture = null;
    _orderStatusFuture = null;
  }
}

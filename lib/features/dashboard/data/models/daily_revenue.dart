class DailyRevenue {
  final String day; // "Mon", "Tue", etc.
  final double totalAmount; // sum of all orders that day
  final DateTime date; // actual date of that day

  DailyRevenue({
    required this.day,
    required this.totalAmount,
    required this.date,
  });
}

import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/features/dashboard/controller/dashboard_stat_controller.dart';
import 'package:user_app/features/dashboard/model/order_stat_model.dart';
import 'package:user_app/features/dashboard/presentation/widgets/stat_card.dart';

class StatCardsRow extends StatelessWidget {
  const StatCardsRow({super.key});

  static final DashboardStatController _controller = DashboardStatController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderStatModel>(
      stream: _controller.getTodayStats(),
      builder: (context, todaySnapshot) {
        if (todaySnapshot.connectionState == ConnectionState.waiting) {
          return const StatsLoadingRow();
        }

        if (todaySnapshot.hasError) {
          return Text(
            'Unable to load stats: ${todaySnapshot.error}',
            style: CustomTextStyles.mediumWhiteText,
          );
        }

        final todayStats =
            todaySnapshot.data ??
            const OrderStatModel(ordersCount: 0, salesTotal: 0);

        return StreamBuilder<OrderStatModel>(
          stream: _controller.getYesterdayStats(),
          builder: (context, yesterdaySnapshot) {
            final yesterdayStats =
                yesterdaySnapshot.data ??
                const OrderStatModel(ordersCount: 0, salesTotal: 0);

            return Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: "Orders Today",
                    value: todayStats.ordersCount.toString(),
                    icon: Icons.shopping_bag_rounded,
                    trend: _controller.trendText(
                      todayStats.ordersCount,
                      yesterdayStats.ordersCount,
                    ),
                    trendUp: _controller.trendUp(
                      todayStats.ordersCount,
                      yesterdayStats.ordersCount,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: "Sales Today",
                    value: "₹${todayStats.salesTotal.toStringAsFixed(0)}",
                    icon: Icons.payments_rounded,
                    trend: _controller.trendText(
                      todayStats.salesTotal,
                      yesterdayStats.salesTotal,
                    ),
                    trendUp: _controller.trendUp(
                      todayStats.salesTotal,
                      yesterdayStats.salesTotal,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StreamBuilder<num>(
                    stream: _controller.getDueBalance(),
                    builder: (context, snapshot) {
                      final dueBalance = snapshot.data ?? 0;

                      return StatCard(
                        title: "Due Balance",
                        value: "₹${dueBalance.toStringAsFixed(0)}",
                        icon: Icons.account_balance_wallet_rounded,
                        trend: "Pending",
                        trendUp: false,
                        showTrendIcon: false,
                        footerText: "from due users",
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StreamBuilder<int>(
                    stream: _controller.getUsersCount(),
                    builder: (context, snapshot) {
                      final totalUsers = snapshot.data ?? 0;

                      return StatCard(
                        title: "Total Users",
                        value: totalUsers.toString(),
                        icon: Icons.people_alt_rounded,
                        trend: "Users",
                        trendUp: true,
                        showTrendIcon: false,
                        footerText: "registered",
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

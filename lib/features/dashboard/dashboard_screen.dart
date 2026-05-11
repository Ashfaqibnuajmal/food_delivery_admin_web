import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _TopBar(),

              SizedBox(height: 24),

              // ── STAT CARDS
              _StatCardsRow(),

              SizedBox(height: 20),

              // ── REVENUE + ORDER STATUS
              _DashboardSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final greeting = now.hour < 12
        ? "Good Morning"
        : now.hour < 17
        ? "Good Afternoon"
        : "Good Evening";

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              greeting,
              style: TextStyle(
                color: AppColors.pureWhite.withOpacity(0.45),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            const Text("Dashboard", style: CustomTextStyles.loginHeading),
          ],
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.deepBlue.withOpacity(0.55),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.darkBlue,
                  size: 14,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                "${now.day} ${_monthName(now.month)} ${now.year}",
                style: TextStyle(
                  color: AppColors.pureWhite.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month];
  }
}

// ─────────────────────────────────────────────
// STAT CARDS ROW
// ─────────────────────────────────────────────

class _StatCardsRow extends StatelessWidget {
  const _StatCardsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatCard(
            title: "Orders Today",
            value: "37",
            icon: Icons.shopping_bag_rounded,
            trend: "+12%",
            trendUp: true,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: _StatCard(
            title: "Sales Today",
            value: "₹4,837",
            icon: Icons.payments_rounded,
            trend: "+8.3%",
            trendUp: true,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: _StatCard(
            title: "Due Balance",
            value: "₹7,034",
            icon: Icons.account_balance_wallet_rounded,
            trend: "-2.1%",
            trendUp: false,
          ),
        ),

        SizedBox(width: 12),

        Expanded(
          child: _StatCard(
            title: "Active Users",
            value: "243",
            icon: Icons.people_alt_rounded,
            trend: "+5",
            trendUp: true,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String trend;
  final bool trendUp;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = trendUp ? AppColors.green : AppColors.errorRed;

    return Container(
      height: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mediumBlue.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.pureWhite.withOpacity(0.55),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.darkBlue, size: 16),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.pureWhite,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trendColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      color: trendColor,
                      size: 12,
                    ),

                    const SizedBox(width: 4),

                    Text(
                      trend,
                      style: TextStyle(
                        color: trendColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  "vs yesterday",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.pureWhite.withOpacity(0.3),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DASHBOARD SECTION
// ─────────────────────────────────────────────

class _DashboardSection extends StatelessWidget {
  const _DashboardSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          flex: 3,
          child: _SectionCard(
            title: "Revenue Overview",
            icon: Icons.bar_chart_rounded,
            height: 300,
            child: _RevenueChart(),
          ),
        ),

        SizedBox(width: 16),

        Expanded(
          flex: 2,
          child: _SectionCard(
            title: "Order Status",
            icon: Icons.donut_large_rounded,
            height: 300,
            child: _OrderStatusSection(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// SECTION CARD
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final double height;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.lightBlue, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.pureWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          Divider(color: AppColors.lightBlue.withOpacity(0.12), height: 24),

          Expanded(child: child),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REVENUE CHART
// ─────────────────────────────────────────────

class _RevenueChart extends StatelessWidget {
  const _RevenueChart();

  @override
  Widget build(BuildContext context) {
    final data = [180, 320, 240, 410, 290, 480, 370];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(data.length, (i) {
        final value = data[i];
        final height = value / 3;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "₹$value",
                  style: TextStyle(
                    color: AppColors.pureWhite.withOpacity(0.4),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.lightBlue,
                        AppColors.lightBlue.withOpacity(0.15),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  days[i],
                  style: TextStyle(
                    color: AppColors.pureWhite.withOpacity(0.45),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ─────────────────────────────────────────────
// ORDER STATUS
// ─────────────────────────────────────────────

class _OrderStatusSection extends StatelessWidget {
  const _OrderStatusSection();

  @override
  Widget build(BuildContext context) {
    final statuses = [
      _StatusItem("Making", 14, AppColors.lightBlue),

      _StatusItem("Packing", 8, AppColors.lightBlue.withOpacity(0.85)),

      _StatusItem("Delivery", 9, AppColors.lightBlue.withOpacity(0.7)),

      _StatusItem("Delivered", 37, AppColors.lightBlue.withOpacity(0.55)),
    ];

    final total = statuses.fold<int>(0, (sum, e) => sum + e.count);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: statuses.map((e) {
        final progress = e.count / total;

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: e.color,
                      shape: BoxShape.circle,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      e.label,
                      style: TextStyle(
                        color: AppColors.pureWhite.withOpacity(0.75),
                        fontSize: 12,
                      ),
                    ),
                  ),

                  Text(
                    "${e.count}",
                    style: TextStyle(
                      color: e.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.pureWhite.withOpacity(0.08),
                valueColor: AlwaysStoppedAnimation<Color>(e.color),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatusItem {
  final String label;
  final int count;
  final Color color;

  const _StatusItem(this.label, this.count, this.color);
}

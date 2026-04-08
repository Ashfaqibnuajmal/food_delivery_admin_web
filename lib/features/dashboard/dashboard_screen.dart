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
            children: [
              const Text("Dashboard", style: CustomTextStyles.buttonText),

              const SizedBox(height: 20),

              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _statCard(
                    title: "Order Today",
                    value: "37",
                    icon: const Icon(
                      Icons.shopping_bag,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  _statCard(
                    title: "Sales Today",
                    value: "4837.00",
                    icon: const Icon(
                      Icons.attach_money,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  _statCard(
                    title: "Total Due Balance",
                    value: "7034.00",
                    icon: const Icon(
                      Icons.account_balance_wallet,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  _statCard(
                    title: "Active Users",
                    value: "243",
                    icon: const Icon(Icons.people, color: AppColors.pureWhite),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ================= REVENUE OVERVIEW =================
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 260,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mediumBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Revenue Overview",
                            style: CustomTextStyles.header,
                          ),
                          const SizedBox(height: 16),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Line Chart (Static)",
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // ================= ORDER STATUS =================
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 260,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mediumBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Status", style: CustomTextStyles.header),
                          const SizedBox(height: 20),

                          Row(
                            children: [
                              // Pie chart placeholder
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.darkBlue,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Pie\nChart",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 16),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _legendItem("Pending", Colors.blue),
                                  _legendItem("Processing", Colors.green),
                                  _legendItem("Delivered", Colors.purple),
                                  _legendItem("Cancelled", Colors.red),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPER UI =================

  Widget _statCard({
    required String title,
    required String value,
    required Icon icon,
  }) {
    return Container(
      width: 200,
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.mediumBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: CustomTextStyles.header),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: icon,
                ),
              ],
            ),
            const Spacer(),
            Text(value, style: CustomTextStyles.header),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

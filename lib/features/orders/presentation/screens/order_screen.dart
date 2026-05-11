// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/provider/user_search_provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/core/widgets/voice_search_bar.dart';
import 'package:user_app/features/orders/enum/order_status.dart';
import 'package:user_app/features/orders/presentation/widgets/order_screen/order_table_body.dart';
import 'package:user_app/features/orders/presentation/widgets/order_screen/order_table_header.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  final List<String> orderStatuses = OrderStatus.values
      .map((status) => status.label)
      .toList();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Management",
              style: CustomTextStyles.loginHeading,
            ),
            const SizedBox(height: 40),
            const VoiceSearchBar(),
            const SizedBox(height: 40),
            const OrderTableHeader(),
            const SizedBox(height: 6),

            // ✅ Expanded goes here so the table fills remaining space
            Expanded(
              child: Consumer<UserSearchProvider>(
                builder: (context, searchProvider, _) {
                  return OrderTableBody(
                    orderStatuses: orderStatuses,
                    searchQuery: searchProvider.query,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

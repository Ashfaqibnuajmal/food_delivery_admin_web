import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/orders/presentation/widgets/order_screen/order_table_row.dart';
import 'package:user_app/features/orders/provider/order_status_provider.dart';

class OrderTableBody extends StatelessWidget {
  final String searchQuery;
  final List<String> orderStatuses;

  const OrderTableBody({
    super.key,
    required this.orderStatuses,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Orders')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Orders yet!", style: CustomTextStyles.nameStyle),
            );
          }

          final orderDocs = snapshot.data!.docs;
          final filtered = searchQuery.trim().isEmpty
              ? orderDocs
              : orderDocs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>? ?? {};
                  final name = data['userName']?.toString().toLowerCase() ?? '';
                  return name.contains(searchQuery.toLowerCase().trim());
                }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    color: AppColors.pureWhite.withOpacity(0.3),
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No order found for "$searchQuery"',
                    style: TextStyle(
                      color: AppColors.pureWhite.withOpacity(0.5),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final doc = filtered[index];

              final orderId = doc.id;

              final data = doc.data() as Map<String, dynamic>? ?? {};

              // Firebase fields
              final userName = data['userName']?.toString() ?? '-';

              final phoneNumber = data['phoneNumber']?.toString() ?? '-';

              final paymentMethod = data['paymentMethod']?.toString() ?? '-';

              final initialStatus = data['orderStatus']?.toString() ?? 'Making';

              final rawAddress = data['deliveryAddress']?.toString() ?? '-';

              // Amount formatting
              final num rawAmount = (data['totalAmount'] as num?) ?? 0;

              final String formattedAmount = rawAmount % 1 == 0
                  ? '₹${rawAmount.toInt()}'
                  : '₹$rawAmount';

              // Food items
              final foodItems = data['foodItems'] as List<dynamic>? ?? [];

              return ChangeNotifierProvider(
                key: ValueKey(orderId),
                create: (_) => OrderStatusProvider(
                  orderId: orderId,
                  selectedStatus: initialStatus,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: OrderTableRow(
                    index: index,
                    userName: userName,
                    rawAddress: rawAddress,
                    phoneNumber: phoneNumber,
                    foodItems: foodItems,
                    formattedAmount: formattedAmount,
                    paymentMethod: paymentMethod,
                    orderStatuses: orderStatuses,
                    orderId: orderId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

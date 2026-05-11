import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/orders/data/model/order_food_model.dart';
import 'package:user_app/features/orders/data/model/order_model.dart';
import 'package:user_app/features/orders/data/repository/order_repository.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/order_details_header.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/order_info_card.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/order_item_row.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/order_item_table_header.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/price_summary_card.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/user_info_card.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderid;

  OrderDetailsScreen({super.key, required this.orderid});

  final OrderRepository _repository = OrderRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: StreamBuilder<OrderModel>(
          stream: _repository.getOrderById(orderid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 400,
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.lightBlue),
                ),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text(
                  "Order not found!",
                  style: TextStyle(color: AppColors.pureWhite),
                ),
              );
            }

            final order = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const OrderDetailsHeader(),
                const SizedBox(height: 30),

                // ── TOP 3 CARDS
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderInfoCard(
                      shortOrderId: order.shortOrderId,
                      formattedDate: order.formattedDate,
                      status: order.orderStatus,
                      paymentMethod: order.paymentMethod,
                    ),
                    const SizedBox(width: 16),
                    PriceSummaryCard(
                      subtotal: order.formattedSubTotal,
                      discount: order.formattedDiscount,
                      totalAmount: order.formattedTotal,
                    ),
                    const SizedBox(width: 16),
                    UserInfoCard(
                      name: order.userName,
                      phone: order.phoneNumber,
                      address: order.deliveryAddress,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ── ITEMS TABLE
                const OrderItemsTableHeader(),

                if (order.foodItems.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    alignment: Alignment.center,
                    child: Text(
                      "No items found",
                      style: TextStyle(
                        color: AppColors.pureWhite.withOpacity(0.4),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: order.foodItems.length,
                    itemBuilder: (context, index) {
                      final OrderFoodModel item = order.foodItems[index];
                      return OrderItemRow(
                        index: index,
                        itemName: item.name,
                        plateLabel: item.plateLabel,
                        quantity: item.quantity,
                        unitPrice: item.unitPrice,
                        isTodayOffer: item.isTodayOffer,
                        totalPrice: item.totalPrice,
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

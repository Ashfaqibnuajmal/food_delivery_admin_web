import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/orders/presentation/screens/order_details_screen.dart';
import 'package:user_app/features/orders/provider/order_status_provider.dart';

class OrderTableRow extends StatelessWidget {
  final int index;
  final String userName;
  final String rawAddress;
  final String phoneNumber;
  final List<dynamic> foodItems;
  final String formattedAmount;
  final String paymentMethod;
  final List<String> orderStatuses;
  final String orderId;

  const OrderTableRow({
    super.key,
    required this.index,
    required this.userName,
    required this.rawAddress,
    required this.phoneNumber,
    required this.foodItems,
    required this.formattedAmount,
    required this.paymentMethod,
    required this.orderStatuses,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // #
        Expanded(
          flex: 1,
          child: Text(
            '${index + 1}',
            textAlign: TextAlign.center,
            style: CustomTextStyles.lightWhite,
          ),
        ),

        // User
        Expanded(
          flex: 2,
          child: Text(
            userName,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.lightWhite,
          ),
        ),

        // Location
        Expanded(
          flex: 2,
          child: Text(
            rawAddress,
            textAlign: TextAlign.center,
            softWrap: true,
            style: CustomTextStyles.lightWhite,
          ),
        ),

        // Phone
        Expanded(
          flex: 2,
          child: Text(
            phoneNumber,
            textAlign: TextAlign.center,
            style: CustomTextStyles.lightWhite,
          ),
        ),

        // Items
        Expanded(
          flex: 3,
          child: Text(
            foodItems.isEmpty
                ? '-'
                : foodItems
                      .map((item) => item['name']?.toString() ?? '')
                      .where((name) => name.isNotEmpty)
                      .join(', '),
            textAlign: TextAlign.center,
            softWrap: true,
            style: CustomTextStyles.lightWhite,
          ),
        ),

        // Amount
        Expanded(
          flex: 2,
          child: Text(
            formattedAmount,
            textAlign: TextAlign.center,
            style: CustomTextStyles.viewStyle,
          ),
        ),

        // Payment
        Expanded(
          flex: 2,
          child: Text(
            paymentMethod,
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(color: AppColors.errorRed),
          ),
        ),

        // Action dropdown
        Expanded(
          flex: 3,
          child: Center(
            child: Consumer<OrderStatusProvider>(
              builder: (context, provider, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.pureWhite.withOpacity(0.3),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pureWhite.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        dropdownColor: AppColors.darkBlue,
                        value: provider.selectedStatus,
                        icon: const Icon(
                          Icons.arrow_drop_down_rounded,
                          color: AppColors.pureWhite,
                        ),
                        style: CustomTextStyles.bigWhiteText,
                        onChanged: provider.isUpdating
                            ? null
                            : (selected) {
                                if (selected != null) {
                                  provider.updateStatus(selected, context);
                                }
                              },
                        items: orderStatuses.map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: AppColors.pureWhite,
                                  size: 10,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    s,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // View
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsScreen(orderid: orderId),
                ),
              );
            },
            child: const Text(
              "View",
              textAlign: TextAlign.center,
              style: CustomTextStyles.viewStyle,
            ),
          ),
        ),
      ],
    );
  }
}

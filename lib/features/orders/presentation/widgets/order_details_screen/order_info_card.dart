import 'package:flutter/material.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';
import 'package:user_app/features/orders/presentation/widgets/order_details_screen/info_card.dart';

class OrderInfoCard extends StatelessWidget {
  final String shortOrderId;
  final String formattedDate;
  final String status;
  final String paymentMethod;

  const OrderInfoCard({
    super.key,
    required this.shortOrderId,
    required this.formattedDate,
    required this.status,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Expanded(
      flex: 3,
      child: InfoCard(
        icon: Icons.receipt_long,
        title: "Order Info",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shortOrderId, style: CustomTextStyles.nameStyle),

            const SizedBox(height: 6),

            Text(formattedDate, style: CustomTextStyles.mediumWhiteText),

            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // STATUS PILL
                SizedBox(
                  width: isMobile ? 120 : 140,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.pureWhite.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),

                // PAYMENT PILL
                SizedBox(
                  width: isMobile ? 120 : 140,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.errorRed),
                    ),
                    child: Text(
                      paymentMethod,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.smallRedText,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

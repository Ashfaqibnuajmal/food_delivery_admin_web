import 'package:flutter/material.dart';
import 'package:user_app/core/theme/web_color.dart';

class OrderItemRow extends StatelessWidget {
  final int index;
  final String itemName;
  final String plateLabel;
  final num quantity;
  final double unitPrice;
  final bool isTodayOffer;
  final double totalPrice;

  const OrderItemRow({
    super.key,
    required this.index,
    required this.itemName,
    required this.plateLabel,
    required this.quantity,
    required this.unitPrice,
    required this.isTodayOffer,
    required this.totalPrice,
  });

  String _fmt(double val) => val % 1 == 0 ? '₹${val.toInt()}' : '₹$val';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: index.isEven
            ? AppColors.lightBlue.withOpacity(0.06)
            : AppColors.lightBlue.withOpacity(0.03),
        border: Border(
          bottom: BorderSide(color: AppColors.pureWhite.withOpacity(0.07)),
        ),
      ),
      child: Row(
        children: [
          // #
          Expanded(
            flex: 1,
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.pureWhite.withOpacity(0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Item name
          Expanded(
            flex: 5,
            child: Text(
              itemName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),

          // Plate badge
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: AppColors.lightBlue.withOpacity(0.35),
                  ),
                ),
                child: Text(
                  plateLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.lightBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),

          // Qty
          Expanded(
            flex: 2,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Unit Price
          Expanded(
            flex: 2,
            child: Text(
              _fmt(unitPrice),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.pureWhite.withOpacity(0.75),
                fontSize: 13,
              ),
            ),
          ),

          // Offer badge
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: isTodayOffer
                      ? const Color(0xFF66BB6A).withOpacity(0.12)
                      : AppColors.pureWhite.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isTodayOffer
                        ? const Color(0xFF66BB6A).withOpacity(0.35)
                        : AppColors.pureWhite.withOpacity(0.08),
                  ),
                ),
                child: Text(
                  isTodayOffer ? "Offer" : "Regular",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isTodayOffer
                        ? const Color(0xFF66BB6A)
                        : AppColors.pureWhite.withOpacity(0.35),
                  ),
                ),
              ),
            ),
          ),

          // Total
          Expanded(
            flex: 2,
            child: Text(
              _fmt(totalPrice),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF66BB6A),
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

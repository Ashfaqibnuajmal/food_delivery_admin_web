import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_app/core/theme/textstyle.dart';
import 'package:user_app/core/theme/web_color.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderid;
  const OrderDetailsScreen({super.key, required this.orderid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Details", style: CustomTextStyles.loginHeading),
            const SizedBox(height: 30),

            /// --- TOP INFO ROW ---
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .doc(orderid) // ✅ only fetch this one order
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("No Order yet!"));
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;

                // ✅ Date formatting
                final orderDate = data['createdAt'];
                String formattedDate = "Unknown";
                try {
                  if (orderDate is Timestamp) {
                    final dateTime = orderDate.toDate();
                    formattedDate = DateFormat(
                      'MMM dd, yyyy — hh:mm a',
                    ).format(dateTime);
                  } else if (orderDate is String) {
                    final dateTime = DateTime.parse(orderDate);
                    formattedDate = DateFormat(
                      'MMM dd, yyyy — hh:mm a',
                    ).format(dateTime);
                  }
                } catch (e) {
                  formattedDate = "Invalid date";
                }

                // ✅ Safe value handling
                final subtotal = (data['subTotal'] ?? 0).toString();
                final total = (data['totalAmount'] ?? 0).toString();
                final discount = (data['discount'] ?? 0).toString();
                final name = data['userName']?.toString() ?? "Unknown";
                final status = data['orderStatus']?.toString() ?? "Making";

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟦 Order Info
                    Container(
                      width: 260,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mediumBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Order Info",
                                style: CustomTextStyles.addCategory,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  color: AppColors.pureWhite,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "12345",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.pureWhite,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.pureWhite,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Status pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColors.pureWhite,
                                  ),
                                ),
                              ),

                              // Payment method pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "Cash on Delivery",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: AppColors.pureWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 🟩 Price Summary (Middle Card)
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.mediumBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(1, 3),
                          ),
                        ],
                      ),
                      // ignore: prefer_const_constructors
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "subtotal",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '₹$subtotal.00',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Discount",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹$discount.00',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.errorRed,
                                  decorationThickness: 3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Charge",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "₹30.00",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.pureWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            color: AppColors.lightBlue,
                            height: 20,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                              Text(
                                '₹$total.00',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 🟨 User Info
                    Container(
                      width: 260,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.mediumBlue,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "User Info",
                                style: CustomTextStyles.addCategory,
                              ),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.lightBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.pureWhite,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.pureWhite,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.call,
                                size: 18,
                                color: AppColors.darkBlue,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "98369288232",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 18,
                                color: AppColors.darkBlue,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "Vallikkappatta",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.pureWhite,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            /// --- TABLE HEADER ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: const BoxDecoration(
                color: AppColors.deepBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: const Row(
                children: [
                  _HeaderCell("#", flex: 2),
                  _HeaderCell("Items", flex: 5),
                  _HeaderCell("Plate", flex: 2),
                  _HeaderCell("Qty", flex: 2),
                  _HeaderCell("Unit Price", flex: 2),
                  _HeaderCell("IsOffer", flex: 2),
                  _HeaderCell("Total", flex: 2),
                ],
              ),
            ),

            /// --- TABLE DATA ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.08),
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.pureWhite.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.pureWhite),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 5,
                        child: Center(
                          child: Text(
                            "Chicken Biryani",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "Half",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "4",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "100.00",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "Offer",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.errorRed),
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "500.00",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.pureWhite),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// --- HEADER CELL WIDGET ---
class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _HeaderCell(this.label, {this.flex = 1});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: CustomTextStyles.tableHeader,
        ),
      ),
    );
  }
}

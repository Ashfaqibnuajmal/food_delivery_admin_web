// // ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:mera_web/core/provider/user_search_provider.dart';
// import 'package:mera_web/core/theme/textstyle.dart';
// import 'package:mera_web/core/theme/web_color.dart';
// import 'package:mera_web/core/widgets/voice_search.bar.dart';
// import 'package:mera_web/features/orders/presentation/screens/order_details_screen.dart';
// import 'package:mera_web/features/orders/provider/order_status_provider.dart';
// import 'package:provider/provider.dart';

// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});

//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final List<String> orderStatuses = [
//       "Making",
//       "Packing",
//       "Out for Delivery",
//       "Delivered",
//     ];

//     return Scaffold(
//       backgroundColor: AppColors.darkBlue,
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Order Management",
//               style: CustomTextStyles.loginHeading,
//             ),
//             const SizedBox(height: 40),

//             // Search Bar
//             Consumer<UserSearchProvider>(
//               builder: (context, searchProvider, _) {
//                 return const VoiceSearchBar();
//               },
//             ),

//             const SizedBox(height: 40),

//             // Table Header Row
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//               decoration: BoxDecoration(
//                 color: AppColors.lightBlue.withOpacity(0.08),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: const Row(
//                 children: [
//                   _HeaderCell("#", flex: 1),
//                   _HeaderCell("User", flex: 2),
//                   _HeaderCell("Location", flex: 2),
//                   _HeaderCell("Phone number", flex: 2),
//                   _HeaderCell("Items", flex: 3),
//                   _HeaderCell("Amount", flex: 2),
//                   _HeaderCell("Payment", flex: 2),
//                   _HeaderCell("Action", flex: 3),
//                   _HeaderCell("View", flex: 2),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 6),

//             // Table Data Rows
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('Orders')
//                       .orderBy('createdAt', descending: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return const Center(
//                         child: Text("No Orders yet!"),
//                       );
//                     }
//                     final orderItems = snapshot.data!.docs;
//                     return ListView.builder(
//                       itemCount: orderItems.length,
//                       itemBuilder: (context, index) {
//                         final doc = orderItems[index];
//                         final orderId = doc.id;
//                         final data = doc.data() as Map<String, dynamic>? ?? {};
//                         final userName = data['userName']?.toString() ?? doc.id;
//                         final phoneNumber =
//                             data['phoneNumber']?.toString() ?? doc.id;
//                         final totalAmount =
//                             data['totalAmount']?.toString() ?? doc.id;
//                         String intialStatus =
//                             data['orderStatus']?.toString() ?? "Making";
//                         return ChangeNotifierProvider(
//                           create: (context) => OrderStatusProvider(
//                               orderId: orderId, selectedStatus: intialStatus),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 14, horizontal: 10),
//                             margin: const EdgeInsets.only(bottom: 6),
//                             decoration: BoxDecoration(
//                               color: AppColors.lightBlue.withOpacity(0.08),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   flex: 1,
//                                   child: Text(
//                                     (index + 1).toString(),
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     userName,
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite),
//                                   ),
//                                 ),
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "Valikkapptta",
//                                     textAlign: TextAlign.center,
//                                     style:
//                                         TextStyle(color: AppColors.pureWhite),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     phoneNumber,
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite),
//                                   ),
//                                 ),
//                                 const Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     "Chicken Biryani",
//                                     textAlign: TextAlign.center,
//                                     style:
//                                         TextStyle(color: AppColors.pureWhite),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     '₹$totalAmount.00',
//                                     textAlign: TextAlign.center,
//                                     style: const TextStyle(
//                                         color: AppColors.pureWhite),
//                                   ),
//                                 ),
//                                 const Expanded(
//                                   flex: 2,
//                                   child: Text(
//                                     "Cash on delivery",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(color: Colors.redAccent),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 3,
//                                   child: Center(
//                                     child: Consumer<OrderStatusProvider>(
//                                       builder: (context, notified, _) {
//                                         return Container(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 4),
//                                           decoration: BoxDecoration(
//                                             color: AppColors.pureWhite
//                                                 .withOpacity(0.1),
//                                             borderRadius:
//                                                 BorderRadius.circular(12),
//                                             border: Border.all(
//                                               color: AppColors.pureWhite
//                                                   .withOpacity(0.3),
//                                               width: 1.2,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: AppColors.pureWhite
//                                                     .withOpacity(0.05),
//                                                 blurRadius: 4,
//                                                 offset: const Offset(0, 2),
//                                               ),
//                                             ],
//                                           ),
//                                           child: SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.22, // limit dropdown width

//                                             child: DropdownButtonHideUnderline(
//                                               child: DropdownButton<String>(
//                                                 isExpanded: true,
//                                                 dropdownColor:
//                                                     AppColors.darkBlue,
//                                                 value: notified.selectedStatus,
//                                                 icon: const Icon(
//                                                   Icons.arrow_drop_down_rounded,
//                                                   color: AppColors.pureWhite,
//                                                 ),
//                                                 style: const TextStyle(
//                                                   color: AppColors.pureWhite,
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                                 items: orderStatuses.map((s) {
//                                                   return DropdownMenuItem(
//                                                     value: s,
//                                                     child: Row(
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.circle,
//                                                           color: AppColors
//                                                               .pureWhite,
//                                                           size: 10,
//                                                         ),
//                                                         const SizedBox(
//                                                             width: 8),
//                                                         Flexible(
//                                                           child: Text(
//                                                             s,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   );
//                                                 }).toList(),
//                                                 onChanged: (selected) {
//                                                   if (selected != null) {
//                                                     notified.updateStatus(
//                                                         selected, context);
//                                                   }
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 2,
//                                   child: InkWell(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   OrderDetailsScreen(
//                                                     orderid: doc.id,
//                                                   )));
//                                     },
//                                     child: const Text("View",
//                                         textAlign: TextAlign.center,
//                                         style: CustomTextStyles.viewStyle),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _HeaderCell extends StatelessWidget {
//   final String label;
//   final int flex;
//   const _HeaderCell(this.label, {this.flex = 1});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: flex,
//       child: Center(
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: CustomTextStyles.tableHeader,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Order screen"),
      ),
    );
  }
}

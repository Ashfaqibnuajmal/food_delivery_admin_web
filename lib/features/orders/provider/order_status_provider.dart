// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderStatusProvider extends ChangeNotifier {
  final String orderId;
  String selectedStatus;
  bool isUpdating = false;
  OrderStatusProvider({
    required this.orderId,
    required this.selectedStatus,
  });
  Future<void> updateStatus(String newStatus, BuildContext context) async {
    if (isUpdating || newStatus == selectedStatus) return;
    final prevois = selectedStatus;
    selectedStatus = newStatus;
    isUpdating = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection("Orders")
          .doc(orderId)
          .update({'orderStatus': newStatus});
    } catch (e) {
      selectedStatus = prevois;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update failed:$e")));
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }
}

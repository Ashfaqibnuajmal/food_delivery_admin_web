import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/users/data/model/user_model.dart';

class UserServices extends ChangeNotifier {
  final userCollection = FirebaseFirestore.instance.collection("Users");

  Stream<List<UserModel>> fetchUsers() {
    return userCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id)) // pass id
          .toList(),
    );
  }

  Future<void> blockUser(String uid) async {
    try {
      await userCollection.doc(uid).update({"status": "blocked"});
      log("User $uid blocked");
    } catch (e) {
      log("Error blocking user: $e");
      throw Exception("Failed to block user");
    }
  }

  Future<void> unblockUser(String uid) async {
    try {
      await userCollection.doc(uid).update({"status": "active"});
      log("User $uid unblocked");
    } catch (e) {
      log("Error unblocking user: $e");
      throw Exception("Failed to unblock user");
    }
  }
}

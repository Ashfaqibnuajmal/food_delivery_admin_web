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

  Stream<int> totalUsersCount() =>
      userCollection.snapshots().map((s) => s.docs.length);

  Stream<int> activeUsersCount() => userCollection
      .where("status", isEqualTo: "active")
      .snapshots()
      .map((s) => s.docs.length);

  Stream<int> blockedUsersCount() => userCollection
      .where("status", isEqualTo: "blocked")
      .snapshots()
      .map((s) => s.docs.length);

  /// 🚫 block user
  Future<void> blockUser(String uid) async {
    try {
      await userCollection.doc(uid).update({"status": "blocked"});
      log("User $uid blocked");
    } catch (e) {
      log("Error blocking user: $e");
    }
  }

  /// ✅ unblock user
  Future<void> unblockUser(String uid) async {
    try {
      await userCollection.doc(uid).update({"status": "active"});
      log("User $uid unblocked");
    } catch (e) {
      log("Error unblocking user: $e");
    }
  }
}

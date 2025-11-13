import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/due%20payment/data/model/due_user_model.dart';
import 'package:user_app/features/due%20payment/data/model/payment_entry_model.dart';

class DuePaymentService {
  final _dueUserCollection = FirebaseFirestore.instance.collection('DueUsers');

  // ──────────────  USER CRUD  ──────────────

  /// 🔹 add new user
  Future<void> addDueUser(DueUserModel user) async {
    try {
      await _dueUserCollection.doc(user.userId).set(user.toMap());
      log('Added user: ${user.name}');
    } catch (e) {
      log('Error adding user: $e');
    }
  }

  /// 🔹 edit/update user details
  Future<void> editDueUser(DueUserModel user) async {
    try {
      await _dueUserCollection.doc(user.userId).update(user.toMap());
      log('Updated user: ${user.name}');
    } catch (e) {
      log('Error editing user: $e');
    }
  }

  /// 🔹 delete user and all their entries
  Future<void> deleteDueUser(String userId) async {
    try {
      final entries = await _dueUserCollection
          .doc(userId)
          .collection('PaymentEntries')
          .get();
      for (var doc in entries.docs) {
        await doc.reference.delete();
      }
      await _dueUserCollection.doc(userId).delete();
      log('Deleted user: $userId');
    } catch (e) {
      log('Error deleting user: $e');
    }
  }

  /// 🔹 get stream of all users (for main table)
  Stream<List<DueUserModel>> fetchDueUsers() {
    return _dueUserCollection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => DueUserModel.fromMap(doc.data())).toList(),
    );
  }

  // ──────────────  ENTRIES CRUD  ──────────────

  /// 🔹 add new entry inside specific user's PaymentEntries subcollection
  Future<void> addPaymentEntry(PaymentEntryModel entry) async {
    try {
      final userDoc = _dueUserCollection.doc(entry.userId);
      final entryDoc = userDoc.collection('PaymentEntries').doc(entry.entryId);

      await entryDoc.set(entry.toMap());

      // update user balance automatically
      await _recalculateUserBalance(entry.userId);
    } catch (e) {
      log('Error adding payment entry: $e');
    }
  }

  /// 🔹 edit entry
  Future<void> editPaymentEntry(PaymentEntryModel entry) async {
    try {
      await _dueUserCollection
          .doc(entry.userId)
          .collection('PaymentEntries')
          .doc(entry.entryId)
          .update(entry.toMap());

      await _recalculateUserBalance(entry.userId);
    } catch (e) {
      log('Error editing entry: $e');
    }
  }

  /// 🔹 delete entry
  Future<void> deletePaymentEntry(String userId, String entryId) async {
    try {
      await _dueUserCollection
          .doc(userId)
          .collection('PaymentEntries')
          .doc(entryId)
          .delete();

      await _recalculateUserBalance(userId);
    } catch (e) {
      log('Error deleting entry: $e');
    }
  }

  /// 🔹 fetch all entries for a specific user (for view page)
  Stream<List<PaymentEntryModel>> fetchUserEntries(String userId) {
    return _dueUserCollection
        .doc(userId)
        .collection('PaymentEntries')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((d) => PaymentEntryModel.fromMap(d.data()))
              .toList(),
        );
  }

  // ──────────────  INTERNAL UTIL ──────────────

  Future<void> _recalculateUserBalance(String userId) async {
    final entries = await _dueUserCollection
        .doc(userId)
        .collection('PaymentEntries')
        .get();

    double balance = 0;
    for (var doc in entries.docs) {
      final data = doc.data();
      final status = data['status'];
      final amount = (data['amount'] ?? 0).toDouble();

      if (status == 'Consumed') {
        balance += amount; // increase due when consumed
      } else if (status == 'Paid') {
        balance -= amount; // reduce due when paid
      }
    }

    await _dueUserCollection.doc(userId).update({'balance': balance});
    log('User $userId balance recalculated: \$balance');
  }
}

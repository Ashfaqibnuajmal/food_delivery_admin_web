import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/due_payment/data/enum/due_user_sort_type.dart';
import 'package:user_app/features/due_payment/data/model/due_user_model.dart';
import 'package:user_app/features/due_payment/data/model/payment_entry_model.dart';

class DuePaymentService {
  final CollectionReference<Map<String, dynamic>> _dueUserCollection =
      FirebaseFirestore.instance.collection('DueUsers');

  // ────────────── USER CRUD ──────────────

  Future<void> addDueUser(DueUserModel user) async {
    try {
      await _dueUserCollection.doc(user.userId).set(user.toMap());
      log('Added user: ${user.name}');
    } catch (e) {
      log('Error adding user: $e');
      rethrow;
    }
  }

  Future<void> editDueUser(DueUserModel user) async {
    try {
      await _dueUserCollection.doc(user.userId).update(user.toMap());
      log('Updated user: ${user.name}');
    } catch (e) {
      log('Error editing user: $e');
      rethrow;
    }
  }

  Future<void> deleteDueUser(String userId) async {
    try {
      final entries = await _dueUserCollection
          .doc(userId)
          .collection('PaymentEntries')
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in entries.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(_dueUserCollection.doc(userId));

      await batch.commit();

      log('Deleted user: $userId');
    } catch (e) {
      log('Error deleting user: $e');
      rethrow;
    }
  }

  Stream<List<DueUserModel>> fetchDueUsers({
    DueUserSortType sortType = DueUserSortType.latest,
  }) {
    return _dueUserCollection.snapshots().map((snapshot) {
      final users = snapshot.docs.map((doc) {
        return DueUserModel.fromMap(doc.data());
      }).toList();

      switch (sortType) {
        case DueUserSortType.name:
          users.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          );
          break;

        case DueUserSortType.highestBalance:
          users.sort((a, b) => b.balance.compareTo(a.balance));
          break;

        case DueUserSortType.latest:
          users.sort((a, b) {
            final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bDate.compareTo(aDate);
          });
          break;
      }

      return users;
    });
  }

  Stream<DueUserModel?> fetchDueUserById(String userId) {
    return _dueUserCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return DueUserModel.fromMap(doc.data()!);
    });
  }

  // ────────────── ENTRIES CRUD ──────────────

  Future<void> addPaymentEntry(PaymentEntryModel entry) async {
    try {
      final userDoc = _dueUserCollection.doc(entry.userId);
      final entryDoc = userDoc.collection('PaymentEntries').doc(entry.entryId);

      await entryDoc.set(entry.toMap());
      await _recalculateUserBalance(entry.userId);
    } catch (e) {
      log('Error adding payment entry: $e');
      rethrow;
    }
  }

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
      rethrow;
    }
  }

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
      rethrow;
    }
  }

  Stream<List<PaymentEntryModel>> fetchUserEntries(String userId) {
    return _dueUserCollection
        .doc(userId)
        .collection('PaymentEntries')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PaymentEntryModel.fromMap(doc.data());
          }).toList();
        });
  }

  // ────────────── INTERNAL UTIL ──────────────

  // ────────────── INTERNAL UTIL ──────────────

  Future<void> _recalculateUserBalance(String userId) async {
    try {
      final userRef = _dueUserCollection.doc(userId);
      final entriesRef = userRef.collection('PaymentEntries');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final entriesSnapshot = await entriesRef.get();

        double balance = 0;

        for (final doc in entriesSnapshot.docs) {
          final data = doc.data();
          final status = data['status']?.toString();
          final amount = _parseDouble(data['amount']);

          if (status == 'Consumed') {
            balance += amount;
          } else if (status == 'Paid') {
            balance -= amount;
          }
        }

        transaction.update(userRef, {'balance': balance});
      });

      log('User $userId balance recalculated safely');
    } catch (e) {
      log('Error recalculating balance: $e');
      rethrow;
    }
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  Future<bool> dueUserExists({
    required String phone,
    required String email,
    String? excludeUserId,
  }) async {
    final normalizedPhone = phone.trim();
    final normalizedEmail = email.trim().toLowerCase();

    final phoneQuery = await _dueUserCollection
        .where('phone', isEqualTo: normalizedPhone)
        .limit(1)
        .get();

    final emailQuery = await _dueUserCollection
        .where('email', isEqualTo: normalizedEmail)
        .limit(1)
        .get();

    final phoneExists = phoneQuery.docs.any((doc) {
      return excludeUserId == null || doc.id != excludeUserId;
    });

    final emailExists = emailQuery.docs.any((doc) {
      return excludeUserId == null || doc.id != excludeUserId;
    });

    return phoneExists || emailExists;
  }
}

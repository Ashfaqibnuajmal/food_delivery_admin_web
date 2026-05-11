import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/notification/core/exception/notification_exception.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';
import 'package:user_app/features/notification/core/utils/firebase_error_handerl.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // SEND NOTIFICATION
  Future<void> sendNotification(NotificationModel notification) async {
    try {
      await _db.collection('notifications').add(notification.toMap());
    } catch (e) {
      throw NotificationException(FirebaseErrorHandler.getMessage(e));
    }
  }

  // GET NOTIFICATIONS
  Stream<QuerySnapshot> getNotifications() {
    return _db
        .collection('notifications')
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // DELETE NOTIFICATION
  Future<void> deleteNotification(String docId) async {
    try {
      await _db.collection('notifications').doc(docId).update({
        'isDeleted': true,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw NotificationException(FirebaseErrorHandler.getMessage(e));
    }
  }
}

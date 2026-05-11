import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';
import 'package:user_app/features/notification/data/service/notification_service.dart';

class NotificationRepository {
  final NotificationService _service = NotificationService();

  // SEND
  Future<void> sendNotification(NotificationModel notification) async {
    await _service.sendNotification(notification);
  }

  // GET
  Stream<QuerySnapshot> getNotifications() {
    return _service.getNotifications();
  }

  // DELETE
  Future<void> deleteNotification(String docId) async {
    await _service.deleteNotification(docId);
  }
}

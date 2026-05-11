import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/notification/core/exception/notification_exception.dart';
import 'package:user_app/features/notification/data/model/notification_model.dart';
import 'package:user_app/features/notification/data/repository/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSent = false;
  bool get isSent => _isSent;

  // SEND NOTIFICATION
  Future<void> sendNotification({
    required String title,
    required String message,
  }) async {
    try {
      _isLoading = true;
      _isSent = false;
      _errorMessage = null;

      notifyListeners();
      NotificationModel notification = NotificationModel(
        id: '',
        title: title,
        message: message,
        imageUrl: '',
        type: 'broadcast',
        status: 'sent',
        targetUsers: [],
        readCount: 0,
        totalUsers: 0,
        isActive: true,
        isDeleted: false,
        createdBy: 'admin',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _repository.sendNotification(notification);

      _isSent = true;

      log('✅ Notification sent successfully!');
    } on NotificationException catch (e) {
      _errorMessage = e.message;
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  // GET NOTIFICATIONS
  Stream<QuerySnapshot> getNotifications() {
    return _repository.getNotifications();
  }

  // DELETE NOTIFICATION
  Future<void> deleteNotification(String docId) async {
    try {
      await _repository.deleteNotification(docId);
    } on NotificationException catch (e) {
      _errorMessage = e.message;

      notifyListeners();
    }
  }

  // RESET STATE
  void resetState() {
    _isSent = false;
    _errorMessage = null;

    notifyListeners();
  }
}

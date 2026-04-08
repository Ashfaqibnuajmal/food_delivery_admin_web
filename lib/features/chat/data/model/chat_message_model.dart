import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime? timestamp; // nullable because server timestamp may be pending
  final bool isRead;

  ChatMessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.timestamp,
    required this.isRead,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate(),
      isRead: map['isRead'] ?? false,
    );
  }
}

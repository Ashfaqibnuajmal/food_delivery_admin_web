import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String docId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime? timestamp;
  final bool isRead;

  ChatMessageModel({
    required this.docId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.timestamp,
    required this.isRead,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatMessageModel(
      docId: docId,
      senderId: map['senderId']?.toString() ?? '',
      receiverId: map['receiverId']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      timestamp: _parseTimestamp(map['timestamp']),
      isRead: map['isRead'] == true,
    );
  }

  factory ChatMessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return ChatMessageModel.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp == null
          ? FieldValue.serverTimestamp()
          : Timestamp.fromDate(timestamp!),
      'isRead': isRead,
    };
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }
}

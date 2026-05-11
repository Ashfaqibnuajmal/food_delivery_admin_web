import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUserModel {
  final String userId;
  final String userName;
  final String imageUrl;
  final String lastMessage;
  final Timestamp? lastMessageTime;
  final int unreadByAdmin;

  ChatUserModel({
    required this.userId,
    required this.userName,
    required this.imageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadByAdmin,
  });

  factory ChatUserModel.fromMap(Map<String, dynamic> map, String docId) {
    final userName = map['userName']?.toString().trim().isNotEmpty == true
        ? map['userName'].toString()
        : map['displayName']?.toString().trim().isNotEmpty == true
        ? map['displayName'].toString()
        : map['name']?.toString().trim().isNotEmpty == true
        ? map['name'].toString()
        : map['fullName']?.toString().trim().isNotEmpty == true
        ? map['fullName'].toString()
        : map['email']?.toString().trim().isNotEmpty == true
        ? map['email'].toString()
        : 'User';

    return ChatUserModel(
      userId: map['userId']?.toString() ?? docId,
      userName: userName,
      imageUrl:
          map['imageUrl']?.toString() ??
          map['photoUrl']?.toString() ??
          map['photoURL']?.toString() ??
          '',
      lastMessage: map['lastMessage']?.toString() ?? '',
      lastMessageTime: map['lastMessageTime'] as Timestamp?,
      unreadByAdmin: (map['unreadByAdmin'] as num?)?.toInt() ?? 0,
    );
  }
}

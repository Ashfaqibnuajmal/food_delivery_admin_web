import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/chat/data/model/chat_message_model.dart';

class ChatServices extends ChangeNotifier {
  final CollectionReference chatCollection = FirebaseFirestore.instance
      .collection("Chats");
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final docRef = chatCollection.doc(chatId).collection('messages').doc();
      final chatMessage = ChatMessageModel(
        messageId: docRef.id,
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
        isRead: false,
      );
      await docRef.set(chatMessage.toMap());
      await chatCollection.doc(chatId).set({
        'chatId': chatId,
        'lastMessage': message,
        'lastUpdated': Timestamp.now(),
        'userId': chatId,
      }, SetOptions(merge: true));
      log("Message sent :${chatMessage.toMap()}");
    } catch (e) {
      log("Error sending message:$e");
      rethrow;
    }
  }

  Stream<List<ChatMessageModel>> fetchMessages(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            // ignore: unnecessary_cast
            return ChatMessageModel.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
  }

  Stream<List<Map<String, dynamic>>> fetchAllChatsForAdmin() {
    return chatCollection
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return doc.data() as Map<String, dynamic>;
          }).toList();
        });
  }

  Future<void> markAsRead({
    required String chatId,
    required String messageId,
  }) async {
    try {
      await chatCollection
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .update({"isRead": true});
      log('Message mark as read');
    } catch (e) {
      log("Error marking message as read:$e");
    }
  }
}

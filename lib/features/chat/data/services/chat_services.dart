import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/chat/data/model/chat_message_model.dart';

class ChatServices extends ChangeNotifier {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("Chats");

  /// Send a message from admin to a specific user
  Future<void> sendMessage({
    required String chatId,    // = userId (each user has their own chat doc)
    required String senderId,  // = adminId
    required String receiverId, // = userId
    required String message,
  }) async {
    try {
      final chatDoc = chatCollection.doc(chatId);
      final messageDoc = chatDoc.collection('messages').doc();

      // Add message to the subcollection (match user-side field names)
      await messageDoc.set({
        'message': message,
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(), // USE SERVER TIMESTAMP
        'isRead': false,
      });

      // Update the parent chat document (match user-side field names)
      await chatDoc.set({
        'userId': chatId,
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(), // MATCH USER SIDE
      }, SetOptions(merge: true));

      log("Admin message sent to chat: $chatId");
    } catch (e) {
      log("Error sending message: $e");
      rethrow;
    }
  }

  /// Fetch messages for a specific user's chat (real-time stream)
  Stream<List<ChatMessageModel>> fetchMessages(String chatId) {
    return chatCollection
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessageModel.fromMap(doc.data());
      }).toList();
    });
  }

  /// Fetch ONLY users who have active chats (from "Chats" collection)
  /// This returns the parent chat documents which contain userName, lastMessage, etc.
  Stream<List<Map<String, dynamic>>> fetchAllChatsForAdmin() {
    return chatCollection
        .orderBy('lastMessageTime', descending: true) // MATCH USER SIDE FIELD
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Include doc ID as the userId in case 'userId' field is missing
        data['userId'] = doc.id;
        return data;
      }).toList();
    });
  }

  /// Mark all unread messages as read when admin opens a chat
  Future<void> markChatAsReadByAdmin(String chatId) async {
    try {
      // Reset the unreadByAdmin counter on the parent doc
      await chatCollection.doc(chatId).update({
        'unreadByAdmin': 0,
      });

      // Mark all individual messages as read
      final unreadMessages = await chatCollection
          .doc(chatId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();

      log('Chat $chatId marked as read by admin');
    } catch (e) {
      log("Error marking chat as read: $e");
    }
  }
}

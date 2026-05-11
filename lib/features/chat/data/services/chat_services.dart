import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/chat/data/model/chat_message_model.dart';
import 'package:user_app/features/chat/data/model/chat_user_model.dart';

class ChatServices extends ChangeNotifier {
  final CollectionReference chatCollection = FirebaseFirestore.instance
      .collection("Chats");

  /// Send a message from admin to a specific user
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
    String? userName,
    String? imageUrl,
    String? email,
    required bool isAdminSender,
  }) async {
    try {
      final chatDoc = chatCollection.doc(chatId);
      final messageDoc = chatDoc.collection('messages').doc();

      await messageDoc.set({
        'message': message,
        'senderId': senderId,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      await chatDoc.set({
        'userId': chatId,
        'userName': userName ?? 'User',
        'imageUrl': imageUrl ?? '',
        'email': email ?? '',
        'lastMessage': message,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastSenderId': senderId,

        // Only user messages should increase admin unread count.
        if (!isAdminSender) 'unreadByAdmin': FieldValue.increment(1),
      }, SetOptions(merge: true));

      log("Message sent to chat: $chatId");
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
          return snapshot.docs.map(ChatMessageModel.fromFirestore).toList();
        });
  }

  /// Fetch ONLY users who have active chats (from "Chats" collection)
  /// This returns the parent chat documents which contain userName, lastMessage, etc.
  Stream<List<ChatUserModel>> fetchAllChatsForAdmin() {
    return chatCollection
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ChatUserModel.fromMap(data, doc.id);
          }).toList();
        });
  }

  /// Mark all unread messages as read when admin opens a chat
  Future<void> markChatAsReadByAdmin({
    required String chatId,
    required String adminId,
  }) async {
    try {
      await chatCollection.doc(chatId).update({'unreadByAdmin': 0});

      final unreadMessages = await chatCollection
          .doc(chatId)
          .collection('messages')
          .where('receiverId', isEqualTo: adminId)
          .where('isRead', isEqualTo: false)
          .get();

      if (unreadMessages.docs.isEmpty) {
        log('No unread messages for admin in chat: $chatId');
        return;
      }

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

  /// Delete a specific message from a chat
  Future<void> deleteMessage({
    required String chatId,
    required String messageDocId,
  }) async {
    try {
      final chatDoc = chatCollection.doc(chatId);
      final messageRef = chatDoc.collection('messages').doc(messageDocId);

      await messageRef.delete();

      final latestMessageSnapshot = await chatDoc
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (latestMessageSnapshot.docs.isEmpty) {
        await chatDoc.set({
          'lastMessage': '',
          'lastMessageTime': null,
          'lastSenderId': '',
        }, SetOptions(merge: true));
      } else {
        final latestMessage = latestMessageSnapshot.docs.first.data();

        await chatDoc.set({
          'lastMessage': latestMessage['message']?.toString() ?? '',
          'lastMessageTime': latestMessage['timestamp'],
          'lastSenderId': latestMessage['senderId']?.toString() ?? '',
        }, SetOptions(merge: true));
      }

      log('Message $messageDocId deleted from chat $chatId');
    } catch (e) {
      log('Error deleting message: $e');
      rethrow;
    }
  }
}

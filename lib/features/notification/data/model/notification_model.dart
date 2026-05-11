import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String imageUrl;
  final String type;
  final String status;
  final List<String> targetUsers;
  final int readCount;
  final int totalUsers;
  final bool isActive;
  final bool isDeleted;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.type,
    required this.status,
    required this.targetUsers,
    required this.readCount,
    required this.totalUsers,
    required this.isActive,
    required this.isDeleted,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // TO MAP
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'imageUrl': imageUrl,
      'type': type,
      'status': status,
      'targetUsers': targetUsers,
      'readCount': readCount,
      'totalUsers': totalUsers,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // FROM MAP
  factory NotificationModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return NotificationModel(
      id: documentId,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      type: map['type'] ?? 'broadcast',
      status: map['status'] ?? 'sent',
      targetUsers: List<String>.from(map['targetUsers'] ?? []),
      readCount: map['readCount'] ?? 0,
      totalUsers: map['totalUsers'] ?? 0,
      isActive: map['isActive'] ?? true,
      isDeleted: map['isDeleted'] ?? false,
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  // COPY WITH
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? imageUrl,
    String? type,
    String? status,
    List<String>? targetUsers,
    int? readCount,
    int? totalUsers,
    bool? isActive,
    bool? isDeleted,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      status: status ?? this.status,
      targetUsers: targetUsers ?? this.targetUsers,
      readCount: readCount ?? this.readCount,
      totalUsers: totalUsers ?? this.totalUsers,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

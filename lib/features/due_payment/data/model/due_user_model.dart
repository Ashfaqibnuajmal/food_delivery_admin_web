class DueUserModel {
  final String userId;
  final String name;
  final String phone;
  final String email;
  final double balance;
  final DateTime? createdAt;

  const DueUserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.balance,
    this.createdAt,
  });

  DueUserModel copyWith({
    String? userId,
    String? name,
    String? phone,
    String? email,
    double? balance,
    DateTime? createdAt,
  }) {
    return DueUserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'balance': balance,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory DueUserModel.fromMap(Map<String, dynamic> map) {
    return DueUserModel(
      userId: map['userId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      balance: _parseDouble(map['balance']),
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}

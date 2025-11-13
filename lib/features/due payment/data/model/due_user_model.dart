class DueUserModel {
  final String userId;
  final String name;
  final String phone;
  final String email;
  double balance; // current total due

  DueUserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'balance': balance,
    };
  }

  factory DueUserModel.fromMap(Map<String, dynamic> map) {
    return DueUserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      balance: (map['balance'] ?? 0).toDouble(),
    );
  }
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  late final String status;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, [String? docId]) {
    return UserModel(
      uid: docId ?? map['uid'] ?? '',
      name: map['name'] ?? 'Unknown',
      email: map['email'] ?? '123@gmail.com',
      phone: map['phone'] ?? '9876543210',
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
    };
  }
}

class UserModel {
  final int id;
  final String phone;
  final String email;
  final String fullName;
  final String createdAt;
  final bool isVerified;
  final String role;

  UserModel({
    required this.id,
    required this.phone,
    required this.email,
    required this.fullName,
    required this.createdAt,
    required this.isVerified,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      fullName: json['full_name'],
      createdAt: json['created_at'],
      isVerified: json['is_verified'],
      role: json['role'] ?? "user",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "phone": phone,
      "email": email,
      "full_name": fullName,
      "created_at": createdAt,
      "is_verified": isVerified,
      "role": role,
    };
  }
}

UserModel? currentUser;

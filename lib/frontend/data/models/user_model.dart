class UserModel {
  final int id;
  final String phone;
  final String email;
  final String fullName;
  final String password;
  final String role; // يحدده الأدمن فقط

  UserModel({
    required this.id,
    required this.phone,
    required this.email,
    required this.fullName,
    required this.password,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      fullName: json['full_name'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "phone": phone,
      "email": email,
      "full_name": fullName,
      "password": password,
      "role": role,
    };
  }
}

UserModel? currentUser;

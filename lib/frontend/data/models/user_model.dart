class UserModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String? imagePath; // مسار الصورة المخزنة محلياً

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    this.imagePath,
  });

  // تحويل JSON إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      imagePath: json['imagePath'],
    );
  }

  // تحويل UserModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'imagePath': imagePath,
    };
  }
}

// المستخدم الحالي
UserModel? currentUser;

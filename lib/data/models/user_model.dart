class UserModel {
  final int id;
  final String name;
  final String phone;
  final String password; // لاحقاً سيتم استبداله بـ token بعد الربط مع Backend

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
  });

  // تحويل JSON إلى UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  // تحويل UserModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'password': password,
    };
  }
}
UserModel? currentUser;
class OrderModel {
  final int id;
  final int userId;
  final int serviceId;
  final String status; // قيد المراجعة، مقبول، مرفوض، مكتمل
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  // تحويل JSON إلى OrderModel
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id'],
      serviceId: json['service_id'],
      status: json['status'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // تحويل OrderModel إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }


}
final List<OrderModel> mockOrders = [
  OrderModel(
    id: 1,
    userId: 1,
    serviceId: 3,
    status: 'قيد المراجعة',
    notes: 'أريد معالجة الطلب بسرعة',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  OrderModel(
    id: 2,
    userId: 1,
    serviceId: 1,
    status: 'مكتمل',
    notes: null,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];
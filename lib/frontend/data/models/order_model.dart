import 'service_model.dart';

class OrderModel {
  final int id;
  final int userId;
  final int serviceId;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;


  final ServiceModel? service;

  OrderModel({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.service,
  });

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


      service: json['service'] != null
          ? ServiceModel.fromJson(json['service'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'status': status,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'service': service,
    };
  }
}

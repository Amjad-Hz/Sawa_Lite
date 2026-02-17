class ServiceModel {
  final int id;
  final String nameAr;
  final String? description;
  final String? category;
  final int? durationDays;
  final double cost;
  final bool isActive;

  ServiceModel({
    required this.id,
    required this.nameAr,
    this.description,
    this.category,
    this.durationDays,
    required this.cost,
    required this.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      nameAr: json['name_ar'],
      description: json['description'],
      category: json['category'],
      durationDays: json['duration_days'],
      cost: (json['cost'] as num).toDouble(),
      isActive: json['is_active'] ?? true,
    );
  }
  Map<String, dynamic> toJson() { return { 'id': id, 'name_ar': nameAr, 'description': description, 'category': category, 'duration_days': durationDays, 'cost': cost, 'is_active': isActive, }; }
}

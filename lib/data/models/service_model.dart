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
    this.cost = 0.0,
    this.isActive = true,
  });
}
final List<ServiceModel> mockServices = [
  ServiceModel(
    id: 1,
    nameAr: 'استعلام عن وثيقة',
    description: 'الاستعلام عن حالة بطاقة الهوية أو جواز السفر',
    category: 'وثائق',
    durationDays: 3,
    cost: 500,
  ),
  ServiceModel(
    id: 2,
    nameAr: 'دفع غرامة مرورية',
    description: 'دفع المخالفات المرورية عبر المنصة',
    category: 'مرور',
    durationDays: 1,
    cost: 0,
  ),
  ServiceModel(
    id: 3,
    nameAr: 'طلب شهادة ميلاد',
    description: 'إصدار شهادة ميلاد إلكترونية',
    category: 'وثائق',
    durationDays: 5,
    cost: 1000,
  ),
  ServiceModel(
    id: 4,
    nameAr: 'تجديد رخصة قيادة',
    description: 'تجديد رخصة القيادة المنتهية',
    category: 'مرور',
    durationDays: 7,
    cost: 15000,
  ),
  ServiceModel(
    id: 5,
    nameAr: 'دفع فاتورة كهرباء',
    description: 'دفع فواتير الكهرباء الشهرية',
    category: 'مرافق',
    durationDays: 1,
    cost: 0,
  ),
  ServiceModel(
    id: 6,
    nameAr: 'حجز موعد طبي',
    description: 'حجز موعد في مستشفى حكومي',
    category: 'صحة',
    durationDays: 2,
    cost: 0,
  ),
  ServiceModel(
    id: 7,
    nameAr: 'تسجيل مولود جديد',
    description: 'تسجيل مواليد جدد في السجلات',
    category: 'وثائق',
    durationDays: 10,
    cost: 2000,
  ),
  ServiceModel(
    id: 8,
    nameAr: 'طلب قيد نفوس',
    description: 'إصدار وثيقة قيد نفوس',
    category: 'وثائق',
    durationDays: 5,
    cost: 800,
  ),
  ServiceModel(
    id: 9,
    nameAr: 'شكوى بلدية',
    description: 'تقديم شكوى أو اقتراح للبلدية',
    category: 'بلدية',
    durationDays: 15,
    cost: 0,
  ),
  ServiceModel(
    id: 10,
    nameAr: 'الاستعلام عن منحة',
    description: 'الاستعلام عن المنح الدراسية المتاحة',
    category: 'تعليم',
    durationDays: 3,
    cost: 0,
  ),
];

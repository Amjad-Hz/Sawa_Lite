# init_db.py
from database import engine, SessionLocal
from models import Base, Service
from sqlalchemy.orm import Session

def init_db():
    # 1. إنشاء جميع الجداول في قاعدة البيانات
    Base.metadata.create_all(bind=engine)
    print("✓ تم إنشاء الجداول بنجاح")

    # 2. إدخال الخدمات الأساسية (10 خدمات) إذا لم تكن موجودة
    db = SessionLocal()
    try:
        # التحقق من وجود خدمات مسبقاً
        if db.query(Service).count() == 0:
            services_data = [
                {"name_ar": "استعلام عن وثيقة", "description": "الاستعلام عن حالة بطاقة الهوية أو جواز السفر", "category": "وثائق", "duration_days": 3, "cost": 500},
                {"name_ar": "دفع غرامة مرورية", "description": "دفع المخالفات المرورية عبر المنصة", "category": "مرور", "duration_days": 1, "cost": 0},
                {"name_ar": "طلب شهادة ميلاد", "description": "إصدار شهادة ميلاد إلكترونية", "category": "وثائق", "duration_days": 5, "cost": 1000},
                {"name_ar": "تجديد رخصة قيادة", "description": "تجديد رخصة القيادة المنتهية", "category": "مرور", "duration_days": 7, "cost": 15000},
                {"name_ar": "دفع فاتورة كهرباء", "description": "دفع فواتير الكهرباء الشهرية", "category": "مرافق", "duration_days": 1, "cost": 0},
                {"name_ar": "حجز موعد طبي", "description": "حجز موعد في مستشفى حكومي", "category": "صحة", "duration_days": 2, "cost": 0},
                {"name_ar": "تسجيل مولود جديد", "description": "تسجيل مواليد جدد في السجلات", "category": "وثائق", "duration_days": 10, "cost": 2000},
                {"name_ar": "طلب قيد نفوس", "description": "إصدار وثيقة قيد نفوس", "category": "وثائق", "duration_days": 5, "cost": 800},
                {"name_ar": "شكوى بلدية", "description": "تقديم شكوى أو اقتراح للبلدية", "category": "بلدية", "duration_days": 15, "cost": 0},
                {"name_ar": "الاستعلام عن منحة", "description": "الاستعلام عن المنح الدراسية المتاحة", "category": "تعليم", "duration_days": 3, "cost": 0},
            ]
            for s in services_data:
                service = Service(**s)
                db.add(service)
            db.commit()
            print(f"✓ تم إدخال {len(services_data)} خدمة أساسية")
        else:
            print("→ الخدمات موجودة مسبقاً، لم يتم إعادة الإدخال")
    except Exception as e:
        print(f"✗ خطأ أثناء إدخال البيانات: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    print("بدء تهيئة قاعدة البيانات...")
    init_db()
    print("انتهت عملية التهيئة.")
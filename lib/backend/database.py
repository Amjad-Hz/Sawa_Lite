# database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from config import settings

engine = create_engine(
    settings.DATABASE_URL, connect_args={"check_same_thread": False}  # ضروري لـ SQLite
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# دالة للحصول على جلسة قاعدة البيانات (تُستخدم في الاعتماديات)
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
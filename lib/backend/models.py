# models.py
from sqlalchemy import Column, Integer, String, Float, Boolean, Text, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    phone = Column(String(20), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=True)
    password_hash = Column(String(255), nullable=False)
    full_name = Column(String(100))
    created_at = Column(DateTime, default=datetime.utcnow)
    is_verified = Column(Boolean, default=False)
    role = Column(String(20), default='user')  # قيم: 'user', 'admin'

    # العلاقات
    orders = relationship("Order", back_populates="user", cascade="all, delete-orphan")
    transactions = relationship("WalletTransaction", back_populates="user", cascade="all, delete-orphan")
    experiences = relationship("Experience", back_populates="user", cascade="all, delete-orphan")


class Service(Base):
    __tablename__ = "services"

    id = Column(Integer, primary_key=True, index=True)
    name_ar = Column(String(200), nullable=False)
    description = Column(Text)
    category = Column(String(50))
    duration_days = Column(Integer)
    cost = Column(Float, default=0.0)
    is_active = Column(Boolean, default=True)

    # العلاقات
    orders = relationship("Order", back_populates="service", cascade="all, delete-orphan")
    experiences = relationship("Experience", back_populates="service", cascade="all, delete-orphan")


class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    service_id = Column(Integer, ForeignKey("services.id"), nullable=False)
    status = Column(String(50), default="قيد المراجعة")  # قيد المراجعة، مقبول، مرفوض، مكتمل
    notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_paid = Column(Boolean, default=False)

    # العلاقات
    user = relationship("User", back_populates="orders")
    service = relationship("Service", back_populates="orders")
    transactions = relationship("WalletTransaction", back_populates="order", cascade="all, delete-orphan")


class WalletTransaction(Base):
    __tablename__ = "wallet_transactions"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    type = Column(String(20))  # شحن، دفع، استرداد
    amount = Column(Float, nullable=False)
    description = Column(String(200))
    order_id = Column(Integer, ForeignKey("orders.id"), nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # العلاقات
    user = relationship("User", back_populates="transactions")
    order = relationship("Order", back_populates="transactions")


class Experience(Base):
    __tablename__ = "experiences"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    service_id = Column(Integer, ForeignKey("services.id"), nullable=False)
    content = Column(Text)
    rating = Column(Integer)  # تقييم من 1 إلى 5
    created_at = Column(DateTime, default=datetime.utcnow)

    # العلاقات
    user = relationship("User", back_populates="experiences")
    service = relationship("Service", back_populates="experiences")
# schemas.py
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime

# === المستخدم ===
class UserBase(BaseModel):
    phone: str
    email: Optional[str] = None
    full_name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    email: Optional[str] = None

class User(UserBase):
    id: int
    created_at: datetime
    is_verified: bool
    role: str

    class Config:
        from_attributes = True

class UserRoleUpdate(BaseModel):
    role: str  # 'user' أو 'admin'
    
# === التوكن ===
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    user_id: Optional[int] = None

# === الخدمات ===
class ServiceBase(BaseModel):
    name_ar: str
    description: Optional[str] = None
    category: Optional[str] = None
    duration_days: Optional[int] = None
    cost: float = 0.0
    is_active: bool = True

class ServiceCreate(ServiceBase):
    pass

class Service(ServiceBase):
    id: int

    class Config:
        from_attributes = True

# === الطلبات ===
class OrderBase(BaseModel):
    service_id: int
    notes: Optional[str] = None

class OrderCreate(OrderBase):
    pass

class Order(OrderBase):
    id: int
    user_id: int
    status: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    service: Optional[Service] = None  # لتضمين بيانات الخدمة

    class Config:
        from_attributes = True

class OrderUpdateStatus(BaseModel):
    status: str

# === المحفظة ===
class WalletTransactionBase(BaseModel):
    type: str
    amount: float
    description: Optional[str] = None
    order_id: Optional[int] = None

class WalletTransactionCreate(WalletTransactionBase):
    pass

class WalletTransaction(WalletTransactionBase):
    id: int
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True

class WalletBalance(BaseModel):
    balance: float

class WalletCharge(BaseModel):
    amount: float = Field(..., gt=0)

# === المجتمع (التجارب) ===
class ExperienceBase(BaseModel):
    service_id: int
    content: str
    rating: int = Field(..., ge=1, le=5)

class ExperienceCreate(ExperienceBase):
    pass

class Experience(ExperienceBase):
    id: int
    user_id: int
    created_at: datetime
    user: Optional[UserBase] = None
    service: Optional[Service] = None

    class Config:
        from_attributes = True
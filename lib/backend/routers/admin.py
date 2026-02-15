# routers/admin.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime
import schemas
import models
import auth
from database import get_db

router = APIRouter(prefix="/admin", tags=["Admin"])

@router.get("/orders", response_model=List[schemas.Order])
def get_all_orders(
    db: Session = Depends(get_db),
    admin: models.User = Depends(auth.get_current_admin)
):
    """عرض جميع الطلبات (للمشرف فقط)"""
    orders = db.query(models.Order).all()
    for o in orders:
        db.refresh(o, attribute_names=['service'])
    return orders

@router.patch("/orders/{order_id}/status", response_model=schemas.Order)
def update_order_status(
    order_id: int,
    status_update: schemas.OrderUpdateStatus,
    db: Session = Depends(get_db),
    admin: models.User = Depends(auth.get_current_admin)
):
    """تحديث حالة أي طلب (للمشرف فقط)"""
    order = db.query(models.Order).filter(models.Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    
    valid_statuses = ["قيد المراجعة", "مقبول", "مرفوض", "مكتمل"]
    if status_update.status not in valid_statuses:
        raise HTTPException(status_code=400, detail=f"Invalid status. Must be one of {valid_statuses}")
    
    order.status = status_update.status
    order.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(order)
    db.refresh(order, attribute_names=['service'])
    return order

@router.get("/users", response_model=List[schemas.User])
def get_all_users(
    db: Session = Depends(get_db),
    admin: models.User = Depends(auth.get_current_admin)
):
    """عرض جميع المستخدمين (للمشرف فقط)"""
    users = db.query(models.User).all()
    return users

@router.patch("/users/{user_id}/role", response_model=schemas.User)
def update_user_role(
    user_id: int,
    role_update: schemas.UserRoleUpdate,
    db: Session = Depends(get_db),
    admin: models.User = Depends(auth.get_current_admin)
):
    """تعديل دور مستخدم (للمشرف فقط)"""
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    if role_update.role not in ["user", "admin"]:
        raise HTTPException(status_code=400, detail="Role must be 'user' or 'admin'")
    user.role = role_update.role
    db.commit()
    db.refresh(user)
    return user
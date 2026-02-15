# routers/orders.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
import schemas
import models
import auth
from database import get_db
from datetime import datetime
import logging

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/orders", tags=["Orders"])

@router.post("/", response_model=schemas.Order)
def create_order(
    order: schemas.OrderCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    try:
        service = db.query(models.Service).filter(models.Service.id == order.service_id).first()
        if not service:
            raise HTTPException(status_code=404, detail="Service not found")
        
        db_order = models.Order(
            user_id=current_user.id,
            service_id=order.service_id,
            notes=order.notes,
            status="قيد المراجعة"
        )
        db.add(db_order)
        db.commit()
        db.refresh(db_order)
        # تحميل بيانات الخدمة للرد
        db_order.service = service
        return db_order
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Create order error: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to create order: {str(e)}")

@router.get("/", response_model=List[schemas.Order])
def list_my_orders(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    try:
        orders = db.query(models.Order).filter(models.Order.user_id == current_user.id).all()
        # تحميل بيانات الخدمة لكل طلب
        for order in orders:
            db.refresh(order, attribute_names=['service'])
        return orders
    except Exception as e:
        logger.error(f"List orders error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to list orders: {str(e)}")

@router.get("/{order_id}", response_model=schemas.Order)
def get_order(
    order_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    try:
        order = db.query(models.Order).filter(
            models.Order.id == order_id,
            models.Order.user_id == current_user.id
        ).first()
        if not order:
            raise HTTPException(status_code=404, detail="Order not found")
        db.refresh(order, attribute_names=['service'])
        return order
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Get order error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to get order: {str(e)}")

# routers/wallet.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import schemas, models, auth
from database import get_db

router = APIRouter(prefix="/wallet", tags=["Wallet"])

def get_user_balance(db: Session, user_id: int) -> float:
    transactions = db.query(models.WalletTransaction).filter(models.WalletTransaction.user_id == user_id).all()
    balance = 0.0
    for t in transactions:
        if t.type == "شحن" or t.type == "استرداد":
            balance += t.amount
        elif t.type == "دفع":
            balance -= t.amount
    return balance

@router.get("/balance", response_model=schemas.WalletBalance)
def get_balance(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    balance = get_user_balance(db, current_user.id)
    return {"balance": balance}

@router.get("/transactions", response_model=List[schemas.WalletTransaction])
def list_transactions(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    transactions = db.query(models.WalletTransaction).filter(
        models.WalletTransaction.user_id == current_user.id
    ).order_by(models.WalletTransaction.created_at.desc()).all()
    return transactions

@router.post("/charge", response_model=schemas.WalletTransaction)
def charge_wallet(
    charge: schemas.WalletCharge,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    # شحن وهمي – يتم إضافة رصيد
    transaction = models.WalletTransaction(
        user_id=current_user.id,
        type="شحن",
        amount=charge.amount,
        description="شحن رصيد عبر المحفظة"
    )
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return transaction

# يمكن إضافة عملية دفع عند إنشاء طلب، لكننا سنفعلها في مسار الطلبات لاحقاً
@router.post("/pay/{order_id}", response_model=schemas.WalletTransaction)
def pay_for_order(
    order_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    # التحقق من وجود الطلب
    order = db.query(models.Order).filter(models.Order.id == order_id, models.Order.user_id == current_user.id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    
    # التحقق من أن الطلب لم يدفع مسبقاً (نتجنب الدفع المكرر)
    existing = db.query(models.WalletTransaction).filter(
        models.WalletTransaction.order_id == order_id,
        models.WalletTransaction.type == "دفع"
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Order already paid")
    
    # الحصول على تكلفة الخدمة
    service = db.query(models.Service).filter(models.Service.id == order.service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Service not found")
    
    cost = service.cost
    if cost <= 0:
        raise HTTPException(status_code=400, detail="Service is free, no payment needed")
    
    # التحقق من الرصيد
    balance = get_user_balance(db, current_user.id)
    if balance < cost:
        raise HTTPException(status_code=400, detail="Insufficient balance")
    
    # إنشاء معاملة دفع
    transaction = models.WalletTransaction(
        user_id=current_user.id,
        type="دفع",
        amount=cost,
        description=f"دفع مقابل خدمة: {service.name_ar}",
        order_id=order.id
    )
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return transaction
# routers/community.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import schemas, models, auth
from database import get_db

router = APIRouter(prefix="/community", tags=["Community"])

@router.get("/experiences", response_model=List[schemas.Experience])
def list_experiences(
    service_id: int = None,
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db)
):
    query = db.query(models.Experience)
    if service_id:
        query = query.filter(models.Experience.service_id == service_id)
    experiences = query.order_by(models.Experience.created_at.desc()).offset(skip).limit(limit).all()
    # تحميل بيانات المستخدم والخدمة
    for exp in experiences:
        db.refresh(exp, attribute_names=['user', 'service'])
    return experiences

@router.post("/experiences", response_model=schemas.Experience)
def create_experience(
    exp: schemas.ExperienceCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    # التحقق من وجود الخدمة
    service = db.query(models.Service).filter(models.Service.id == exp.service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Service not found")
    
    db_exp = models.Experience(
        user_id=current_user.id,
        service_id=exp.service_id,
        content=exp.content,
        rating=exp.rating
    )
    db.add(db_exp)
    db.commit()
    db.refresh(db_exp)
    # تحميل بيانات المستخدم والخدمة للرد
    db.refresh(db_exp, attribute_names=['user', 'service'])
    return db_exp
# routers/services.py
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List, Optional
import schemas, models
from database import get_db

router = APIRouter(prefix="/services", tags=["Services"])

@router.get("/", response_model=List[schemas.Service])
def list_services(
    skip: int = 0,
    limit: int = 100,
    category: Optional[str] = None,
    db: Session = Depends(get_db)
):
    query = db.query(models.Service).filter(models.Service.is_active == True)
    if category:
        query = query.filter(models.Service.category == category)
    services = query.offset(skip).limit(limit).all()
    return services

@router.get("/search", response_model=List[schemas.Service])
def search_services(q: str = Query(..., min_length=1), db: Session = Depends(get_db)):
    services = db.query(models.Service).filter(
        models.Service.name_ar.contains(q) | models.Service.description.contains(q)
    ).all()
    return services

@router.get("/{service_id}", response_model=schemas.Service)
def get_service(service_id: int, db: Session = Depends(get_db)):
    service = db.query(models.Service).filter(models.Service.id == service_id).first()
    if not service:
        raise HTTPException(status_code=404, detail="Service not found")
    return service
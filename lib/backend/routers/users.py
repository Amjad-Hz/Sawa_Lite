# routers/users.py
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import List
import schemas
import auth
import models
from database import get_db
from datetime import timedelta
from config import settings
import logging

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/users", tags=["Users"])
@router.post("/register", response_model=schemas.User)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    try:
        db_user = db.query(models.User).filter(models.User.phone == user.phone).first()
        if db_user:
            raise HTTPException(status_code=400, detail="Phone number already registered")
        
        # التحقق مما إذا كان هذا أول مستخدم
        is_first_user = db.query(models.User).count() == 0
        
        hashed_password = auth.get_password_hash(user.password)
        db_user = models.User(
            phone=user.phone,
            email=user.email,
            full_name=user.full_name,
            password_hash=hashed_password,
            role='admin' if is_first_user else 'user'   # أول مستخدم يصبح Admin
        )
        db.add(db_user)
        db.commit()
        db.refresh(db_user)
        logger.info(f"User registered successfully: {user.phone} as {db_user.role}")
        return db_user
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Registration error: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Registration failed: {str(e)}")

@router.post("/login", response_model=schemas.Token)
def login(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: Session = Depends(get_db)
):
    """
    تسجيل الدخول باستخدام اسم المستخدم (رقم الهاتف) وكلمة المرور.
    - **username**: يجب إدخال رقم الهاتف هنا
    - **password**: كلمة المرور
    """
    try:
        # نستخدم form_data.username كرقم الهاتف
        user = auth.authenticate_user(db, form_data.username, form_data.password)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect phone or password",
                headers={"WWW-Authenticate": "Bearer"},
            )
        access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        access_token = auth.create_access_token(
            data={"sub": str(user.id)}, expires_delta=access_token_expires
        )
        return {"access_token": access_token, "token_type": "bearer"}
    except Exception as e:
        logger.error(f"Login error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Login failed: {str(e)}")

@router.get("/me", response_model=schemas.User)
def read_users_me(current_user: models.User = Depends(auth.get_current_active_user)):
    return current_user

@router.put("/me", response_model=schemas.User)
def update_user(
    user_update: schemas.UserUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_active_user)
):
    try:
        if user_update.full_name is not None:
            current_user.full_name = user_update.full_name
        if user_update.email is not None:
            current_user.email = user_update.email
        db.commit()
        db.refresh(current_user)
        return current_user
    except Exception as e:
        logger.error(f"Update user error: {str(e)}")
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Update failed: {str(e)}")
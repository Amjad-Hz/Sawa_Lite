# main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine, Base
import models  # لضمان تسجيل الجداول
from routers import users, services, orders, wallet, community, admin

# إنشاء الجداول (يمكن استخدام init_db بدلاً من ذلك)
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Swa Lite API",
    description="الخلفية الخاصة بمشروع سوا لايت - منصة خدمات حكومية مبسطة",
    version="1.0.0"
)

# إعداد CORS للسماح للواجهة الأمامية بالتواصل
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # في الإنتاج حدد النطاقات المسموحة
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# تضمين المسارات
app.include_router(users.router)
app.include_router(services.router)
app.include_router(orders.router)
app.include_router(wallet.router)
app.include_router(community.router)

app.include_router(admin.router)

@app.get("/")
def root():
    return {"message": "Welcome to Swa Lite API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
# config.py
from pydantic_settings import BaseSettings
from pathlib import Path

class Settings(BaseSettings):
    DATABASE_URL: str = "sqlite:///./swa_lite.db"
    SECRET_KEY: str = "your-secret-key-change-in-production"  # غيّر القيمة في الإنتاج
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60  # مدة صلاحية التوكن

    class Config:
        env_file = ".env"

settings = Settings()
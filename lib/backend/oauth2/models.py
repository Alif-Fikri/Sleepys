from sqlalchemy import Column, Integer, String, Time, DateTime, ForeignKey, Float, Date, Enum
from sqlalchemy.orm import relationship
from .database import Base
from datetime import datetime


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    name = Column(String, nullable=True)
    gender = Column(Integer, nullable=True)
    work = Column(String, nullable=True)
    date_of_birth = Column(Date, nullable=True)
    age = Column(Integer)
    weight = Column(Float, default=0.0)
    height = Column(Float, default=0.0)
    upper_pressure = Column(Integer, nullable=True)
    lower_pressure = Column(Integer, nullable=True)
    daily_steps = Column(Integer, nullable=True)
    heart_rate = Column(Integer, nullable=True)
    reset_token = Column(String, nullable=True)

    sleep_records = relationship("SleepRecord", back_populates="user", cascade="all, delete-orphan")
    
class SleepRecord(Base):
    __tablename__ = "sleep_records"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email"), nullable=False)  # ForeignKey to the User's email
    sleep_time = Column(DateTime, nullable=False)
    wake_time = Column(DateTime, nullable=False)
    duration = Column(Float, nullable=False)  # Duration of sleep in hours

    user = relationship("User", back_populates="sleep_records")

class Work(Base):
    __tablename__ = "work_data"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email"), nullable=False)
    work_id = Column(Integer, nullable=True)
    quality_of_sleep = Column(Float, nullable=True)
    physical_activity_level = Column(Float, nullable=True)
    stress_level = Column(Float, nullable=True)
    
class Daily(Base):
    __tablename__ = "daily"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email"), nullable=False)
    date = Column(Date, nullable=False)
    upper_pressure = Column(Integer, nullable=True)
    lower_pressure = Column(Integer, nullable=True)
    daily_steps = Column(Integer, nullable=True)
    heart_rate = Column(Integer, nullable=True)
    sleep_duration = Column(Float, nullable=False)
    
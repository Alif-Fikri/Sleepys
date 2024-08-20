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
    gender = Column(Enum('female', 'male'), nullable=True)
    work = Column(String, nullable=True)
    date_of_birth = Column(Date, nullable=True)
    weight = Column(Float, nullable=True)
    height = Column(Float, nullable=True)
    upper_pressure = Column(Integer, nullable=True)
    lower_pressure = Column(Integer, nullable=True)
    daily_steps = Column(Integer, nullable=True)
    
    sleep_records = relationship("SleepRecord", back_populates="user", cascade="all, delete-orphan")
    
class SleepRecord(Base):
    __tablename__ = "sleep_records"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email"), nullable=False)  # Foreign key relationship to the User's email
    sleep_time = Column(DateTime, nullable=False)
    wake_time = Column(DateTime, nullable=False)
    duration = Column(Time, nullable=False)

    # Establish relationship with User (back reference to User model)
    user = relationship("User", back_populates="sleep_records")

class Daily(Base):
    __tablename__ = "work_data"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, ForeignKey("users.email"), nullable=False)
    quality_of_sleep = Column(Float, nullable=True)
    physical_activity_level = Column(Float, nullable=True)
    stress_level = Column(Float, nullable=True)
    
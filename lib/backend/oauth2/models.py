from sqlalchemy import Column, Integer, String, Float, Date, Enum
from .database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    name = Column(String, nullable=True)
    gender = Column(Enum('male', 'female'), nullable=True)
    birth_date = Column(Date, nullable=True)
    weight = Column(Float, nullable=True)
    height = Column(Float, nullable=True)
    blood_pressure_systolic = Column(Integer, nullable=True)
    blood_pressure_diastolic = Column(Integer, nullable=True)
    daily_steps = Column(Integer, nullable=True)

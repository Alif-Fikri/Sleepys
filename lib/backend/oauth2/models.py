from sqlalchemy import Column, Integer, String, Float, Date, Enum, ForeignKey
from .database import Base

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

    
from pydantic import BaseModel
from datetime import date

class UserCreate(BaseModel):
    email: str
    password: str
    name: str
    gender: str
    birth_date: date
    weight: float
    height: float
    blood_pressure_systolic: int
    blood_pressure_diastolic: int
    daily_steps: int

class Token(BaseModel):
    access_token: str
    token_type: str

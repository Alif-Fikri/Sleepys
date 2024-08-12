from pydantic import BaseModel
from datetime import date

class UserCreate(BaseModel):
    email: str
    password: str

class Token(BaseModel):
    access_token: str
    token_type: str
    
class NameRequest(BaseModel):
    name: str
    email: str
        
class UserUpdate(BaseModel):
    name: str = None
    email: str = None
    gender: str = None
    work: str = None
    date_of_birth: str = None
    weight: int = None
    height: int = None
    upper_pressure: int = None
    lower_pressure: int = None
    daily_steps: int = None
    
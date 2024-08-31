import logging
from fastapi import FastAPI, Depends, HTTPException, status, Request, Form, Query
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy import extract
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from datetime import datetime, timedelta, date
from . import models, schemas, utils, database
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, EmailStr
from fastapi import Request
from sqlalchemy import func
import pickle
import numpy as np
from flask import Flask, request, jsonify
import joblib
import os
from sklearn.exceptions import NotFittedError
from dotenv import load_dotenv
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from fastapi import HTTPException
import secrets
from fastapi.responses import HTMLResponse
from .database import get_db
from .models import User
import urllib.parse


model_path = os.path.join(os.getcwd(), 'ml_model', 'xgb_model_tuned.pkl')
model = joblib.load(model_path)
gender_path = os.path.join(os.getcwd(), 'ml_model', 'Gender_label_encoder.pkl')
gender_encoder = joblib.load(gender_path)
occupation_encoder_path = os.path.join(os.getcwd(), 'ml_model', 'Occupation_label_encoder.pkl')
occupation_encoder = joblib.load(occupation_encoder_path)
bmi_encoder_path = os.path.join(os.getcwd(), 'ml_model', 'BMI Category_label_encoder.pkl')
bmi_encoder = joblib.load(bmi_encoder_path)
scaler_path = os.path.join(os.getcwd(), 'ml_model', 'minmax_scaler_split.pkl')
scaler = joblib.load(scaler_path)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Database initialization
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()
load_dotenv()
otp_storage = {}

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
EMAIL_SENDER = os.getenv("EMAIL_SENDER")
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD")

# JWT configuration
SECRET_KEY = "2&aSeI[]ILhEP-I"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

def send_otp_email(to_email: str, otp: str):
    try:
        msg = MIMEMultipart()
        msg["From"] = EMAIL_SENDER
        msg["To"] = to_email
        msg["Subject"] = "Your OTP Code"

        body = f"Your OTP code is {otp}. It is valid for 5 minutes."
        msg.attach(MIMEText(body, "plain"))

        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(EMAIL_SENDER, EMAIL_PASSWORD)
        server.sendmail(EMAIL_SENDER, to_email, msg.as_string())
        server.quit()
    except Exception as e:
        print(f"Failed to send email: {e}")
        raise HTTPException(status_code=500, detail="Failed to send OTP email")

@app.post("/request-otp/")
async def request_otp(email: str, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Generate and store OTP
    otp = secrets.token_hex(3)  # Simple OTP generation (6-digit hex)
    otp_expiry = datetime.utcnow() + timedelta(minutes=5)  # OTP valid for 5 minutes
    otp_storage[email] = {"otp": otp, "expiry": otp_expiry}

    # Send OTP via email
    send_otp_email(email, otp)
    return {"message": "OTP sent to your email"}

@app.post("/verify-otp/")
async def verify_otp(email: str = Query(...), otp: str = Query(...)):
    stored_otp_data = otp_storage.get(email)

    if not stored_otp_data or stored_otp_data['otp'] != otp:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    if stored_otp_data['expiry'] < datetime.utcnow():
        raise HTTPException(status_code=400, detail="OTP expired")

    return {"message": "OTP verified"}

@app.post("/reset-password/")
async def reset_password(email: str, new_password: str, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    user.hashed_password = utils.get_password_hash(new_password)
    db.commit()

    return {"message": "Password successfully reset"}

@app.get("/user/{email}")
async def get_user(email: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# Utility functions
def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

class LoginRequest(BaseModel):
    email: str
    password: str
    
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")
@app.post("/logout/")
async def logout(token: str = Depends(oauth2_scheme)):
    # Tambahkan logika untuk menghapus sesi pengguna atau token
    return {"msg": "Logout successful"}
    
@app.post("/login/")
async def login(request: LoginRequest, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == request.email).first()
    
    # Cek apakah user terdaftar
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Email tidak terdaftar")
    
    # Verifikasi password
    if not utils.verify_password(request.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Password salah")
    
    # Generate token
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": user.email}, expires_delta=access_token_expires)
    
    # Log user login untuk debugging
    logging.info(f"User {user.email} login successful.")
    
    # Hanya mengembalikan token
    return {
        "access_token": access_token,
        "token_type": "bearer"
    }
    
def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(database.get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    # Cari pengguna di database berdasarkan email yang ada di token
    user = db.query(models.User).filter(models.User.email == email).first()
    if user is None:
        raise credentials_exception
    
    return user

@app.get("/user-profile/")
async def get_user_profile(current_user: models.User = Depends(get_current_user)):
    logging.info(f"User Data: {current_user.name}, {current_user.gender}, {current_user.work}, {current_user.date_of_birth}, {current_user.height}, {current_user.weight}, {current_user.upper_pressure}, {current_user.lower_pressure}")
    return {
    "name": current_user.name or "",
    "gender": current_user.gender or "",
    "work": current_user.work or "",
    "date_of_birth": current_user.date_of_birth or "",
    "height": current_user.height or 0,
    "weight": current_user.weight or 0,
    "upper_pressure": current_user.upper_pressure or 0,
    "lower_pressure": current_user.lower_pressure or 0,
    }

class PredictRequest(BaseModel):
    email: EmailStr 

@app.post("/predict")
def predict(request: PredictRequest, db: Session = Depends(database.get_db)):
    try:
        # Extract email from the request body
        email = request.email

        # Fetch user data from the 'users' table
        user_data = db.query(models.User).filter(models.User.email == email).first()

        if not user_data:
            raise HTTPException(status_code=404, detail="User not found")
        
        # Fetch data from the relevant tables using email
        sleep_record = db.query(models.SleepRecord).filter(models.SleepRecord.email == email).first()
        work_data = db.query(models.Work).filter(models.Work.email == email).first()

        if not sleep_record or not work_data:
            raise HTTPException(status_code=404, detail="Incomplete data for prediction")

        # Extract user data from the tables
        age = user_data.age
        gender = user_data.gender  # 0 for female, 1 for male
        occupation = work_data.work_id  # Encoded occupation ID
        bmi_category = 0  # Set a default value or obtain it from another source
        quality_of_sleep = work_data.quality_of_sleep
        physical_activity_level = work_data.physical_activity_level
        stress_level = work_data.stress_level
        heart_rate = user_data.heart_rate
        daily_step = user_data.daily_steps
        systolic = user_data.upper_pressure
        diastolic = user_data.lower_pressure
        sleep_duration = sleep_record.duration
        
        # Example additional feature for a total of 12 features
        additional_feature = 0  # Replace with the appropriate feature if necessary

        # Prepare numerical features for scaling
        numerical_features = [
            age, sleep_duration, quality_of_sleep, physical_activity_level,
            stress_level, heart_rate, daily_step, systolic, diastolic, additional_feature
        ]

        # Initialize complete_features with zeros (ensure it has 12 features)
        complete_features = np.zeros((1, 12))  # Ensure total of 12 features

        # Insert the first 10 numerical features into complete_features
        complete_features[0, :10] = numerical_features  # Update to accommodate 10 features

        # Scale numerical features
        scaled_features = scaler.transform(complete_features).flatten()

        # Construct the final features list for the model
        features = np.array([
            gender, 
            scaled_features[0], 
            occupation,  
            scaled_features[1],  
            scaled_features[2],  
            scaled_features[3],  
            scaled_features[4],  
            bmi_category,  
            scaled_features[5],  
            scaled_features[6],  
            scaled_features[7], 
            scaled_features[8]  
        ]).reshape(1, -1)

        # Make prediction
        prediction = model.predict(features)

        # Map prediction to disorder type
        if prediction == 0:
            result = 'Insomnia'
        elif prediction == 1:
            result = 'Normal'
        elif prediction == 2:
            result = 'Sleep Apnea'
        
        return {"prediction": result}

    except ValueError as e:
        logging.error(f"ValueError during prediction: {e}")
        raise HTTPException(status_code=400, detail="Data format issue.")
    except Exception as e:
        logging.error(f"Prediction error: {e}")
        raise HTTPException(status_code=500, detail=f"An error occurred during prediction: {str(e)}")

@app.post("/register/")
def register(user: schemas.UserCreate, db: Session = Depends(database.get_db)):
    existing_user = db.query(models.User).filter(models.User.email == user.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    hashed_password = utils.get_password_hash(user.password)
    db_user = models.User(
        email=user.email,
        hashed_password=hashed_password,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": db_user.email}, expires_delta=access_token_expires)
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": db_user
    }


@app.put("/save-name/")
async def save_name(name_request: schemas.NameRequest, db: Session = Depends(database.get_db)):
    logger.info(f"Received request to save name: {name_request.name} for email: {name_request.email}")
    try:
        user = db.query(models.User).filter(models.User.email == name_request.email).first()
        if user:
            logger.info(f"Found user: {user.email}")
            user.name = name_request.name
            db.commit()
            db.refresh(user)
            logger.info("Name saved successfully")
            return {"message": "Name saved successfully", "user": user}
        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error saving name: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to save name: {e}")


@app.put("/save-gender/")
async def save_gender(user_data: schemas.UserUpdate, db: Session = Depends(database.get_db)):
    logger.info(f"Received request to update user data: {user_data}")
    try:
        user = db.query(models.User).filter(models.User.name == user_data.name).first()
        if user:
            logger.info(f"Found user: {user.email}")
            if user_data.gender is not None:
                logger.info(f"Updating gender to: {user_data.gender}")
                user.gender = user_data.gender
            db.commit()
            db.refresh(user)
            logger.info("Gender saved successfully")
            return {"message": "Gender saved successfully", "user": user}
        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error updating user data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update user data: {e}")


@app.put("/save-work/")
async def save_work(user_data: schemas.UserUpdate, db: Session = Depends(database.get_db)):
    logger.info(f"Received request to update user data: {user_data}")
    try:
        user = db.query(models.User).filter(models.User.email == user_data.email).first()
        
        if user:
            logger.info(f"Found user: {user.email}")
            if user_data.work:
                # Map pekerjaan ke work_id
                work_id_map = {
                    'Accountant': 0,
                    'Doctor': 1,
                    'Engineer': 2,
                    'Lawyer': 3,
                    'Manager': 4,
                    'Nurse': 5,
                    'Sales Representative': 6,
                    'Salesperson': 7,
                    'Scientist': 8,
                    'Software Engineer': 9,
                    'Teacher': 10
                }
                
                # Update pekerjaan dan work_id
                user.work = user_data.work
                user.work_id = work_id_map[user_data.work]
                
                # Update or insert into daily table
                daily_data = db.query(models.Work).filter(models.Work.email == user.email).first()
                
                # Data yang sesuai berdasarkan pekerjaan
                work_data = {
                    'Accountant': (7.891892, 58.108108, 4.594595),
                    'Doctor': (6.647887, 55.352113, 6.732394),
                    'Engineer': (8.412698, 51.857143, 3.888889),
                    'Lawyer': (7.893617, 70.425532, 5.063830),
                    'Manager': (7.0, 55.0, 5.0),
                    'Nurse': (7.369863, 78.589041, 5.547945),
                    'Sales Representative': (4.0, 30.0, 8.0),
                    'Salesperson': (6.0, 45.0, 7.0),
                    'Scientist': (5.0, 41.0, 7.0),
                    'Software Engineer': (6.5, 48.0, 6.0),
                    'Teacher': (6.975, 45.625, 4.525)
                }

                quality_of_sleep, physical_activity_level, stress_level = work_data[user_data.work]

                if daily_data:
                    # Jika entri ada, update
                    daily_data.quality_of_sleep = quality_of_sleep
                    daily_data.physical_activity_level = physical_activity_level
                    daily_data.stress_level = stress_level
                    daily_data.work_id = user.work_id
                else:
                    # Jika entri belum ada, insert baru
                    new_daily = models.Work(
                        email=user.email,
                        quality_of_sleep=quality_of_sleep,
                        physical_activity_level=physical_activity_level,
                        stress_level=stress_level,
                        work_id=user.work_id  # Tambahkan work_id ke Work
                    )
                    db.add(new_daily)
                    
                db.commit()
                db.refresh(user)
                logger.info("Work and daily data saved successfully")
                return {"message": "Work and daily data saved successfully", "user": user}
        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error updating user data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update user data: {e}")


@app.put("/save-dob/")
async def save_dob(user_data: schemas.UserUpdate, db: Session = Depends(database.get_db)):
    logger.info(f"Received request to update user data: {user_data}")
    try:
        user = db.query(models.User).filter(models.User.name == user_data.name).first()
        if user:
            logger.info(f"Found user: {user.email}")
            if user_data.date_of_birth:
                # Set date_of_birth
                user.date_of_birth = user_data.date_of_birth
                logger.info(f"Setting date_of_birth to: {user_data.date_of_birth}")
                
                # Calculate age based on date_of_birth
                birth_date = datetime.strptime(user_data.date_of_birth, '%Y-%m-%d')
                today = datetime.today()
                age = today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))
                
                # Set age to user
                user.age = age
                logger.info(f"Setting age to: {age}")
            
            db.commit()
            db.refresh(user)
            
            # Cetak informasi pengguna yang relevan
            logger.info(f"User after refresh: {user.email}, {user.name}, {user.date_of_birth}, {user.age}")
            logger.info("Date of birth and age saved successfully")
            return {"message": "Date of birth and age saved successfully", "user": user}

        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error updating user data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update user data: {e}")

@app.put("/save-weight/")
async def save_weight(user_data: schemas.UserUpdate, db: Session = Depends(database.get_db)):
    logger.info(f"Received request to update user data: {user_data}")
    try:
        user = db.query(models.User).filter(models.User.name == user_data.name).first()
        if user:
            logger.info(f"Found user: {user.email}")
            if user_data.weight:
                user.weight = user_data.weight
            db.commit()
            db.refresh(user)
            logger.info("Weight saved successfully")
            return {"message": "Weight saved successfully", "user": user}
        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error updating user data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update user data: {e}")


@app.put("/save-height/")
async def save_height(user_data: schemas.UserUpdate, db: Session = Depends(database.get_db)):
    logger.info(f"Received request to update user data: {user_data}")
    try:
        user = db.query(models.User).filter(models.User.name == user_data.name).first()
        if user:
            logger.info(f"Found user: {user.email}")
            if user_data.height:
                user.height = user_data.height
            db.commit()
            db.refresh(user)
            logger.info("Height saved successfully")
            return {"message": "Height saved successfully", "user": user}
        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error updating user data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update user data: {e}")


@app.put("/save-blood-pressure/")
async def save_blood_pressure(request: Request, db: Session = Depends(database.get_db)):
    data = await request.json()
    email = data.get('email')
    upper_pressure = data.get('upperPressure')
    lower_pressure = data.get('lowerPressure')

    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    try:
        user.upper_pressure = upper_pressure
        user.lower_pressure = lower_pressure
        db.commit()
        db.refresh(user)
        return {"message": "Blood pressure saved successfully", "user": user}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to save blood pressure: {e}")
    
@app.put("/save-daily-steps/")
async def save_daily_steps(request: Request, db: Session = Depends(database.get_db)):
    data = await request.json()
    email = data.get('email')
    daily_steps = data.get('dailySteps')

    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    try:
        user.daily_steps = daily_steps
        db.commit()
        db.refresh(user)
        return {"message": "Daily steps saved successfully", "user": user}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to save daily steps: {e}")
    
@app.put("/save-heart-rate/")
async def save_heart_rate(request: Request, db: Session = Depends(database.get_db)):
    data = await request.json()
    email = data.get('email')
    heart_rate = data.get('heartRate')

    user = db.query(models.User).filter(models.User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    try:
        user.heart_rate = heart_rate  # Ganti daily_steps dengan heart_rate
        db.commit()
        db.refresh(user)
        return {"message": "Heart rate saved successfully", "user": user}
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=f"Failed to save heart rate: {e}")


async def update_user_data(request: schemas.UserUpdate, db: Session):
    logger.info(f"Received request to update user data: {request}")
    try:
        user = db.query(models.User).filter(models.User.email == request.email).first()
        if user:
            if request.name is not None:
                user.name = request.name
            if request.gender is not None:
                user.gender = request.gender
            if request.work is not None:
                user.work = request.work
            if request.date_of_birth is not None:
                user.date_of_birth = request.date_of_birth
            if request.weight is not None:
                user.weight = request.weight
            if request.height is not None:
                user.height = request.height
            db.commit()
            db.refresh(user)
            logger.info("User data updated successfully")
            return {"message": "User data updated successfully", "user": user}
        else:
            logger.warning("User not found")
            raise HTTPException(status_code=404, detail="User not found")
    except Exception as e:
        logger.error(f"Error updating user data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update user data: {e}")

@app.get("/user-profile/")
async def get_user_profile(email: str, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == email).first()
    if user:
        return user
    else:
        raise HTTPException(status_code=404, detail="User not found")


@app.put("/user-profile/update")
async def update_user_profile(user_data: schemas.UserUpdate, db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == user_data.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Update user fields if provided in user_data
    update_fields = ["name", "gender", "work", "date_of_birth", "weight", "height", "upper_pressure", "lower_pressure"]
    for field in update_fields:
        if getattr(user_data, field) is not None:
            setattr(user, field, getattr(user_data, field))

    db.commit()
    db.refresh(user)

    return {"message": "User profile updated successfully", "user": user}

@app.post("/save-sleep-record/")
async def save_sleep_record(sleep_data: schemas.SleepData, db: Session = Depends(database.get_db)):
    # Find the user by email
    user = db.query(models.User).filter(models.User.email == sleep_data.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Calculate the sleep duration in hours (float)
    sleep_time = sleep_data.sleep_time
    wake_time = sleep_data.wake_time

    if sleep_time >= wake_time:
        wake_time += timedelta(days=1)  # Handle crossing midnight

    duration = (wake_time - sleep_time).total_seconds() / 3600  # Duration in hours

    # Check for existing sleep record for the same date
    existing_record = db.query(models.SleepRecord).filter(
        models.SleepRecord.email == user.email,
        extract('year', models.SleepRecord.sleep_time) == sleep_time.year,
        extract('month', models.SleepRecord.sleep_time) == sleep_time.month,
        extract('day', models.SleepRecord.sleep_time) == sleep_time.day
    ).first()

    if existing_record:
        # Update existing record with the new data only if it's more recent
        if sleep_time > existing_record.sleep_time:
            existing_record.sleep_time = sleep_time
            existing_record.wake_time = wake_time
            existing_record.duration = duration
            db.commit()
            db.refresh(existing_record)
            return {"message": "Sleep record updated successfully", "sleep_record": existing_record}
        else:
            return {"message": "Older sleep record ignored; existing record is more recent", "sleep_record": existing_record}
    else:
        # Create a new SleepRecord associated with the user's email
        new_sleep_record = models.SleepRecord(
            email=user.email,  
            sleep_time=sleep_time,
            wake_time=wake_time,
            duration=duration  
        )

        db.add(new_sleep_record)
        db.commit()
        db.refresh(new_sleep_record)

        return {"message": "Sleep record saved successfully", "sleep_record": new_sleep_record}

@app.get("/get-sleep-records/{email}")
async def get_sleep_records(email: str, db: Session = Depends(database.get_db)):
    # Retrieve the user based on the email
    user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Fetch all sleep records associated with the user, ordered by sleep_time descending
    sleep_records = db.query(models.SleepRecord).filter(
        models.SleepRecord.email == email
    ).order_by(models.SleepRecord.sleep_time.desc()).all()

    if not sleep_records:
        raise HTTPException(status_code=404, detail="No sleep records found")

    # Use a dictionary to store the latest record for each date
    latest_records = {}
    for record in sleep_records:
        record_date = record.sleep_time.date()
        # Only keep the latest record for each date
        if record_date not in latest_records:
            latest_records[record_date] = record

    # Prepare the response data
    response_data = []
    for record in latest_records.values():
        # Calculate duration using DateTime difference
        duration = record.wake_time - record.sleep_time
        # Format the duration to hours and minutes
        formatted_duration = f"{duration.seconds // 3600} jam {duration.seconds % 3600 // 60} menit"
        # Format sleep and wake times
        formatted_time = f"{record.sleep_time.strftime('%H:%M')} - {record.wake_time.strftime('%H:%M')}"
        # Format the date
        formatted_date = record.sleep_time.strftime('%d %B %Y')  # Use sleep_time's date
        # Add the data to the response
        response_data.append({
            "date": formatted_date,
            "duration": formatted_duration,
            "time": formatted_time
        })

    return response_data


@app.get("/get-weekly-sleep-data/{email}")
async def get_weekly_sleep_data(email: str, start_date: str, end_date: str, db: Session = Depends(database.get_db)):
    # Convert string dates to datetime objects
    start_date_obj = datetime.strptime(start_date, "%Y-%m-%d")
    end_date_obj = datetime.strptime(end_date, "%Y-%m-%d") + timedelta(days=1)  # Extend to include the full end day

    # Retrieve sleep records for the user between the start and end date
    sleep_records = db.query(models.SleepRecord).filter(
        models.SleepRecord.email == email,
        models.SleepRecord.sleep_time >= start_date_obj,
        models.SleepRecord.wake_time < end_date_obj
    ).order_by(models.SleepRecord.sleep_time.desc()).all()  # Sort by sleep_time descending

    if not sleep_records:
        raise HTTPException(status_code=404, detail="No sleep records found for the week")

    # Filter to keep only the latest record per day
    latest_records_per_day = {}
    for record in sleep_records:
        record_date = record.sleep_time.date()
        # Only keep the latest record for each date
        if record_date not in latest_records_per_day:
            latest_records_per_day[record_date] = record

    # Initialize dictionaries to store sleep durations, start times, and wake times for each day
    daily_sleep_durations = {i: timedelta() for i in range(7)}  # {0: Monday, ..., 6: Sunday}
    daily_sleep_start_times = {i: [] for i in range(7)}  # Store sleep start times for each day
    daily_wake_times = {i: [] for i in range(7)}  # Store wake times for each day

    for record in latest_records_per_day.values():
        # Handle cross-midnight sleep records
        if record.wake_time < record.sleep_time:
            record.wake_time += timedelta(days=1)

        duration = record.wake_time - record.sleep_time

        # Calculate the day of the week for the sleep time (0=Monday, 6=Sunday)
        day_of_week = record.sleep_time.weekday()
        daily_sleep_durations[day_of_week] += duration

        # Store the sleep start time for the day
        daily_sleep_start_times[day_of_week].append(record.sleep_time.strftime("%H:%M"))
        
        # Store the wake time for the day
        daily_wake_times[day_of_week].append(record.wake_time.strftime("%H:%M"))

    # Convert timedelta to hours for each day
    daily_sleep_durations_hours = [round(daily_sleep_durations[i].total_seconds() / 3600, 2) for i in range(7)]

    # Calculate total duration as the sum of daily sleep durations
    total_duration = sum(daily_sleep_durations_hours)

    # Calculate averages
    avg_duration = total_duration / len(latest_records_per_day)
    avg_sleep_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:])) 
                          for times in daily_sleep_start_times.values() for time in times), timedelta()) 
                      / len(latest_records_per_day))
    avg_wake_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:])) 
                         for times in daily_wake_times.values() for time in times), timedelta()) 
                     / len(latest_records_per_day))

    return {
        "daily_sleep_durations": daily_sleep_durations_hours,
        "daily_sleep_start_times": daily_sleep_start_times,  # Field with sleep start times
        "daily_wake_times": daily_wake_times,  # New field with wake times
        "avg_duration": f"{int(avg_duration)} jam {int((avg_duration * 60) % 60)} menit",
        "avg_sleep_time": (datetime.min + avg_sleep_time).strftime("%H:%M"),
        "avg_wake_time": (datetime.min + avg_wake_time).strftime("%H:%M"),
        "total_duration": f"{int(total_duration)} jam {int((total_duration * 60) % 60)} menit"
    }

@app.get("/get-monthly-sleep-data/{email}")
async def get_monthly_sleep_data(email: str, month: str, year: int, db: Session = Depends(database.get_db)):
    # Calculate the start and end dates for the month
    start_date_obj = datetime(year, int(month), 1)
    next_month = start_date_obj.replace(day=28) + timedelta(days=4)  # This will always jump to the next month
    end_date_obj = next_month - timedelta(days=next_month.day)

    # Retrieve sleep records for the user between the start and end dates
    sleep_records = db.query(models.SleepRecord).filter(
        models.SleepRecord.email == email,
        models.SleepRecord.sleep_time >= start_date_obj,
        models.SleepRecord.wake_time < end_date_obj + timedelta(days=1)  # Include the entire end day
    ).order_by(models.SleepRecord.sleep_time.desc()).all()  # Sort by sleep_time descending

    if not sleep_records:
        raise HTTPException(status_code=404, detail="No sleep records found for the month")

    # Filter to keep only the latest record per day
    latest_records_per_day = {}
    for record in sleep_records:
        record_date = record.sleep_time.date()
        # Only keep the latest record for each date
        if record_date not in latest_records_per_day:
            latest_records_per_day[record_date] = record

    # Initialize dictionaries to store weekly sleep durations, start times, and wake times
    weekly_sleep_durations = {i: timedelta() for i in range(4)}  # {0: Week 1, ..., 3: Week 4}
    weekly_sleep_start_times = {i: [] for i in range(4)}  # Store sleep start times for each week
    weekly_wake_times = {i: [] for i in range(4)}  # Store wake times for each week

    for record in latest_records_per_day.values():
        # Handle cross-midnight sleep records
        if record.wake_time < record.sleep_time:
            record.wake_time += timedelta(days=1)

        duration = record.wake_time - record.sleep_time

        # Calculate the week of the month for the sleep time (0=Week 1, ..., 3=Week 4)
        week_of_month = ((record.sleep_time - start_date_obj).days // 7)
        if week_of_month > 3:
            week_of_month = 3  # Ensure no out-of-bounds index for weeks

        weekly_sleep_durations[week_of_month] += duration

        # Store the sleep start time for the week
        weekly_sleep_start_times[week_of_month].append(record.sleep_time.strftime("%H:%M"))

        # Store the wake time for the week
        weekly_wake_times[week_of_month].append(record.wake_time.strftime("%H:%M"))

    # Convert timedelta to hours for each week
    weekly_sleep_durations_hours = [round(weekly_sleep_durations[i].total_seconds() / 3600, 2) for i in range(4)]

    # Calculate total duration as the sum of weekly sleep durations
    total_duration = sum(weekly_sleep_durations_hours)

    # Calculate averages
    avg_duration = total_duration / len(latest_records_per_day)
    avg_sleep_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:]))
                          for times in weekly_sleep_start_times.values() for time in times), timedelta())
                      / len(latest_records_per_day))
    avg_wake_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:]))
                         for times in weekly_wake_times.values() for time in times), timedelta())
                     / len(latest_records_per_day))

    return {
        "weekly_sleep_durations": weekly_sleep_durations_hours,
        "weekly_sleep_start_times": weekly_sleep_start_times,  # Field with sleep start times
        "weekly_wake_times": weekly_wake_times,  # New field with wake times
        "avg_duration": f"{int(avg_duration)} jam {int((avg_duration * 60) % 60)} menit",
        "avg_sleep_time": (datetime.min + avg_sleep_time).strftime("%H:%M"),
        "avg_wake_time": (datetime.min + avg_wake_time).strftime("%H:%M"),
        "total_duration": f"{int(total_duration)} jam {int((total_duration * 60) % 60)} menit"
    }

@app.post("/token", response_model=schemas.Token)
def login_for_access_token(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(database.get_db)):
    user = db.query(models.User).filter(models.User.email == form_data.username).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email tidak terdaftar",
            headers={"WWW-Authenticate": "Bearer"},
        )
    if not utils.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Password salah",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}
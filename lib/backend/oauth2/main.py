import logging
from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from jose import JWTError, jwt
from datetime import datetime, timedelta
from . import models, schemas, utils, database
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from fastapi import Request
from sqlalchemy import func

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Database initialization
models.Base.metadata.create_all(bind=database.engine)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# JWT configuration
SECRET_KEY = "2&aSeI[]ILhEP-I"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

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
    if not user:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Email tidak terdaftar")
    if not utils.verify_password(request.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Password salah")
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub": user.email}, expires_delta=access_token_expires)
    
    # Menyertakan informasi tambahan
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "name": user.name,
        "gender": user.gender,
        "work": user.work,
        "date_of_birth": user.date_of_birth,
        "height": user.height,
        "weight": user.weight,
        "upper_pressure": user.upper_pressure,
        "lower_pressure": user.lower_pressure,
    }


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
            if user_data.gender:
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
                user.work = user_data.work
                
                # Update or insert into daily table
                daily_data = db.query(models.Daily).filter(models.Daily.email == user.email).first()
                
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
                else:
                    # Jika entri belum ada, insert baru
                    new_daily = models.Daily(
                        email=user.email,
                        quality_of_sleep=quality_of_sleep,
                        physical_activity_level=physical_activity_level,
                        stress_level=stress_level
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
                user.date_of_birth = user_data.date_of_birth
                logger.info(f"Setting date_of_birth to: {user_data.date_of_birth}")
            db.commit()
            db.refresh(user)
            logger.info(f"User after refresh: {user}")
            logger.info("Date of birth saved successfully")
            return {"message": "Date of birth saved successfully", "user": user}
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

async def update_user_data(request: schemas.UserUpdate, db: Session):
    logger.info(f"Received request to update user data: {request}")
    try:
        user = db.query(models.User).filter(models.User.email == request.email).first()
        if user:
            if request.name is not None:
                user.name = request.name
            if request.gender is not None:
                user.gender = request.gender
            if request.pekerjaan is not None:
                user.pekerjaan = request.pekerjaan
            if request.tanggal_lahir is not None:
                user.tanggal_lahir = request.tanggal_lahir
            if request.berat_badan is not None:
                user.berat_badan = request.berat_badan
            if request.tinggi_badan is not None:
                user.tinggi_badan = request.tinggi_badan
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

    if user_data.name:
        user.name = user_data.name
    if user_data.gender:
        user.gender = user_data.gender
    if user_data.work:
        user.work = user_data.work
    if user_data.date_of_birth:
        user.date_of_birth = user_data.date_of_birth
    if user_data.weight:
        user.weight = user_data.weight
    if user_data.height:
        user.height = user_data.height
    if user_data.upper_pressure:
        user.upper_pressure = user_data.upper_pressure
    if user_data.lower_pressure:
        user.lower_pressure = user_data.lower_pressure

    db.commit()
    db.refresh(user)
    return {"message": "User profile updated successfully", "user": user}

@app.post("/save-sleep-record/")
async def save_sleep_record(sleep_data: schemas.SleepData, db: Session = Depends(database.get_db)):
    # Find the user by email
    user = db.query(models.User).filter(models.User.email == sleep_data.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Create a new SleepRecord associated with the user's email using DateTime
    new_sleep_record = models.SleepRecord(
        email=user.email,  # Use email instead of user_id
        sleep_time=sleep_data.sleep_time,  # Menggunakan DateTime langsung
        wake_time=sleep_data.wake_time
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

    # Fetch all sleep records associated with the user
    sleep_records = db.query(models.SleepRecord).filter(models.SleepRecord.email == email).all()

    if not sleep_records:
        raise HTTPException(status_code=404, detail="No sleep records found")

    response_data = []
    for record in sleep_records:
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
    ).all()

    if not sleep_records:
        raise HTTPException(status_code=404, detail="No sleep records found for the week")

    # Initialize dictionaries to store sleep durations, start times, and wake times for each day
    daily_sleep_durations = {i: timedelta() for i in range(7)}  # {0: Monday, ..., 6: Sunday}
    daily_sleep_start_times = {i: [] for i in range(7)}  # Store sleep start times for each day
    daily_wake_times = {i: [] for i in range(7)}  # Store wake times for each day

    for record in sleep_records:
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
    avg_duration = total_duration / len(sleep_records)
    avg_sleep_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:])) 
                          for times in daily_sleep_start_times.values() for time in times), timedelta()) 
                      / len(sleep_records))
    avg_wake_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:])) 
                         for times in daily_wake_times.values() for time in times), timedelta()) 
                     / len(sleep_records))

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
    ).all()

    if not sleep_records:
        raise HTTPException(status_code=404, detail="No sleep records found for the month")

    # Initialize dictionaries to store weekly sleep durations, start times, and wake times
    weekly_sleep_durations = {i: timedelta() for i in range(4)}  # {0: Week 1, ..., 3: Week 4}
    weekly_sleep_start_times = {i: [] for i in range(4)}  # Store sleep start times for each week
    weekly_wake_times = {i: [] for i in range(4)}  # Store wake times for each week

    for record in sleep_records:
        # Handle cross-midnight sleep records
        if record.wake_time < record.sleep_time:
            record.wake_time += timedelta(days=1)

        duration = record.wake_time - record.sleep_time

        # Calculate the week of the month for the sleep time (1=Week 1, 4=Week 4)
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
    avg_duration = total_duration / len(sleep_records)
    avg_sleep_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:]))
                          for times in weekly_sleep_start_times.values() for time in times), timedelta())
                      / len(sleep_records))
    avg_wake_time = (sum((timedelta(hours=int(time[:2]), minutes=int(time[3:]))
                         for times in weekly_wake_times.values() for time in times), timedelta())
                     / len(sleep_records))

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
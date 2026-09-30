import os
import psycopg2
from psycopg2.extras import RealDictCursor
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="MedConnect API")
Instrumentator().instrument(app).expose(app)


def get_db():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "db"),
        dbname=os.getenv("DB_NAME", "medconnect"),
        user=os.getenv("DB_USER", "medconnect"),
        password=os.getenv("DB_PASSWORD", "changeme"),
        cursor_factory=RealDictCursor,
    )


def query(sql, params=None):
    conn = get_db()
    cur = conn.cursor()
    cur.execute(sql, params or ())
    rows = cur.fetchall()
    conn.close()
    return rows


class Booking(BaseModel):
    doctor_id: int | None = None
    test_id: int | None = None
    patient_name: str
    patient_phone: str
    slot: str


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/hospitals")
def list_hospitals(city: str | None = None):
    if city:
        return query("SELECT * FROM hospitals WHERE city ILIKE %s", (city,))
    return query("SELECT * FROM hospitals")


@app.get("/doctors")
def list_doctors(specialty: str | None = None, city: str | None = None):
    sql = """
        SELECT d.id, d.name, d.specialty, d.consultation_fee,
               h.name AS hospital, h.city, h.latitude, h.longitude
        FROM doctors d
        JOIN hospitals h ON d.hospital_id = h.id
        WHERE (%s IS NULL OR d.specialty ILIKE %s)
          AND (%s IS NULL OR h.city ILIKE %s)
        ORDER BY d.consultation_fee
    """
    return query(sql, (specialty, specialty, city, city))


@app.get("/tests")
def list_tests(name: str | None = None, city: str | None = None):
    sql = """
        SELECT t.id, t.name, t.price, t.turnaround_hours,
               l.name AS lab, l.city, l.address
        FROM tests t
        JOIN labs l ON t.lab_id = l.id
        WHERE (%s IS NULL OR t.name ILIKE %s)
          AND (%s IS NULL OR l.city ILIKE %s)
        ORDER BY t.price
    """
    return query(sql, (name, name, city, city))


@app.post("/bookings", status_code=201)
def create_booking(b: Booking):
    if not b.doctor_id and not b.test_id:
        raise HTTPException(400, "Provide either doctor_id or test_id")
    conn = get_db()
    cur = conn.cursor()
    cur.execute(
        """INSERT INTO bookings (doctor_id, test_id, patient_name, patient_phone, slot)
           VALUES (%s, %s, %s, %s, %s) RETURNING *""",
        (b.doctor_id, b.test_id, b.patient_name, b.patient_phone, b.slot),
    )
    row = cur.fetchone()
    conn.commit()
    conn.close()
    return row


@app.get("/bookings")
def list_bookings():
    return query("SELECT * FROM bookings ORDER BY created_at DESC")

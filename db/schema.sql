CREATE TABLE hospitals (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL,
    phone TEXT
);

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    hospital_id INTEGER REFERENCES hospitals(id),
    name TEXT NOT NULL,
    specialty TEXT NOT NULL,
    consultation_fee INTEGER NOT NULL
);

CREATE TABLE labs (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT NOT NULL,
    latitude DECIMAL(9,6) NOT NULL,
    longitude DECIMAL(9,6) NOT NULL
);

CREATE TABLE tests (
    id SERIAL PRIMARY KEY,
    lab_id INTEGER REFERENCES labs(id),
    name TEXT NOT NULL,
    price INTEGER NOT NULL,
    turnaround_hours INTEGER NOT NULL
);

CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER REFERENCES doctors(id),
    test_id INTEGER REFERENCES tests(id),
    patient_name TEXT NOT NULL,
    patient_phone TEXT NOT NULL,
    slot TIMESTAMP NOT NULL,
    status TEXT NOT NULL DEFAULT 'confirmed',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_doctors_specialty ON doctors(specialty);
CREATE INDEX idx_hospitals_city ON hospitals(city);
CREATE INDEX idx_labs_city ON labs(city);

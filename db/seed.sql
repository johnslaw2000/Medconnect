INSERT INTO hospitals (name, address, city, latitude, longitude, phone) VALUES
('Lagoon Hospital', '17A Bourdillon Road, Ikoyi', 'Lagos', 6.448600, 3.432400, '+2348012345001'),
('Reddington Hospital', '12 Idowu Martins, Victoria Island', 'Lagos', 6.428700, 3.421500, '+2348012345002'),
('Garki Hospital', 'Tafawa Balewa Way, Area 3', 'Abuja', 9.033600, 7.489300, '+2348012345003'),
('Nisa Premier Hospital', '15 Cadastral Zone, Jabi', 'Abuja', 9.065700, 7.432100, '+2348012345004'),
('UCH Ibadan', 'Queen Elizabeth Road', 'Ibadan', 7.399800, 3.897000, '+2348012345005');

INSERT INTO doctors (hospital_id, name, specialty, consultation_fee) VALUES
(1, 'Dr. Adeyemi Okafor', 'Cardiology', 25000),
(1, 'Dr. Ngozi Balogun', 'Paediatrics', 15000),
(2, 'Dr. Tunde Bakare', 'Dermatology', 18000),
(2, 'Dr. Aisha Mohammed', 'Cardiology', 30000),
(3, 'Dr. Emeka Nwosu', 'Orthopaedics', 22000),
(3, 'Dr. Fatima Sani', 'Paediatrics', 12000),
(4, 'Dr. Chidi Eze', 'Neurology', 35000),
(5, 'Dr. Yemi Adeleke', 'General Practice', 8000);

INSERT INTO labs (name, address, city, latitude, longitude) VALUES
('Synlab Nigeria', '23 Awolowo Road, Ikoyi', 'Lagos', 6.451200, 3.428900),
('Clinix Healthcare', '5 Ademola Street, Victoria Island', 'Lagos', 6.430100, 3.419800),
('Me Cure Healthcare', 'Plot 234, Wuse 2', 'Abuja', 9.078400, 7.466200);

INSERT INTO tests (lab_id, name, price, turnaround_hours) VALUES
(1, 'Malaria Parasite Test', 3500, 4),
(1, 'Full Blood Count', 8000, 24),
(1, 'Lipid Profile', 15000, 48),
(2, 'Malaria Parasite Test', 5000, 2),
(2, 'Full Blood Count', 9500, 12),
(3, 'Malaria Parasite Test', 4000, 6),
(3, 'Liver Function Test', 18000, 48);

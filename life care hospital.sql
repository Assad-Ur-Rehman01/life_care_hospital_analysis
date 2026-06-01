-- This is a hospital management system 
-- Creating the database for hospital 

-- DROP DATABASE lifecare_hospital

CREATE DATABASE lifecare_hospital ;

USE lifecare_hospital ;

-- TABLE FOR PATIENTS 

CREATE TABLE patients (
patient_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL , 
last_name VARCHAR(50),
gender VARCHAR(50) DEFAULT 'OTHER',
date_of_birth DATE NOT NULL ,
phone VARCHAR(15) UNIQUE NOT NULL , 
email VARCHAR(100) UNIQUE , 
address TEXT ,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP );

-- TABLE FOR CASES 

CREATE TABLE cases (
    case_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    case_type ENUM(
        'Emergency',
        'Police',
        'Normal',
        'Labour',
        'Accident'
    ) NOT NULL,
    case_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- TABLE FOR DEPARTMENT 

CREATE TABLE departments (
department_id INT PRIMARY KEY AUTO_INCREMENT ,
department_name VARCHAR(50) NOT NULL ,
description TEXT );

-- TABLE FOR DOCTORS 

CREATE TABLE doctors(
doctor_id INT PRIMARY KEY AUTO_INCREMENT ,
first_name VARCHAR(50) NOT NULL , 
last_name VARCHAR(50), 
specialization VARCHAR(50) NOT NULL, 
phone VARCHAR(15) UNIQUE NOT NULL , 
email VARCHAR(100) UNIQUE NOT NULL , 
department_id INT NOT NULL , 
FOREIGN KEY (department_id) REFERENCES departments(department_id) ,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP );

-- TABLE FOR DOCTOR AVAILABILTITY 

CREATE TABLE doctor_availability (
    availability_id INT PRIMARY KEY AUTO_INCREMENT,
    doctor_id INT NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_on_call BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- TABLE FOR CASE DOCTOR

CREATE TABLE case_doctors (
    case_doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    case_id INT NOT NULL,
    doctor_id INT NOT NULL,
    doctor_role ENUM('Attending','Consultant','Surgeon','OnCall') NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (case_id) REFERENCES cases(case_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- TABLE FOR STAFF 

CREATE TABLE staff (
staff_id INT PRIMARY KEY AUTO_INCREMENT ,
name VARCHAR(50) NOT NULL , 
role VARCHAR(50) NOT NULL , 
phone VARCHAR(15) UNIQUE NOT NULL , 
email VARCHAR(100) UNIQUE );

-- TABLE FOR USER 

CREATE TABLE users (
user_id INT PRIMARY KEY AUTO_INCREMENT,
username VARCHAR(50) NOT NULL , 
password VARCHAR(255) NOT NULL , 
role ENUM('Admin','Doctor','Nurse','Receptionist','Pharmacist'),
staff_id INT NOT NULL , 
FOREIGN KEY (staff_id) REFERENCES staff(staff_id) );

-- TABLE FOR APPOINTMENT

CREATE TABLE appointments(
appointment_id INT PRIMARY KEY AUTO_INCREMENT ,
patient_id INT NOT NULL, 
doctor_id INT NOT NULL, 
appointment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP , 
status ENUM('Schedule', 'complete', 'cancelled') DEFAULT 'Schedule' ,
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) );

-- TABLE FOR MEDICAL RECORDS

CREATE TABLE records(
record_id INT PRIMARY KEY AUTO_INCREMENT ,
patient_id INT NOT NULL, 
doctor_id INT NOT NULL, 
visited_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
note TEXT , 
FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) ) ;

-- TABLE FOR DIAGNOSES 

CREATE TABLE diagnoses (
diagnoses_id INT PRIMARY KEY AUTO_INCREMENT , 
diagnoses VARCHAR(150) NOT NULL , 
record_id INT NOT NULL , 
FOREIGN KEY (record_id) REFERENCES records(record_id) );

-- TABLE FOR PRESCRIPTION 
CREATE TABLE prescription (
prescription_id INT PRIMARY KEY AUTO_INCREMENT , 
record_id INT NOT NULL, 
prescription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
FOREIGN KEY (record_id) REFERENCES records(record_id) );

-- TABLE FOR MEDICINES 

CREATE TABLE medicines(
medicine_id INT PRIMARY KEY AUTO_INCREMENT , 
medicine_name VARCHAR(100) NOT NULL , 
formula VARCHAR(100) NOT NULL ,
price DECIMAL(11,2)  );

-- TABLE FOR ALTERNATIVE MEDICINE

CREATE TABLE alternative_medicines(
alt_medicine_id INT PRIMARY KEY AUTO_INCREMENT , 
alt_medicine_name VARCHAR(100) NOT NULL , 
formula VARCHAR(100) NOT NULL , 
medicine_id INT NOT NULL,
price DECIMAL(11,2),
FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)  );

-- TABLE FOR prescription items 

CREATE TABLE prescription_items (
    prescription_item_id INT PRIMARY KEY AUTO_INCREMENT,
    prescription_id INT NOT NULL,
    medicine_id INT NOT NULL,
    lab_test VARCHAR(100),
    dosage VARCHAR(50) NOT NULL,
    duration VARCHAR(50) NOT NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id),
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicine_id)
);

-- TABLE FOR LAB TEST 

CREATE TABLE lab_tests (
    test_id INT PRIMARY KEY AUTO_INCREMENT,
    test_name VARCHAR(100) UNIQUE NOT NULL,
    cost DECIMAL(10,2) NOT NULL ,
    prescription_item_id INT NOT NULL,
    FOREIGN KEY (prescription_item_id) REFERENCES prescription_items(prescription_item_id)
);

-- TABLE FOR TEST RESULT 

CREATE TABLE test_results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    record_id INT NOT NULL,
    test_id INT NOT NULL,
    result VARCHAR(255),
    test_date DATE NOT NULL,
    FOREIGN KEY (record_id) REFERENCES records(record_id),
    FOREIGN KEY (test_id) REFERENCES lab_tests(test_id)
);

-- TABLE FOR BILLING 

CREATE TABLE billing (
    bill_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_id INT NOT NULL,
    bill_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- TABLE FOR INVOICE ITEMS 

CREATE TABLE invoice_items (
    invoice_item_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES billing(bill_id)
) ;

-- TABLE FOR PAYMENTS 

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    bill_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('Cash','Card','UPI','Insurance') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (bill_id) REFERENCES billing(bill_id)
);

-- DUMMY DATA FOR PATIENT

INSERT INTO patients (first_name, last_name, gender, date_of_birth, phone, email, address)
VALUES
('Liam', 'Smith', 'Male', '1985-04-12', '555-0101', 'liam.smith@example.com', '123 Maple St, Springfield'),
('Olivia', 'Johnson', 'Female', '1990-08-22', '555-0102', 'olivia.johnson@example.com', '456 Oak St, Springfield'),
('Noah', 'Williams', 'Male', '1978-01-05', '555-0103', 'noah.williams@example.com', '789 Pine St, Springfield'),
('Emma', 'Brown', 'Female', '1988-11-15', '555-0104', 'emma.brown@example.com', '321 Elm St, Springfield'),
('James', 'Jones', 'Male', '1992-05-30', '555-0105', 'james.jones@example.com', '654 Cedar St, Springfield'),
('Ava', 'Garcia', 'Female', '1983-07-18', '555-0106', 'ava.garcia@example.com', '987 Birch St, Springfield'),
('William', 'Miller', 'Male', '1995-02-25', '555-0107', 'william.miller@example.com', '147 Spruce St, Springfield'),
('Sophia', 'Davis', 'Female', '1980-12-09', '555-0108', 'sophia.davis@example.com', '258 Walnut St, Springfield'),
('Benjamin', 'Rodriguez', 'Male', '1975-03-14', '555-0109', 'benjamin.rodriguez@example.com', '369 Chestnut St, Springfield'),
('Isabella', 'Martinez', 'Female', '1998-09-21', '555-0110', 'isabella.martinez@example.com', '159 Hickory St, Springfield'),
('Lucas', 'Hernandez', 'Male', '1982-06-07', '555-0111', 'lucas.hernandez@example.com', '753 Aspen St, Springfield'),
('Mia', 'Lopez', 'Female', '1987-10-11', '555-0112', 'mia.lopez@example.com', '951 Poplar St, Springfield'),
('Mason', 'Gonzalez', 'Male', '1991-01-29', '555-0113', 'mason.gonzalez@example.com', '852 Fir St, Springfield'),
('Charlotte', 'Wilson', 'Female', '1984-08-03', '555-0114', 'charlotte.wilson@example.com', '654 Maple St, Springfield'),
('Ethan', 'Anderson', 'Male', '1979-04-22', '555-0115', 'ethan.anderson@example.com', '357 Oak St, Springfield'),
('Amelia', 'Thomas', 'Female', '1993-12-17', '555-0116', 'amelia.thomas@example.com', '258 Pine St, Springfield'),
('Alexander', 'Taylor', 'Male', '1986-09-10', '555-0117', 'alexander.taylor@example.com', '147 Elm St, Springfield'),
('Harper', 'Moore', 'Female', '1997-05-05', '555-0118', 'harper.moore@example.com', '369 Cedar St, Springfield'),
('Michael', 'Jackson', 'Male', '1981-02-13', '555-0119', 'michael.jackson@example.com', '753 Birch St, Springfield'),
('Evelyn', 'Martin', 'Female', '1990-07-28', '555-0120', 'evelyn.martin@example.com', '951 Spruce St, Springfield'),
('Daniel', 'Lee', 'Male', '1988-03-19', '555-0121', 'daniel.lee@example.com', '852 Walnut St, Springfield'),
('Abigail', 'Perez', 'Female', '1994-11-23', '555-0122', 'abigail.perez@example.com', '654 Chestnut St, Springfield'),
('Matthew', 'Thompson', 'Male', '1983-06-02', '555-0123', 'matthew.thompson@example.com', '357 Hickory St, Springfield'),
('Ella', 'White', 'Female', '1985-10-30', '555-0124', 'ella.white@example.com', '258 Aspen St, Springfield'),
('David', 'Harris', 'Male', '1992-01-16', '555-0125', 'david.harris@example.com', '147 Poplar St, Springfield'),
('Scarlett', 'Sanchez', 'Female', '1987-08-12', '555-0126', 'scarlett.sanchez@example.com', '369 Fir St, Springfield'),
('Joseph', 'Clark', 'Male', '1976-05-25', '555-0127', 'joseph.clark@example.com', '753 Maple St, Springfield'),
('Victoria', 'Ramirez', 'Female', '1991-09-06', '555-0128', 'victoria.ramirez@example.com', '951 Oak St, Springfield'),
('Samuel', 'Lewis', 'Male', '1989-11-14', '555-0129', 'samuel.lewis@example.com', '852 Pine St, Springfield'),
('Grace', 'Robinson', 'Female', '1982-02-27', '555-0130', 'grace.robinson@example.com', '654 Elm St, Springfield'),
('Henry', 'Walker', 'Male', '1984-12-01', '555-0131', 'henry.walker@example.com', '357 Cedar St, Springfield'),
('Chloe', 'Young', 'Female', '1995-03-08', '555-0132', 'chloe.young@example.com', '258 Birch St, Springfield'),
('Jackson', 'Allen', 'Male', '1980-07-19', '555-0133', 'jackson.allen@example.com', '147 Spruce St, Springfield'),
('Lily', 'King', 'Female', '1993-05-22', '555-0134', 'lily.king@example.com', '369 Walnut St, Springfield'),
('Sebastian', 'Wright', 'Male', '1987-10-15', '555-0135', 'sebastian.wright@example.com', '753 Chestnut St, Springfield'),
('Hannah', 'Scott', 'Female', '1990-01-04', '555-0136', 'hannah.scott@example.com', '951 Hickory St, Springfield'),
('Aiden', 'Torres', 'Male', '1986-09-11', '555-0137', 'aiden.torres@example.com', '852 Aspen St, Springfield'),
('Aria', 'Nguyen', 'Female', '1994-06-07', '555-0138', 'aria.nguyen@example.com', '654 Poplar St, Springfield'),
('Logan', 'Hill', 'Male', '1983-03-21', '555-0139', 'logan.hill@example.com', '357 Fir St, Springfield'),
('Eleanor', 'Flores', 'Female', '1985-12-25', '555-0140', 'eleanor.flores@example.com', '258 Maple St, Springfield'),
('Lucas', 'Green', 'Male', '1978-07-02', '555-0141', 'lucas.green@example.com', '147 Oak St, Springfield'),
('Zoe', 'Adams', 'Female', '1991-11-18', '555-0142', 'zoe.adams@example.com', '369 Pine St, Springfield'),
('Nathan', 'Baker', 'Male', '1982-05-14', '555-0143', 'nathan.baker@example.com', '753 Elm St, Springfield'),
('Penelope', 'Gonzales', 'Female', '1988-09-09', '555-0144', 'penelope.gonzales@example.com', '951 Cedar St, Springfield'),
('Ryan', 'Nelson', 'Male', '1990-02-20', '555-0145', 'ryan.nelson@example.com', '852 Birch St, Springfield'),
('Lillian', 'Carter', 'Female', '1984-08-08', '555-0146', 'lillian.carter@example.com', '654 Spruce St, Springfield'),
('Christian', 'Mitchell', 'Male', '1987-04-27', '555-0147', 'christian.mitchell@example.com', '357 Walnut St, Springfield'),
('Addison', 'Perez', 'Female', '1995-03-15', '555-0148', 'addison.perez@example.com', '258 Chestnut St, Springfield'),
('Anthony', 'Roberts', 'Male', '1981-10-01', '555-0149', 'anthony.roberts@example.com', '147 Hickory St, Springfield'),
('Emily', 'Turner', 'Female', '1993-06-30', '555-0150', 'emily.turner@example.com', '369 Aspen St, Springfield');

-- DUMMY DATA FOR CASE 

INSERT INTO cases (patient_id, case_type, case_date)
VALUES
(1, 'Emergency', '2025-12-05 10:23:00'),
(2, 'Normal', '2025-11-20 14:45:00'),
(3, 'Accident', '2025-10-15 09:30:00'),
(4, 'Labour', '2025-09-12 07:15:00'),
(5, 'Police', '2025-08-01 16:40:00'),
(6, 'Emergency', '2025-07-22 11:10:00'),
(7, 'Normal', '2025-06-17 13:50:00'),
(8, 'Accident', '2025-05-10 08:05:00'),
(9, 'Emergency', '2025-04-28 12:20:00'),
(10, 'Normal', '2025-03-15 15:30:00'),
(11, 'Labour', '2025-02-10 06:50:00'),
(12, 'Emergency', '2025-01-25 09:45:00'),
(13, 'Accident', '2024-12-18 14:15:00'),
(14, 'Normal', '2024-11-09 16:55:00'),
(15, 'Police', '2024-10-03 11:40:00'),
(16, 'Labour', '2024-09-22 07:30:00'),
(17, 'Emergency', '2024-08-14 12:00:00'),
(18, 'Accident', '2024-07-05 09:20:00'),
(19, 'Normal', '2024-06-30 10:15:00'),
(20, 'Police', '2024-05-25 13:50:00'),
(21, 'Emergency', '2024-04-18 08:40:00'),
(22, 'Normal', '2024-03-12 15:25:00'),
(23, 'Accident', '2024-02-28 09:30:00'),
(24, 'Labour', '2024-01-15 06:10:00'),
(25, 'Police', '2023-12-20 16:45:00'),
(26, 'Emergency', '2023-11-10 11:35:00'),
(27, 'Normal', '2023-10-05 14:50:00'),
(28, 'Accident', '2023-09-22 08:55:00'),
(29, 'Labour', '2023-08-18 07:20:00'),
(30, 'Emergency', '2023-07-10 13:15:00'),
(31, 'Normal', '2023-06-03 10:45:00'),
(32, 'Accident', '2023-05-22 09:10:00'),
(33, 'Police', '2023-04-14 15:30:00'),
(34, 'Emergency', '2023-03-05 12:00:00'),
(35, 'Labour', '2023-02-25 06:50:00'),
(36, 'Normal', '2023-01-10 14:10:00'),
(37, 'Accident', '2022-12-18 11:40:00'),
(38, 'Emergency', '2022-11-07 09:55:00'),
(39, 'Police', '2022-10-03 16:30:00'),
(40, 'Normal', '2022-09-20 13:20:00'),
(41, 'Labour', '2022-08-12 07:15:00'),
(42, 'Emergency', '2022-07-05 12:25:00'),
(43, 'Accident', '2022-06-30 08:50:00'),
(44, 'Normal', '2022-05-15 15:40:00'),
(45, 'Police', '2022-04-10 11:05:00'),
(46, 'Emergency', '2022-03-01 09:30:00'),
(47, 'Labour', '2022-02-18 06:45:00'),
(48, 'Accident', '2022-01-05 14:15:00'),
(49, 'Normal', '2021-12-20 10:50:00'),
(50, 'Police', '2021-11-10 13:30:00');


-- DUMMY DATA FOR DEPARTMENTS 

INSERT INTO departments (department_name, description)
VALUES
('Cardiology', 'Deals with heart-related conditions and treatments.'),
('Neurology', 'Focuses on disorders of the nervous system and brain.'),
('Orthopedics', 'Handles musculoskeletal issues, bones, joints, and ligaments.'),
('Pediatrics', 'Cares for infants, children, and adolescents.'),
('Obstetrics & Gynecology', 'Manages pregnancy, childbirth, and female reproductive health.'),
('Emergency', 'Provides immediate care for acute illnesses or injuries.'),
('Radiology', 'Performs imaging tests like X-rays, MRI, and CT scans.'),
('Oncology', 'Diagnoses and treats cancer and related conditions.'),
('Dermatology', 'Deals with skin, hair, and nail disorders.'),
('General Surgery', 'Performs surgical procedures for various conditions.');

-- DUMMY DATA FOR DOCTORS 

INSERT INTO doctors (first_name, last_name, specialization, phone, email, department_id, created_at)
VALUES
('Liam', 'Smith', 'Cardiologist', '555-1001', 'liam.smith@hospital.com', 1, '2024-01-05 09:30:00'),
('Olivia', 'Johnson', 'Neurologist', '555-1002', 'olivia.johnson@hospital.com', 2, '2024-02-10 10:15:00'),
('Noah', 'Williams', 'Orthopedic Surgeon', '555-1003', 'noah.williams@hospital.com', 3, '2024-03-12 11:45:00'),
('Emma', 'Brown', 'Pediatrician', '555-1004', 'emma.brown@hospital.com', 4, '2024-04-08 08:50:00'),
('James', 'Jones', 'Obstetrician', '555-1005', 'james.jones@hospital.com', 5, '2024-05-15 12:20:00'),
('Ava', 'Garcia', 'Emergency Physician', '555-1006', 'ava.garcia@hospital.com', 6, '2024-06-20 09:40:00'),
('William', 'Miller', 'Radiologist', '555-1007', 'william.miller@hospital.com', 7, '2024-07-11 14:10:00'),
('Sophia', 'Davis', 'Oncologist', '555-1008', 'sophia.davis@hospital.com', 8, '2024-08-25 10:55:00'),
('Benjamin', 'Rodriguez', 'Dermatologist', '555-1009', 'benjamin.rodriguez@hospital.com', 9, '2024-09-18 11:35:00'),
('Isabella', 'Martinez', 'General Surgeon', '555-1010', 'isabella.martinez@hospital.com', 10, '2024-10-05 09:20:00'),
('Lucas', 'Hernandez', 'Cardiologist', '555-1011', 'lucas.hernandez@hospital.com', 1, '2024-01-18 08:50:00'),
('Mia', 'Lopez', 'Neurologist', '555-1012', 'mia.lopez@hospital.com', 2, '2024-02-22 10:30:00'),
('Mason', 'Gonzalez', 'Orthopedic Surgeon', '555-1013', 'mason.gonzalez@hospital.com', 3, '2024-03-28 11:15:00'),
('Charlotte', 'Wilson', 'Pediatrician', '555-1014', 'charlotte.wilson@hospital.com', 4, '2024-04-14 09:45:00'),
('Ethan', 'Anderson', 'Obstetrician', '555-1015', 'ethan.anderson@hospital.com', 5, '2024-05-30 12:05:00'),
('Amelia', 'Thomas', 'Emergency Physician', '555-1016', 'amelia.thomas@hospital.com', 6, '2024-06-18 08:35:00'),
('Alexander', 'Taylor', 'Radiologist', '555-1017', 'alexander.taylor@hospital.com', 7, '2024-07-12 11:55:00'),
('Harper', 'Moore', 'Oncologist', '555-1018', 'harper.moore@hospital.com', 8, '2024-08-08 10:20:00'),
('Michael', 'Jackson', 'Dermatologist', '555-1019', 'michael.jackson@hospital.com', 9, '2024-09-03 12:40:00'),
('Evelyn', 'Martin', 'General Surgeon', '555-1020', 'evelyn.martin@hospital.com', 10, '2024-10-20 09:10:00'),
('Daniel', 'Lee', 'Cardiologist', '555-1021', 'daniel.lee@hospital.com', 1, '2024-01-25 08:50:00'),
('Abigail', 'Perez', 'Neurologist', '555-1022', 'abigail.perez@hospital.com', 2, '2024-02-15 10:15:00'),
('Matthew', 'Thompson', 'Orthopedic Surgeon', '555-1023', 'matthew.thompson@hospital.com', 3, '2024-03-05 11:30:00'),
('Ella', 'White', 'Pediatrician', '555-1024', 'ella.white@hospital.com', 4, '2024-04-28 09:20:00'),
('David', 'Harris', 'Obstetrician', '555-1025', 'david.harris@hospital.com', 5, '2024-05-19 12:45:00'),
('Scarlett', 'Sanchez', 'Emergency Physician', '555-1026', 'scarlett.sanchez@hospital.com', 6, '2024-06-23 08:10:00'),
('Joseph', 'Clark', 'Radiologist', '555-1027', 'joseph.clark@hospital.com', 7, '2024-07-30 11:50:00'),
('Victoria', 'Ramirez', 'Oncologist', '555-1028', 'victoria.ramirez@hospital.com', 8, '2024-08-17 10:35:00'),
('Samuel', 'Lewis', 'Dermatologist', '555-1029', 'samuel.lewis@hospital.com', 9, '2024-09-12 12:05:00'),
('Grace', 'Robinson', 'General Surgeon', '555-1030', 'grace.robinson@hospital.com', 10, '2024-10-08 09:40:00'),
('Henry', 'Walker', 'Cardiologist', '555-1031', 'henry.walker@hospital.com', 1, '2024-01-10 08:25:00'),
('Chloe', 'Young', 'Neurologist', '555-1032', 'chloe.young@hospital.com', 2, '2024-02-05 10:50:00'),
('Jackson', 'Allen', 'Orthopedic Surgeon', '555-1033', 'jackson.allen@hospital.com', 3, '2024-03-22 11:20:00'),
('Lily', 'King', 'Pediatrician', '555-1034', 'lily.king@hospital.com', 4, '2024-04-12 09:10:00'),
('Sebastian', 'Wright', 'Obstetrician', '555-1035', 'sebastian.wright@hospital.com', 5, '2024-05-08 12:30:00'),
('Hannah', 'Scott', 'Emergency Physician', '555-1036', 'hannah.scott@hospital.com', 6, '2024-06-28 08:55:00'),
('Aiden', 'Torres', 'Radiologist', '555-1037', 'aiden.torres@hospital.com', 7, '2024-07-19 11:40:00'),
('Aria', 'Nguyen', 'Oncologist', '555-1038', 'aria.nguyen@hospital.com', 8, '2024-08-23 10:10:00'),
('Logan', 'Hill', 'Dermatologist', '555-1039', 'logan.hill@hospital.com', 9, '2024-09-08 12:25:00'),
('Eleanor', 'Flores', 'General Surgeon', '555-1040', 'eleanor.flores@hospital.com', 10, '2024-10-16 09:05:00'),
('Lucas', 'Green', 'Cardiologist', '555-1041', 'lucas.green@hospital.com', 1, '2024-01-18 08:40:00'),
('Zoe', 'Adams', 'Neurologist', '555-1042', 'zoe.adams@hospital.com', 2, '2024-02-20 10:25:00'),
('Nathan', 'Baker', 'Orthopedic Surgeon', '555-1043', 'nathan.baker@hospital.com', 3, '2024-03-15 11:55:00'),
('Penelope', 'Gonzales', 'Pediatrician', '555-1044', 'penelope.gonzales@hospital.com', 4, '2024-04-10 09:35:00'),
('Ryan', 'Nelson', 'Obstetrician', '555-1045', 'ryan.nelson@hospital.com', 5, '2024-05-22 12:50:00'),
('Lillian', 'Carter', 'Emergency Physician', '555-1046', 'lillian.carter@hospital.com', 6, '2024-06-18 08:15:00'),
('Christian', 'Mitchell', 'Radiologist', '555-1047', 'christian.mitchell@hospital.com', 7, '2024-07-12 11:05:00'),
('Addison', 'Perez', 'Oncologist', '555-1048', 'addison.perez@hospital.com', 8, '2024-08-06 10:20:00'),
('Anthony', 'Roberts', 'Dermatologist', '555-1049', 'anthony.roberts@hospital.com', 9, '2024-09-02 12:00:00'),
('Emily', 'Turner', 'General Surgeon', '555-1050', 'emily.turner@hospital.com', 10, '2024-10-20 09:30:00');

-- DUMMY DATA FOR DOCTORS availablity

INSERT INTO doctor_availability (doctor_id, day_of_week, start_time, end_time, is_on_call)
VALUES
-- Doctors 1-10
(1, 'Monday', '08:00:00', '14:00:00', FALSE),
(1, 'Wednesday', '10:00:00', '16:00:00', TRUE),
(1, 'Friday', '09:00:00', '15:00:00', FALSE),
(2, 'Tuesday', '09:00:00', '17:00:00', FALSE),
(2, 'Thursday', '08:30:00', '14:30:00', FALSE),
(2, 'Saturday', '10:00:00', '14:00:00', TRUE),
(3, 'Monday', '08:00:00', '12:00:00', FALSE),
(3, 'Wednesday', '13:00:00', '17:00:00', FALSE),
(3, 'Friday', '09:00:00', '15:00:00', TRUE),
(4, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(4, 'Thursday', '09:00:00', '15:00:00', FALSE),
(4, 'Saturday', '10:00:00', '16:00:00', TRUE),
(5, 'Monday', '08:30:00', '14:30:00', FALSE),
(5, 'Wednesday', '09:00:00', '15:00:00', FALSE),
(5, 'Friday', '10:00:00', '16:00:00', TRUE),
(6, 'Tuesday', '08:00:00', '12:00:00', FALSE),
(6, 'Thursday', '09:00:00', '15:00:00', FALSE),
(6, 'Saturday', '08:30:00', '14:30:00', TRUE),
(7, 'Monday', '08:00:00', '16:00:00', FALSE),
(7, 'Wednesday', '09:00:00', '15:00:00', TRUE),
(7, 'Friday', '08:30:00', '14:30:00', FALSE),
(8, 'Tuesday', '08:30:00', '14:30:00', FALSE),
(8, 'Thursday', '09:00:00', '15:00:00', TRUE),
(8, 'Saturday', '08:00:00', '12:00:00', FALSE),
(9, 'Monday', '09:00:00', '15:00:00', FALSE),
(9, 'Wednesday', '08:30:00', '14:30:00', TRUE),
(9, 'Friday', '09:00:00', '15:00:00', FALSE),
(10, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(10, 'Thursday', '09:00:00', '15:00:00', FALSE),
(10, 'Saturday', '08:30:00', '14:30:00', TRUE),

-- Doctors 11-20
(11, 'Monday', '08:00:00', '14:00:00', FALSE),
(11, 'Wednesday', '10:00:00', '16:00:00', TRUE),
(11, 'Friday', '09:00:00', '15:00:00', FALSE),
(12, 'Tuesday', '09:00:00', '17:00:00', FALSE),
(12, 'Thursday', '08:30:00', '14:30:00', FALSE),
(12, 'Saturday', '10:00:00', '14:00:00', TRUE),
(13, 'Monday', '08:00:00', '12:00:00', FALSE),
(13, 'Wednesday', '13:00:00', '17:00:00', FALSE),
(13, 'Friday', '09:00:00', '15:00:00', TRUE),
(14, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(14, 'Thursday', '09:00:00', '15:00:00', FALSE),
(14, 'Saturday', '10:00:00', '16:00:00', TRUE),
(15, 'Monday', '08:30:00', '14:30:00', FALSE),
(15, 'Wednesday', '09:00:00', '15:00:00', FALSE),
(15, 'Friday', '10:00:00', '16:00:00', TRUE),
(16, 'Tuesday', '08:00:00', '12:00:00', FALSE),
(16, 'Thursday', '09:00:00', '15:00:00', FALSE),
(16, 'Saturday', '08:30:00', '14:30:00', TRUE),
(17, 'Monday', '08:00:00', '16:00:00', FALSE),
(17, 'Wednesday', '09:00:00', '15:00:00', TRUE),
(17, 'Friday', '08:30:00', '14:30:00', FALSE),
(18, 'Tuesday', '08:30:00', '14:30:00', FALSE),
(18, 'Thursday', '09:00:00', '15:00:00', TRUE),
(18, 'Saturday', '08:00:00', '12:00:00', FALSE),
(19, 'Monday', '09:00:00', '15:00:00', FALSE),
(19, 'Wednesday', '08:30:00', '14:30:00', TRUE),
(19, 'Friday', '09:00:00', '15:00:00', FALSE),
(20, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(20, 'Thursday', '09:00:00', '15:00:00', FALSE),
(20, 'Saturday', '08:30:00', '14:30:00', TRUE),

-- Doctors 21-50
(21, 'Monday', '08:00:00', '14:00:00', FALSE),
(21, 'Wednesday', '10:00:00', '16:00:00', TRUE),
(21, 'Friday', '09:00:00', '15:00:00', FALSE),
(22, 'Tuesday', '09:00:00', '17:00:00', FALSE),
(22, 'Thursday', '08:30:00', '14:30:00', FALSE),
(22, 'Saturday', '10:00:00', '14:00:00', TRUE),
(23, 'Monday', '08:00:00', '12:00:00', FALSE),
(23, 'Wednesday', '13:00:00', '17:00:00', FALSE),
(23, 'Friday', '09:00:00', '15:00:00', TRUE),
(24, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(24, 'Thursday', '09:00:00', '15:00:00', FALSE),
(24, 'Saturday', '10:00:00', '16:00:00', TRUE),
(25, 'Monday', '08:30:00', '14:30:00', FALSE),
(25, 'Wednesday', '09:00:00', '15:00:00', FALSE),
(25, 'Friday', '10:00:00', '16:00:00', TRUE),
(26, 'Tuesday', '08:00:00', '12:00:00', FALSE),
(26, 'Thursday', '09:00:00', '15:00:00', FALSE),
(26, 'Saturday', '08:30:00', '14:30:00', TRUE),
(27, 'Monday', '08:00:00', '16:00:00', FALSE),
(27, 'Wednesday', '09:00:00', '15:00:00', TRUE),
(27, 'Friday', '08:30:00', '14:30:00', FALSE),
(28, 'Tuesday', '08:30:00', '14:30:00', FALSE),
(28, 'Thursday', '09:00:00', '15:00:00', TRUE),
(28, 'Saturday', '08:00:00', '12:00:00', FALSE),
(29, 'Monday', '09:00:00', '15:00:00', FALSE),
(29, 'Wednesday', '08:30:00', '14:30:00', TRUE),
(29, 'Friday', '09:00:00', '15:00:00', FALSE),
(30, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(30, 'Thursday', '09:00:00', '15:00:00', FALSE),
(30, 'Saturday', '08:30:00', '14:30:00', TRUE),
-- Repeat similar pattern for doctors 31-50
(31, 'Monday', '08:00:00', '14:00:00', FALSE),
(31, 'Wednesday', '10:00:00', '16:00:00', TRUE),
(31, 'Friday', '09:00:00', '15:00:00', FALSE),
(32, 'Tuesday', '09:00:00', '17:00:00', FALSE),
(32, 'Thursday', '08:30:00', '14:30:00', FALSE),
(32, 'Saturday', '10:00:00', '14:00:00', TRUE),
(33, 'Monday', '08:00:00', '12:00:00', FALSE),
(33, 'Wednesday', '13:00:00', '17:00:00', FALSE),
(33, 'Friday', '09:00:00', '15:00:00', TRUE),
(34, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(34, 'Thursday', '09:00:00', '15:00:00', FALSE),
(34, 'Saturday', '10:00:00', '16:00:00', TRUE),
(35, 'Monday', '08:30:00', '14:30:00', FALSE),
(35, 'Wednesday', '09:00:00', '15:00:00', FALSE),
(35, 'Friday', '10:00:00', '16:00:00', TRUE),
(36, 'Tuesday', '08:00:00', '12:00:00', FALSE),
(36, 'Thursday', '09:00:00', '15:00:00', FALSE),
(36, 'Saturday', '08:30:00', '14:30:00', TRUE),
(37, 'Monday', '08:00:00', '16:00:00', FALSE),
(37, 'Wednesday', '09:00:00', '15:00:00', TRUE),
(37, 'Friday', '08:30:00', '14:30:00', FALSE),
(38, 'Tuesday', '08:30:00', '14:30:00', FALSE),
(38, 'Thursday', '09:00:00', '15:00:00', TRUE),
(38, 'Saturday', '08:00:00', '12:00:00', FALSE),
(39, 'Monday', '09:00:00', '15:00:00', FALSE),
(39, 'Wednesday', '08:30:00', '14:30:00', TRUE),
(39, 'Friday', '09:00:00', '15:00:00', FALSE),
(40, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(40, 'Thursday', '09:00:00', '15:00:00', FALSE),
(40, 'Saturday', '08:30:00', '14:30:00', TRUE),
(41, 'Monday', '08:00:00', '14:00:00', FALSE),
(41, 'Wednesday', '10:00:00', '16:00:00', TRUE),
(41, 'Friday', '09:00:00', '15:00:00', FALSE),
(42, 'Tuesday', '09:00:00', '17:00:00', FALSE),
(42, 'Thursday', '08:30:00', '14:30:00', FALSE),
(42, 'Saturday', '10:00:00', '14:00:00', TRUE),
(43, 'Monday', '08:00:00', '12:00:00', FALSE),
(43, 'Wednesday', '13:00:00', '17:00:00', FALSE),
(43, 'Friday', '09:00:00', '15:00:00', TRUE),
(44, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(44, 'Thursday', '09:00:00', '15:00:00', FALSE),
(44, 'Saturday', '10:00:00', '16:00:00', TRUE),
(45, 'Monday', '08:30:00', '14:30:00', FALSE),
(45, 'Wednesday', '09:00:00', '15:00:00', FALSE),
(45, 'Friday', '10:00:00', '16:00:00', TRUE),
(46, 'Tuesday', '08:00:00', '12:00:00', FALSE),
(46, 'Thursday', '09:00:00', '15:00:00', FALSE),
(46, 'Saturday', '08:30:00', '14:30:00', TRUE),
(47, 'Monday', '08:00:00', '16:00:00', FALSE),
(47, 'Wednesday', '09:00:00', '15:00:00', TRUE),
(47, 'Friday', '08:30:00', '14:30:00', FALSE),
(48, 'Tuesday', '08:30:00', '14:30:00', FALSE),
(48, 'Thursday', '09:00:00', '15:00:00', TRUE),
(48, 'Saturday', '08:00:00', '12:00:00', FALSE),
(49, 'Monday', '09:00:00', '15:00:00', FALSE),
(49, 'Wednesday', '08:30:00', '14:30:00', TRUE),
(49, 'Friday', '09:00:00', '15:00:00', FALSE),
(50, 'Tuesday', '08:00:00', '14:00:00', FALSE),
(50, 'Thursday', '09:00:00', '15:00:00', FALSE),
(50, 'Saturday', '08:30:00', '14:30:00', TRUE);

-- DUMMY DATA FOR case DOCTORS

INSERT INTO case_doctors (case_id, doctor_id, doctor_role, assigned_date)
VALUES
-- Cases 1-10 (2025 dates)
(1, 1, 'Attending', '2025-12-05 10:30:00'), (1, 5, 'Consultant', '2025-12-05 11:00:00'),
(2, 2, 'Attending', '2025-11-20 14:55:00'),
(3, 3, 'Attending', '2025-10-15 09:45:00'), (3, 12, 'Surgeon', '2025-10-15 10:30:00'),
(4, 4, 'Attending', '2025-09-12 07:30:00'), (4, 18, 'Consultant', '2025-09-12 08:00:00'),
(5, 5, 'Attending', '2025-08-01 16:50:00'), (5, 25, 'OnCall', '2025-08-01 17:15:00'),
(6, 6, 'Attending', '2025-07-22 11:20:00'),
(7, 7, 'Attending', '2025-06-17 14:00:00'), (7, 14, 'Consultant', '2025-06-17 14:30:00'),
(8, 8, 'Attending', '2025-05-10 08:15:00'),
(9, 9, 'Attending', '2025-04-28 12:35:00'), (9, 3, 'Surgeon', '2025-04-28 13:00:00'),
(10, 10, 'Attending', '2025-03-15 15:45:00'),

-- Cases 11-20 (2024 dates)
(11, 11, 'Attending', '2025-02-10 07:00:00'),
(12, 12, 'Attending', '2025-01-25 10:00:00'), (12, 6, 'Surgeon', '2025-01-25 11:00:00'),
(13, 13, 'Attending', '2024-12-18 14:30:00'),
(14, 14, 'Attending', '2024-11-09 17:10:00'),
(15, 15, 'Attending', '2024-10-03 11:55:00'), (15, 20, 'OnCall', '2024-10-03 12:30:00'),
(16, 16, 'Attending', '2024-09-22 07:45:00'),
(17, 17, 'Attending', '2024-08-14 12:15:00'), (17, 2, 'Consultant', '2024-08-14 13:00:00'),
(18, 18, 'Attending', '2024-07-05 09:40:00'),
(19, 19, 'Attending', '2024-06-30 10:30:00'),
(20, 20, 'Attending', '2024-05-25 14:05:00'),

-- Cases 21-30 (2024-2023 dates)
(21, 21, 'Attending', '2024-04-18 08:55:00'),
(22, 22, 'Attending', '2024-03-12 15:40:00'),
(23, 23, 'Attending', '2024-02-28 09:50:00'),
(24, 24, 'Attending', '2024-01-15 06:30:00'),
(25, 25, 'Attending', '2023-12-20 17:00:00'), (25, 10, 'OnCall', '2023-12-20 17:30:00'),
(26, 26, 'Attending', '2023-11-10 11:50:00'),
(27, 27, 'Attending', '2023-10-05 15:05:00'),
(28, 28, 'Attending', '2023-09-22 09:10:00'),
(29, 29, 'Attending', '2023-08-18 07:40:00'),
(30, 30, 'Attending', '2023-07-10 13:30:00'),

-- Cases 31-40 (2023-2022 dates)
(31, 31, 'Attending', '2023-06-03 11:00:00'),
(32, 32, 'Attending', '2023-05-22 09:25:00'),
(33, 33, 'Attending', '2023-04-14 15:50:00'),
(34, 34, 'Attending', '2023-03-05 12:20:00'),
(35, 35, 'Attending', '2023-02-25 07:10:00'),
(36, 36, 'Attending', '2023-01-10 14:30:00'),
(37, 37, 'Attending', '2022-12-18 11:55:00'),
(38, 38, 'Attending', '2022-11-07 10:15:00'),
(39, 39, 'Attending', '2022-10-03 16:45:00'),
(40, 40, 'Attending', '2022-09-20 13:40:00'),

-- Cases 41-50 (2022-2021 dates)
(41, 41, 'Attending', '2022-08-12 07:35:00'),
(42, 42, 'Attending', '2022-07-05 12:45:00'),
(43, 43, 'Attending', '2022-06-30 09:10:00'),
(44, 44, 'Attending', '2022-05-15 16:00:00'),
(45, 45, 'Attending', '2022-04-10 11:25:00'),
(46, 46, 'Attending', '2022-03-01 09:50:00'),
(47, 47, 'Attending', '2022-02-18 07:05:00'),
(48, 48, 'Attending', '2022-01-05 14:35:00'),
(49, 49, 'Attending', '2021-12-20 11:10:00'),
(50, 50, 'Attending', '2021-11-10 13:50:00');

-- DUMMY DATA FOR staff

INSERT INTO staff (name, role, phone, email)
VALUES
('Amit Sharma', 'Admin', '9000000001', 'amit.sharma@lifecare.com'),
('Neha Verma', 'Receptionist', '9000000002', 'neha.verma@lifecare.com'),
('Rohit Mehta', 'Accountant', '9000000003', 'rohit.mehta@lifecare.com'),
('Pooja Singh', 'Nurse', '9000000004', 'pooja.singh@lifecare.com'),
('Ankit Patel', 'Pharmacist', '9000000005', 'ankit.patel@lifecare.com'),

('Sunita Rao', 'Nurse', '9000000006', 'sunita.rao@lifecare.com'),
('Vikas Khanna', 'Receptionist', '9000000007', 'vikas.khanna@lifecare.com'),
('Kiran Joshi', 'Lab Technician', '9000000008', 'kiran.joshi@lifecare.com'),
('Rahul Nair', 'Pharmacist', '9000000009', 'rahul.nair@lifecare.com'),
('Meena Iyer', 'Nurse', '9000000010', 'meena.iyer@lifecare.com'),

('Suresh Kumar', 'Admin', '9000000011', 'suresh.kumar@lifecare.com'),
('Priya Malhotra', 'Receptionist', '9000000012', 'priya.malhotra@lifecare.com'),
('Arjun Das', 'Accountant', '9000000013', 'arjun.das@lifecare.com'),
('Nisha Kapoor', 'Nurse', '9000000014', 'nisha.kapoor@lifecare.com'),
('Manoj Yadav', 'Pharmacist', '9000000015', 'manoj.yadav@lifecare.com'),

('Deepa Chawla', 'Lab Technician', '9000000016', 'deepa.chawla@lifecare.com'),
('Ramesh Gupta', 'Receptionist', '9000000017', 'ramesh.gupta@lifecare.com'),
('Kavita Shah', 'Nurse', '9000000018', 'kavita.shah@lifecare.com'),
('Sanjay Mishra', 'Pharmacist', '9000000019', 'sanjay.mishra@lifecare.com'),
('Ayesha Khan', 'Lab Technician', '9000000020', 'ayesha.khan@lifecare.com'),

('Vinod Bansal', 'Admin', '9000000021', 'vinod.bansal@lifecare.com'),
('Sneha Kulkarni', 'Receptionist', '9000000022', 'sneha.kulkarni@lifecare.com'),
('Pankaj Arora', 'Accountant', '9000000023', 'pankaj.arora@lifecare.com'),
('Rekha Menon', 'Nurse', '9000000024', 'rekha.menon@lifecare.com'),
('Imran Ali', 'Pharmacist', '9000000025', 'imran.ali@lifecare.com'),

('Alok Saxena', 'Lab Technician', '9000000026', 'alok.saxena@lifecare.com'),
('Divya Reddy', 'Nurse', '9000000027', 'divya.reddy@lifecare.com'),
('Harish Pandey', 'Receptionist', '9000000028', 'harish.pandey@lifecare.com'),
('Swati Ghosh', 'Accountant', '9000000029', 'swati.ghosh@lifecare.com'),
('Naveen Shetty', 'Pharmacist', '9000000030', 'naveen.shetty@lifecare.com'),

('Preeti Jain', 'Nurse', '9000000031', 'preeti.jain@lifecare.com'),
('Ashok Rawat', 'Lab Technician', '9000000032', 'ashok.rawat@lifecare.com'),
('Komal Sinha', 'Receptionist', '9000000033', 'komal.sinha@lifecare.com'),
('Yogesh Thakur', 'Accountant', '9000000034', 'yogesh.thakur@lifecare.com'),
('Farah Ansari', 'Pharmacist', '9000000035', 'farah.ansari@lifecare.com'),

('Mukesh Solanki', 'Admin', '9000000036', 'mukesh.solanki@lifecare.com'),
('Ritu Agarwal', 'Nurse', '9000000037', 'ritu.agarwal@lifecare.com'),
('Ajay Chauhan', 'Receptionist', '9000000038', 'ajay.chauhan@lifecare.com'),
('Neelam Tiwari', 'Lab Technician', '9000000039', 'neelam.tiwari@lifecare.com'),
('Sameer Qureshi', 'Pharmacist', '9000000040', 'sameer.qureshi@lifecare.com'),

('Shilpa Deshmukh', 'Nurse', '9000000041', 'shilpa.deshmukh@lifecare.com'),
('Rajiv Malviya', 'Accountant', '9000000042', 'rajiv.malviya@lifecare.com'),
('Monika Bhat', 'Receptionist', '9000000043', 'monika.bhat@lifecare.com'),
('Anil Sood', 'Lab Technician', '9000000044', 'anil.sood@lifecare.com'),
('Tasneem Siddiqui', 'Pharmacist', '9000000045', 'tasneem.siddiqui@lifecare.com');

-- DUMMY DATA FOR users 

INSERT INTO users (username, password, role, staff_id)
VALUES
-- Admin users
('admin_amit', '$2y$10$adminpass01', 'Admin', 1),
('admin_suresh', '$2y$10$adminpass02', 'Admin', 11),
('admin_vinod', '$2y$10$adminpass03', 'Admin', 21),
('admin_mukesh', '$2y$10$adminpass04', 'Admin', 36),

-- Receptionists
('recept_neha', '$2y$10$receppass01', 'Receptionist', 2),
('recept_vikas', '$2y$10$receppass02', 'Receptionist', 7),
('recept_priya', '$2y$10$receppass03', 'Receptionist', 12),
('recept_ramesh', '$2y$10$receppass04', 'Receptionist', 17),
('recept_sneha', '$2y$10$receppass05', 'Receptionist', 22),
('recept_harish', '$2y$10$receppass06', 'Receptionist', 28),
('recept_komal', '$2y$10$receppass07', 'Receptionist', 33),
('recept_ajay', '$2y$10$receppass08', 'Receptionist', 38),
('recept_monika', '$2y$10$receppass09', 'Receptionist', 43),

-- Nurses
('nurse_pooja', '$2y$10$nursepass01', 'Nurse', 4),
('nurse_sunita', '$2y$10$nursepass02', 'Nurse', 6),
('nurse_meena', '$2y$10$nursepass03', 'Nurse', 10),
('nurse_nisha', '$2y$10$nursepass04', 'Nurse', 14),
('nurse_kavita', '$2y$10$nursepass05', 'Nurse', 18),
('nurse_rekha', '$2y$10$nursepass06', 'Nurse', 24),
('nurse_divya', '$2y$10$nursepass07', 'Nurse', 27),
('nurse_preeti', '$2y$10$nursepass08', 'Nurse', 31),
('nurse_ritu', '$2y$10$nursepass09', 'Nurse', 37),
('nurse_shilpa', '$2y$10$nursepass10', 'Nurse', 41),

-- Pharmacists
('pharma_ankit', '$2y$10$pharmapass01', 'Pharmacist', 5),
('pharma_rahul', '$2y$10$pharmapass02', 'Pharmacist', 9),
('pharma_manoj', '$2y$10$pharmapass03', 'Pharmacist', 15),
('pharma_sanjay', '$2y$10$pharmapass04', 'Pharmacist', 19),
('pharma_imran', '$2y$10$pharmapass05', 'Pharmacist', 25),
('pharma_naveen', '$2y$10$pharmapass06', 'Pharmacist', 30),
('pharma_farah', '$2y$10$pharmapass07', 'Pharmacist', 35),
('pharma_sameer', '$2y$10$pharmapass08', 'Pharmacist', 40),
('pharma_tasneem', '$2y$10$pharmapass09', 'Pharmacist', 45);

-- DUMMY DATA FOR appointment

INSERT INTO appointments (patient_id, doctor_id, appointment_date, status)
VALUES
(1, 5, '2025-01-10 10:00:00', 'complete'),
(2, 12, '2025-01-11 11:30:00', 'complete'),
(3, 18, '2025-01-12 09:15:00', 'cancelled'),
(4, 9, '2025-01-13 14:00:00', 'complete'),
(5, 20, '2025-01-14 16:30:00', 'Schedule'),
(6, 3, '2025-01-15 10:45:00', 'complete'),
(7, 7, '2025-01-16 12:00:00', 'Schedule'),
(8, 14, '2025-01-17 09:30:00', 'complete'),
(9, 22, '2025-01-18 15:00:00', 'cancelled'),
(10, 30, '2025-01-19 11:00:00', 'complete'),

(11, 8, '2025-02-01 10:30:00', 'complete'),
(12, 16, '2025-02-02 13:15:00', 'Schedule'),
(13, 25, '2025-02-03 09:00:00', 'complete'),
(14, 11, '2025-02-04 14:45:00', 'cancelled'),
(15, 35, '2025-02-05 16:00:00', 'complete'),
(16, 19, '2025-02-06 10:00:00', 'Schedule'),
(17, 4, '2025-02-07 11:30:00', 'complete'),
(18, 28, '2025-02-08 09:15:00', 'complete'),
(19, 6, '2025-02-09 15:45:00', 'cancelled'),
(20, 41, '2025-02-10 12:00:00', 'complete'),

(21, 13, '2025-03-01 10:15:00', 'complete'),
(22, 2, '2025-03-02 11:00:00', 'Schedule'),
(23, 17, '2025-03-03 14:30:00', 'complete'),
(24, 9, '2025-03-04 09:45:00', 'complete'),
(25, 26, '2025-03-05 16:00:00', 'cancelled'),
(26, 33, '2025-03-06 10:00:00', 'complete'),
(27, 48, '2025-03-07 11:30:00', 'Schedule'),
(28, 15, '2025-03-08 09:00:00', 'complete'),
(29, 39, '2025-03-09 14:15:00', 'complete'),
(30, 21, '2025-03-10 16:45:00', 'cancelled'),

(31, 6, '2025-04-01 10:00:00', 'complete'),
(32, 29, '2025-04-02 12:15:00', 'Schedule'),
(33, 14, '2025-04-03 09:30:00', 'complete'),
(34, 8, '2025-04-04 11:00:00', 'complete'),
(35, 40, '2025-04-05 15:30:00', 'cancelled'),
(36, 5, '2025-04-06 10:45:00', 'complete'),
(37, 18, '2025-04-07 13:00:00', 'Schedule'),
(38, 27, '2025-04-08 09:15:00', 'complete'),
(39, 32, '2025-04-09 14:00:00', 'complete'),
(40, 1, '2025-04-10 16:30:00', 'complete'),

(41, 12, '2025-05-01 10:00:00', 'Schedule'),
(42, 44, '2025-05-02 11:30:00', 'complete'),
(43, 20, '2025-05-03 09:00:00', 'complete'),
(44, 16, '2025-05-04 14:45:00', 'cancelled'),
(45, 37, '2025-05-05 16:00:00', 'complete'),
(46, 9, '2025-05-06 10:15:00', 'Schedule'),
(47, 28, '2025-05-07 12:30:00', 'complete'),
(48, 3, '2025-05-08 09:45:00', 'complete'),
(49, 22, '2025-05-09 15:00:00', 'cancelled'),
(50, 50, '2025-05-10 11:00:00', 'complete');

-- DUMMY DATA FOR records

INSERT INTO records (patient_id, doctor_id, visited_date, note)
VALUES
(1, 5, '2025-01-10 10:30:00', 'Patient complained of chest pain. ECG advised.'),
(2, 12, '2025-01-11 12:00:00', 'Follow-up visit. Blood pressure stable.'),
(3, 18, '2025-01-12 09:45:00', 'Minor injuries due to accident. X-ray suggested.'),
(4, 9, '2025-01-13 14:30:00', 'Routine antenatal check-up.'),
(5, 20, '2025-01-14 17:00:00', 'Patient brought in by police. Observation required.'),

(6, 3, '2025-01-15 11:15:00', 'Fever and cough for 3 days. Medication prescribed.'),
(7, 7, '2025-01-16 12:30:00', 'General health check-up.'),
(8, 14, '2025-01-17 10:00:00', 'Skin rash observed. Allergy suspected.'),
(9, 22, '2025-01-18 15:30:00', 'Severe headache. MRI advised.'),
(10, 30, '2025-01-19 11:30:00', 'Follow-up for diabetes management.'),

(11, 8, '2025-02-01 11:00:00', 'Child showing symptoms of viral fever.'),
(12, 16, '2025-02-02 13:45:00', 'Joint pain reported. Physiotherapy suggested.'),
(13, 25, '2025-02-03 09:30:00', 'Post-surgery follow-up. Healing well.'),
(14, 11, '2025-02-04 15:15:00', 'Complaints of dizziness. Blood tests ordered.'),
(15, 35, '2025-02-05 16:30:00', 'Cancer screening visit.'),

(16, 19, '2025-02-06 10:30:00', 'Abdominal pain reported. Ultrasound advised.'),
(17, 4, '2025-02-07 12:00:00', 'Emergency treatment for fracture.'),
(18, 28, '2025-02-08 09:45:00', 'Post-accident observation.'),
(19, 6, '2025-02-09 16:15:00', 'High blood sugar levels noted.'),
(20, 41, '2025-02-10 12:30:00', 'Respiratory infection suspected.'),

(21, 13, '2025-03-01 10:45:00', 'Neurological assessment performed.'),
(22, 2, '2025-03-02 11:30:00', 'Follow-up consultation.'),
(23, 17, '2025-03-03 15:00:00', 'Severe back pain reported.'),
(24, 9, '2025-03-04 10:15:00', 'Routine pregnancy monitoring.'),
(25, 26, '2025-03-05 16:30:00', 'Lab results reviewed.'),

(26, 33, '2025-03-06 10:30:00', 'Hypertension management visit.'),
(27, 48, '2025-03-07 12:00:00', 'Minor surgical procedure done.'),
(28, 15, '2025-03-08 09:30:00', 'Skin infection diagnosed.'),
(29, 39, '2025-03-09 14:45:00', 'Vision complaints. Eye tests ordered.'),
(30, 21, '2025-03-10 17:00:00', 'General weakness reported.'),

(31, 6, '2025-04-01 10:30:00', 'Follow-up for fever. Condition improving.'),
(32, 29, '2025-04-02 12:45:00', 'ENT consultation.'),
(33, 14, '2025-04-03 10:00:00', 'Allergic dermatitis observed.'),
(34, 8, '2025-04-04 11:30:00', 'Routine pediatric check-up.'),
(35, 40, '2025-04-05 16:00:00', 'Chronic pain management discussion.'),

(36, 5, '2025-04-06 11:15:00', 'Cardiac follow-up visit.'),
(37, 18, '2025-04-07 13:30:00', 'Post-operative recovery review.'),
(38, 27, '2025-04-08 09:45:00', 'Minor injury dressing done.'),
(39, 32, '2025-04-09 14:30:00', 'Migraine symptoms discussed.'),
(40, 1, '2025-04-10 17:00:00', 'General consultation.'),

-- continuing pattern up to 120 records
(41, 12, '2025-05-01 10:30:00', 'Blood pressure follow-up.'),
(42, 44, '2025-05-02 12:00:00', 'Lab test results reviewed.'),
(43, 20, '2025-05-03 09:30:00', 'Chest infection suspected.'),
(44, 16, '2025-05-04 15:15:00', 'Joint mobility assessment.'),
(45, 37, '2025-05-05 16:30:00', 'Routine cancer therapy visit.'),

(46, 9, '2025-05-06 10:45:00', 'Prenatal consultation.'),
(47, 28, '2025-05-07 12:30:00', 'Post-accident review.'),
(48, 3, '2025-05-08 10:00:00', 'Respiratory symptoms improving.'),
(49, 22, '2025-05-09 15:30:00', 'Neurological follow-up.'),
(50, 50, '2025-05-10 11:30:00', 'Routine health screening.');

-- DUMMY DATA FOR diagnosis

INSERT INTO diagnoses (diagnoses, record_id)
VALUES
('Hypertension', 1),
('Chest Pain - Suspected Angina', 1),

('Essential Hypertension', 2),
('Migraine', 3),
('Minor Head Injury', 3),

('Normal Pregnancy', 4),
('High-Risk Pregnancy', 4),

('Medico-Legal Observation', 5),

('Acute Viral Fever', 6),
('Upper Respiratory Infection', 6),

('Routine Health Check', 7),

('Allergic Dermatitis', 8),
('Skin Infection', 8),

('Severe Migraine', 9),
('Rule Out Brain Tumor', 9),

('Type 2 Diabetes Mellitus', 10),

('Viral Fever', 11),
('Dehydration', 11),

('Osteoarthritis', 12),
('Joint Inflammation', 12),

('Post-Surgical Recovery', 13),

('Vertigo', 14),
('Low Blood Pressure', 14),

('Suspected Malignancy', 15),

('Abdominal Pain', 16),
('Gallstones', 16),

('Bone Fracture', 17),
('Soft Tissue Injury', 17),

('Post-Trauma Observation', 18),

('Hyperglycemia', 19),
('Diabetes Mellitus', 19),

('Acute Bronchitis', 20),

('Neurological Disorder', 21),
('Peripheral Neuropathy', 21),

('General Follow-up', 22),

('Lower Back Pain', 23),
('Muscle Strain', 23),

('Normal Pregnancy Progress', 24),

('Abnormal Lab Results', 25),

('Chronic Hypertension', 26),

('Post-Surgical Care', 27),

('Bacterial Skin Infection', 28),

('Vision Impairment', 29),
('Refractive Error', 29),

('General Weakness', 30),

('Fever - Improving', 31),

('ENT Infection', 32),

('Allergic Reaction', 33),

('Routine Pediatric Examination', 34),

('Chronic Pain Syndrome', 35),

('Cardiac Arrhythmia', 36),

('Post-Operative Recovery', 37),

('Minor Laceration', 38),

('Chronic Migraine', 39),

('General Health Consultation', 40),

('Hypertension Follow-up', 41),

('Laboratory Abnormality', 42),

('Chest Infection', 43),
('Pneumonia', 43),

('Joint Stiffness', 44),

('Cancer Therapy Follow-up', 45),

('Prenatal Check-up', 46),

('Post-Accident Review', 47),

('Improving Respiratory Infection', 48),

('Neurological Follow-up', 49),

('Routine Medical Screening', 50);

-- DUMMY DATA FOR prescription

INSERT INTO prescription (record_id, prescription_date)
VALUES
(1, '2025-01-10 11:00:00'),
(2, '2025-01-11 12:30:00'),
(3, '2025-01-12 10:15:00'),
(4, '2025-01-13 15:00:00'),
(5, '2025-01-14 17:30:00'),

(6, '2025-01-15 11:45:00'),
(7, '2025-01-16 13:00:00'),
(8, '2025-01-17 10:30:00'),
(9, '2025-01-18 16:00:00'),
(10, '2025-01-19 12:00:00'),

(11, '2025-02-01 11:30:00'),
(12, '2025-02-02 14:15:00'),
(13, '2025-02-03 10:00:00'),
(14, '2025-02-04 15:45:00'),
(15, '2025-02-05 17:00:00'),

(16, '2025-02-06 11:00:00'),
(17, '2025-02-07 12:30:00'),
(18, '2025-02-08 10:15:00'),
(19, '2025-02-09 16:45:00'),
(20, '2025-02-10 13:00:00'),

(21, '2025-03-01 11:15:00'),
(22, '2025-03-02 12:00:00'),
(23, '2025-03-03 15:30:00'),
(24, '2025-03-04 10:45:00'),
(25, '2025-03-05 17:00:00'),

(26, '2025-03-06 11:00:00'),
(27, '2025-03-07 12:30:00'),
(28, '2025-03-08 10:00:00'),
(29, '2025-03-09 15:15:00'),
(30, '2025-03-10 17:30:00'),

(31, '2025-04-01 11:00:00'),
(32, '2025-04-02 13:15:00'),
(33, '2025-04-03 10:30:00'),
(34, '2025-04-04 12:00:00'),
(35, '2025-04-05 16:30:00'),

(36, '2025-04-06 11:45:00'),
(37, '2025-04-07 14:00:00'),
(38, '2025-04-08 10:15:00'),
(39, '2025-04-09 15:00:00'),
(40, '2025-04-10 17:30:00'),

(41, '2025-05-01 11:00:00'),
(42, '2025-05-02 12:30:00'),
(43, '2025-05-03 10:00:00'),
(44, '2025-05-04 15:45:00'),
(45, '2025-05-05 17:00:00'),

(46, '2025-05-06 11:15:00'),
(47, '2025-05-07 13:00:00'),
(48, '2025-05-08 10:30:00'),
(49, '2025-05-09 16:00:00'),
(50, '2025-05-10 12:00:00');

-- DUMMY DATA FOR medicine

INSERT INTO medicines (medicine_name, formula, price)
VALUES
('Paracetamol', 'Acetaminophen 500mg', 12.50),
('Ibuprofen', 'Ibuprofen 400mg', 18.00),
('Amoxicillin', 'Amoxicillin 500mg', 45.00),
('Azithromycin', 'Azithromycin 500mg', 120.00),
('Ciprofloxacin', 'Ciprofloxacin 500mg', 85.00),

('Metformin', 'Metformin Hydrochloride 500mg', 30.00),
('Amlodipine', 'Amlodipine 5mg', 25.00),
('Losartan', 'Losartan Potassium 50mg', 28.00),
('Atorvastatin', 'Atorvastatin 10mg', 32.00),
('Aspirin', 'Acetylsalicylic Acid 75mg', 15.00),

('Pantoprazole', 'Pantoprazole 40mg', 22.00),
('Omeprazole', 'Omeprazole 20mg', 20.00),
('Ranitidine', 'Ranitidine 150mg', 18.00),
('Cetirizine', 'Cetirizine Hydrochloride 10mg', 10.00),
('Loratadine', 'Loratadine 10mg', 12.00),

('Dextromethorphan', 'Dextromethorphan 10mg', 14.00),
('Salbutamol', 'Salbutamol 4mg', 16.00),
('Montelukast', 'Montelukast 10mg', 28.00),
('Prednisolone', 'Prednisolone 5mg', 35.00),
('Hydrocortisone', 'Hydrocortisone 10mg', 40.00),

('Insulin', 'Human Insulin 100IU/ml', 250.00),
('Glimepiride', 'Glimepiride 2mg', 22.00),
('Glibenclamide', 'Glibenclamide 5mg', 20.00),
('Levothyroxine', 'Levothyroxine 50mcg', 18.00),
('Vitamin D3', 'Cholecalciferol 60000IU', 55.00),

('Calcium Carbonate', 'Calcium Carbonate 500mg', 15.00),
('Iron Folic Acid', 'Ferrous Sulfate + Folic Acid', 12.00),
('Multivitamin', 'Mixed Vitamins & Minerals', 35.00),
('Ondansetron', 'Ondansetron 4mg', 20.00),
('Domperidone', 'Domperidone 10mg', 18.00),

('Diclofenac', 'Diclofenac Sodium 50mg', 22.00),
('Tramadol', 'Tramadol Hydrochloride 50mg', 40.00),
('Morphine', 'Morphine Sulfate 10mg', 150.00),
('Midazolam', 'Midazolam 5mg', 110.00),
('Diazepam', 'Diazepam 5mg', 25.00),

('Ceftriaxone', 'Ceftriaxone 1g Injection', 180.00),
('Meropenem', 'Meropenem 1g Injection', 950.00),
('Vancomycin', 'Vancomycin 500mg Injection', 600.00),
('Heparin', 'Heparin Sodium 5000IU', 120.00),
('Enoxaparin', 'Enoxaparin 40mg Injection', 350.00),

('Furosemide', 'Furosemide 40mg', 15.00),
('Spironolactone', 'Spironolactone 25mg', 18.00),
('Metoprolol', 'Metoprolol Tartrate 50mg', 20.00),
('Propranolol', 'Propranolol 40mg', 16.00),
('Clopidogrel', 'Clopidogrel 75mg', 45.00);

-- DUMMY DATA FOR alternative medicine

INSERT INTO alternative_medicines (alt_medicine_name, formula, medicine_id, price)
VALUES
('Calpol', 'Acetaminophen 500mg', 1, 10.00),
('Brufen', 'Ibuprofen 400mg', 2, 16.00),
('Mox', 'Amoxicillin 500mg', 3, 42.00),
('Azee', 'Azithromycin 500mg', 4, 115.00),
('Cifran', 'Ciprofloxacin 500mg', 5, 80.00),

('Glycomet', 'Metformin Hydrochloride 500mg', 6, 28.00),
('Norvasc', 'Amlodipine 5mg', 7, 24.00),
('Losar', 'Losartan Potassium 50mg', 8, 26.00),
('Lipitor', 'Atorvastatin 10mg', 9, 30.00),
('Ecosprin', 'Acetylsalicylic Acid 75mg', 10, 14.00),

('Pan 40', 'Pantoprazole 40mg', 11, 20.00),
('Omez', 'Omeprazole 20mg', 12, 18.00),
('Zyrtec', 'Cetirizine Hydrochloride 10mg', 14, 9.00), -- Linked to ID 14
('Montair', 'Montelukast 10mg', 18, 26.00),
('Wysolone', 'Prednisolone 5mg', 19, 32.00),

('Human Actrapid', 'Human Insulin 100IU/ml', 21, 240.00),
('Amaryl', 'Glimepiride 2mg', 22, 20.00),
('Thyronorm', 'Levothyroxine 50mcg', 24, 16.00),
('Uprise D3', 'Cholecalciferol 60000IU', 25, 50.00),
('Shelcal', 'Calcium Carbonate 500mg', 26, 14.00),

('Zofran', 'Ondansetron 4mg', 29, 18.00),
('Voveran', 'Diclofenac Sodium 50mg', 31, 20.00),
('Ultram', 'Tramadol Hydrochloride 50mg', 32, 38.00),
('Monocef', 'Ceftriaxone 1g Injection', 36, 175.00), 
('Meronem', 'Meropenem 1g Injection', 37, 920.00),   

('Lasix', 'Furosemide 40mg', 41, 14.00),        
('Aldactone', 'Spironolactone 25mg', 42, 16.00),   
('Betaloc', 'Metoprolol Tartrate 50mg', 43, 18.00), 
('Inderal', 'Propranolol 40mg', 44, 15.00),        
('Plavix', 'Clopidogrel 75mg', 45, 42.00);          

-- DUMMY DATA FOR prescription items

INSERT INTO prescription_items (prescription_id, medicine_id, lab_test, dosage, duration)
VALUES
(1, 1, NULL, '500mg twice daily', '5 days'),
(1, 11, 'ECG', '40mg once daily', '7 days'),
(2, 7, NULL, '5mg once daily', '30 days'),
(2, 9, 'Lipid Profile', '10mg once daily', '30 days'),
(3, 31, 'X-Ray Chest', '50mg twice daily', '5 days'),
(3, 29, NULL, '4mg once daily', '3 days'),
(4, 25, 'Ultrasound', '60000IU once weekly', '8 weeks'),
(5, 20, 'Blood Test', '10mg once daily', '7 days'),
(6, 1, NULL, '500mg thrice daily', '5 days'),
(6, 16, NULL, '10ml twice daily', '5 days'),
(7, 28, NULL, '1 tablet daily', '10 days'),
(8, 14, NULL, '10mg once daily', '7 days'),
(8, 33, NULL, '50mg twice daily', '5 days'),
(9, 39, 'MRI Brain', '1g injection daily', '3 days'),
(10, 6, NULL, '500mg twice daily', '30 days'),
(10, 22, NULL, '2mg once daily', '30 days'),
(11, 1, NULL, '500mg twice daily', '5 days'),
(12, 12, NULL, '20mg once daily', '14 days'),
(12, 29, 'Blood Test', '4mg once daily', '5 days'),
(13, 38, NULL, '1g injection daily', '5 days'),
(14, 9, 'BP Monitoring', '10mg once daily', '30 days'),
(15, 40, 'Biopsy', '500mg injection daily', '7 days'),
(16, 11, NULL, '40mg once daily', '10 days'),
(17, 32, NULL, '50mg twice daily', '5 days'),
(17, 31, NULL, '50mg twice daily', '5 days'),
(18, 29, NULL, '4mg once daily', '3 days'),
(19, 21, 'Blood Sugar Test', '10 units before meals', '30 days'),
(20, 17, NULL, '4mg twice daily', '7 days'),

-- FIXED: Changed medicine_id 48 to 43 (Metoprolol) to stay within range 1-45
(21, 43, NULL, '50mg once daily', '30 days'), 

(22, 1, NULL, '500mg twice daily', '3 days'),
(23, 31, 'MRI Spine', '50mg twice daily', '5 days'),
(24, 25, NULL, '60000IU weekly', '6 weeks'),
(25, 28, 'Lab Test', '1 tablet daily', '7 days'),
(26, 7, NULL, '5mg once daily', '30 days'),
(27, 38, NULL, '1g injection daily', '5 days'),
(28, 14, NULL, '10mg once daily', '7 days'),
(29, 39, 'Eye Test', '1g injection daily', '3 days'),
(30, 6, NULL, '500mg twice daily', '30 days'),
(31, 1, NULL, '500mg twice daily', '5 days'),
(32, 12, NULL, '20mg once daily', '10 days'),
(33, 33, NULL, '50mg twice daily', '5 days'),
(34, 28, NULL, '1 tablet daily', '10 days'),
(35, 40, NULL, '500mg injection daily', '7 days'),
(36, 7, NULL, '5mg once daily', '30 days'),
(37, 38, NULL, '1g injection daily', '5 days'),
(38, 31, NULL, '50mg twice daily', '5 days'),
(39, 9, NULL, '10mg once daily', '30 days'),
(40, 1, NULL, '500mg twice daily', '3 days'),
(41, 11, NULL, '40mg once daily', '7 days'),
(42, 29, 'Blood Test', '4mg once daily', '5 days'),
(43, 17, NULL, '4mg twice daily', '7 days'),
(44, 33, NULL, '50mg twice daily', '5 days'),
(45, 25, 'Cancer Marker Test', '60000IU weekly', '8 weeks'),
(46, 11, NULL, '40mg once daily', '10 days'),
(47, 32, NULL, '50mg twice daily', '5 days'),
(48, 14, NULL, '10mg once daily', '7 days'),
(49, 39, 'MRI Brain', '1g injection daily', '3 days'),
(50, 6, NULL, '500mg twice daily', '30 days');

-- DUMMY DATA FOR lab test 

INSERT INTO lab_tests (test_name, cost, prescription_item_id)
VALUES
('ECG', 500.00, 1),
('Lipid Profile', 1200.00, 2),
('Chest X-Ray', 800.00, 3),
('Blood Sugar Test', 300.00, 4),
('Ultrasound Abdomen', 1500.00, 5),

('Complete Blood Count', 400.00, 6),
('Thyroid Function Test', 900.00, 7),
('Urine Routine Test', 250.00, 8),
('MRI Brain', 5500.00, 9),
('HbA1c Test', 700.00, 10),

('Liver Function Test', 850.00, 11),
('Kidney Function Test', 850.00, 12),
('Vitamin D Test', 1800.00, 13),
('X-Ray Spine', 900.00, 14),
('Cancer Marker Test', 2500.00, 15),

('Blood Culture', 2000.00, 16),
('CT Scan Head', 6000.00, 17),
('Electrolyte Panel', 750.00, 18),
('Pregnancy Test', 350.00, 19),
('Pulmonary Function Test', 2200.00, 20),

('Echo Cardiography', 2800.00, 21),
('Doppler Scan', 3200.00, 22),
('Allergy Test', 1600.00, 23),
('Rheumatoid Factor Test', 900.00, 24),
('Eye Vision Test', 300.00, 25),

('Hepatitis B Test', 1100.00, 26),
('Hepatitis C Test', 1200.00, 27),
('COVID-19 RT-PCR', 2500.00, 28),
('Stool Routine Test', 400.00, 29),
('Sputum AFB Test', 700.00, 30),

('Bone Density Test', 2000.00, 31),
('Hormonal Assay', 1800.00, 32),
('Serum Calcium Test', 500.00, 33),
('Serum Iron Test', 650.00, 34),
('Prostate Specific Antigen', 1400.00, 35),

('Blood Urea Test', 300.00, 36),
('Creatinine Test', 350.00, 37),
('Electroencephalogram', 2600.00, 38),
('Stress Test TMT', 3000.00, 39),
('Biopsy Histopathology', 4500.00, 40);

-- DUMMY DATA FOR test results

INSERT INTO test_results (record_id, test_id, result, test_date)
VALUES
(1, 1, 'Normal ECG, no abnormalities detected', '2025-01-10'),
(2, 2, 'Cholesterol slightly elevated, LDL 140 mg/dL', '2025-01-11'),
(3, 3, 'Chest X-Ray normal, no fractures', '2025-01-12'),
(4, 4, 'Fasting blood sugar 95 mg/dL', '2025-01-13'),
(5, 5, 'Ultrasound: normal abdominal organs', '2025-01-14'),

(6, 6, 'CBC normal, WBC 6,500/mm3', '2025-01-15'),
(7, 7, 'TSH normal at 2.1 μIU/mL', '2025-01-16'),
(8, 8, 'Urine routine: no infection detected', '2025-01-17'),
(9, 9, 'MRI Brain: no abnormal findings', '2025-01-18'),
(10, 10, 'HbA1c 6.2%, pre-diabetic range', '2025-01-19'),

(11, 11, 'Liver function normal, ALT 25 U/L', '2025-02-01'),
(12, 12, 'Kidney function normal, Creatinine 0.9 mg/dL', '2025-02-02'),
(13, 13, 'Vitamin D deficiency, 18 ng/mL', '2025-02-03'),
(14, 14, 'X-Ray Spine normal, no abnormalities', '2025-02-04'),
(15, 15, 'CA-125 slightly elevated', '2025-02-05'),

(16, 16, 'Blood culture negative', '2025-02-06'),
(17, 17, 'CT Scan normal, no lesions detected', '2025-02-07'),
(18, 18, 'Electrolytes normal', '2025-02-08'),
(19, 19, 'Pregnancy test positive', '2025-02-09'),
(20, 20, 'Pulmonary function within normal limits', '2025-02-10'),

(21, 21, 'Echocardiography: ejection fraction 60%', '2025-03-01'),
(22, 22, 'Doppler scan: normal blood flow', '2025-03-02'),
(23, 23, 'Allergy test: positive to pollen', '2025-03-03'),
(24, 24, 'Rheumatoid factor negative', '2025-03-04'),
(25, 25, 'Eye vision 20/20 both eyes', '2025-03-05'),

(26, 26, 'Hepatitis B surface antigen negative', '2025-03-06'),
(27, 27, 'Hepatitis C antibody negative', '2025-03-07'),
(28, 28, 'COVID-19 RT-PCR negative', '2025-03-08'),
(29, 29, 'Stool routine normal', '2025-03-09'),
(30, 30, 'Sputum AFB negative', '2025-03-10'),

(31, 31, 'Bone density normal, T-score -0.5', '2025-04-01'),
(32, 32, 'Hormonal assay normal', '2025-04-02'),
(33, 33, 'Serum calcium normal, 9.5 mg/dL', '2025-04-03'),
(34, 34, 'Serum iron low, 50 μg/dL', '2025-04-04'),
(35, 35, 'PSA normal, 2.3 ng/mL', '2025-04-05'),

(36, 36, 'Blood urea normal, 25 mg/dL', '2025-04-06'),
(37, 37, 'Creatinine normal, 0.8 mg/dL', '2025-04-07'),
(38, 38, 'EEG normal', '2025-04-08'),
(39, 39, 'Stress test normal', '2025-04-09'),
(40, 40, 'Biopsy: benign tissue', '2025-04-10');

-- DUMMY DATA FOR billing 

INSERT INTO billing (patient_id, bill_date, total_amount)
VALUES
(1, '2025-01-20', 3500.00),
(2, '2025-01-21', 4200.00),
(3, '2025-01-22', 1800.00),
(4, '2025-01-23', 2500.00),
(5, '2025-01-24', 6000.00),

(6, '2025-01-25', 3200.00),
(7, '2025-01-26', 1500.00),
(8, '2025-01-27', 2200.00),
(9, '2025-01-28', 4800.00),
(10, '2025-01-29', 3000.00),

(11, '2025-02-05', 2700.00),
(12, '2025-02-06', 3500.00),
(13, '2025-02-07', 4100.00),
(14, '2025-02-08', 5000.00),
(15, '2025-02-09', 6200.00),

(16, '2025-02-10', 3800.00),
(17, '2025-02-11', 2900.00),
(18, '2025-02-12', 3100.00),
(19, '2025-02-13', 4500.00),
(20, '2025-02-14', 2700.00),

(21, '2025-03-01', 5400.00),
(22, '2025-03-02', 3300.00),
(23, '2025-03-03', 4200.00),
(24, '2025-03-04', 3800.00),
(25, '2025-03-05', 6100.00),

(26, '2025-03-06', 2700.00),
(27, '2025-03-07', 2900.00),
(28, '2025-03-08', 3600.00),
(29, '2025-03-09', 4800.00),
(30, '2025-03-10', 5000.00),

(31, '2025-04-01', 2200.00),
(32, '2025-04-02', 3500.00),
(33, '2025-04-03', 4100.00),
(34, '2025-04-04', 2700.00),
(35, '2025-04-05', 5800.00),

(36, '2025-04-06', 3000.00),
(37, '2025-04-07', 3200.00),
(38, '2025-04-08', 4300.00),
(39, '2025-04-09', 3800.00),
(40, '2025-04-10', 5100.00),

(41, '2025-05-01', 2500.00),
(42, '2025-05-02', 3600.00),
(43, '2025-05-03', 4000.00),
(44, '2025-05-04', 2900.00),
(45, '2025-05-05', 6200.00),

(46, '2025-05-06', 2700.00),
(47, '2025-05-07', 3100.00),
(48, '2025-05-08', 4500.00),
(49, '2025-05-09', 4800.00),
(50, '2025-05-10', 5200.00);

-- DUMMY DATA FOR invoice items 

INSERT INTO invoice_items (bill_id, description, amount)
VALUES
(1, 'Doctor Consultation Fee', 500.00),
(1, 'ECG Test', 500.00),
(1, 'Medicines', 2500.00),

(2, 'Doctor Consultation Fee', 400.00),
(2, 'Lipid Profile Test', 1200.00),
(2, 'Medicines', 2600.00),

(3, 'Doctor Consultation Fee', 400.00),
(3, 'Chest X-Ray', 800.00),
(3, 'Medicines', 600.00),

(4, 'Doctor Consultation Fee', 500.00),
(4, 'Blood Sugar Test', 300.00),
(4, 'Medicines', 1700.00),

(5, 'Doctor Consultation Fee', 600.00),
(5, 'Ultrasound Abdomen', 1500.00),
(5, 'Medicines', 3900.00),

(6, 'Doctor Consultation Fee', 400.00),
(6, 'CBC Test', 400.00),
(6, 'Medicines', 2400.00),

(7, 'Doctor Consultation Fee', 450.00),
(7, 'Thyroid Function Test', 900.00),
(7, 'Medicines', 1600.00),

(8, 'Doctor Consultation Fee', 500.00),
(8, 'Urine Routine Test', 250.00),
(8, 'Medicines', 1450.00),

(9, 'Doctor Consultation Fee', 600.00),
(9, 'MRI Brain', 5500.00),
(9, 'Medicines', 700.00),

(10, 'Doctor Consultation Fee', 400.00),
(10, 'HbA1c Test', 700.00),
(10, 'Medicines', 1900.00),

-- continuing same pattern
(11, 'Doctor Consultation Fee', 500.00),
(11, 'Liver Function Test', 850.00),
(11, 'Medicines', 1350.00),

(12, 'Doctor Consultation Fee', 400.00),
(12, 'Kidney Function Test', 850.00),
(12, 'Medicines', 2250.00),

(13, 'Doctor Consultation Fee', 500.00),
(13, 'Vitamin D Test', 1800.00),
(13, 'Medicines', 1800.00),

(14, 'Doctor Consultation Fee', 400.00),
(14, 'X-Ray Spine', 900.00),
(14, 'Medicines', 1700.00),

(15, 'Doctor Consultation Fee', 600.00),
(15, 'Cancer Marker Test', 2500.00),
(15, 'Medicines', 3100.00),

(16, 'Doctor Consultation Fee', 500.00),
(16, 'Blood Culture', 2000.00),
(16, 'Medicines', 1300.00),

(17, 'Doctor Consultation Fee', 450.00),
(17, 'CT Scan Head', 6000.00),
(17, 'Medicines', 1200.00),

(18, 'Doctor Consultation Fee', 400.00),
(18, 'Electrolyte Panel', 750.00),
(18, 'Medicines', 1650.00),

(19, 'Doctor Consultation Fee', 400.00),
(19, 'Pregnancy Test', 350.00),
(19, 'Medicines', 1950.00),

(20, 'Doctor Consultation Fee', 500.00),
(20, 'Pulmonary Function Test', 2200.00),
(20, 'Medicines', 0.00);

-- DUMMY DATA FOR payment

INSERT INTO payments (bill_id, payment_date, payment_method, amount)
VALUES
(1, '2025-01-21', 'Cash', 3500.00),
(2, '2025-01-23', 'Card', 4200.00),
(3, '2025-01-23', 'UPI', 1800.00),
(4, '2025-01-25', 'Insurance', 2500.00),
(5, '2025-01-26', 'Cash', 6000.00),
(6, '2025-01-28', 'Card', 3200.00),
(7, '2025-01-29', 'UPI', 1500.00),
(8, '2025-01-30', 'Cash', 2200.00),
(9, '2025-02-01', 'Insurance', 4800.00),
(10, '2025-02-02', 'Card', 3000.00),

(11, '2025-02-07', 'UPI', 2700.00),
(12, '2025-02-09', 'Cash', 3500.00),
(13, '2025-02-10', 'Card', 4100.00),
(14, '2025-02-12', 'Insurance', 5000.00),
(15, '2025-02-14', 'UPI', 6200.00),
(16, '2025-02-16', 'Cash', 3800.00),
(17, '2025-02-17', 'Card', 2900.00),
(18, '2025-02-18', 'UPI', 3100.00),
(19, '2025-02-19', 'Insurance', 4500.00),
(20, '2025-02-20', 'Cash', 2700.00),

(21, '2025-03-02', 'Card', 5400.00),
(22, '2025-03-04', 'UPI', 3300.00),
(23, '2025-03-05', 'Cash', 4200.00),
(24, '2025-03-06', 'Card', 3800.00),
(25, '2025-03-07', 'Insurance', 6100.00),
(26, '2025-03-09', 'UPI', 2700.00),
(27, '2025-03-10', 'Cash', 2900.00),
(28, '2025-03-11', 'Card', 3600.00),
(29, '2025-03-12', 'UPI', 4800.00),
(30, '2025-03-13', 'Insurance', 5000.00),

(31, '2025-04-02', 'Cash', 2200.00),
(32, '2025-04-03', 'Card', 3500.00),
(33, '2025-04-04', 'UPI', 4100.00),
(34, '2025-04-05', 'Insurance', 2700.00),
(35, '2025-04-06', 'Cash', 5800.00),
(36, '2025-04-07', 'Card', 3000.00),
(37, '2025-04-08', 'UPI', 3200.00),
(38, '2025-04-09', 'Cash', 4300.00),
(39, '2025-04-10', 'Insurance', 3800.00),
(40, '2025-04-11', 'Card', 5100.00),

(41, '2025-05-02', 'UPI', 2500.00),
(42, '2025-05-03', 'Cash', 3600.00),
(43, '2025-05-04', 'Card', 4000.00),
(44, '2025-05-05', 'Insurance', 2900.00),
(45, '2025-05-06', 'UPI', 6200.00),
(46, '2025-05-07', 'Cash', 2700.00),
(47, '2025-05-08', 'Card', 3100.00),
(48, '2025-05-09', 'UPI', 4500.00),
(49, '2025-05-10', 'Insurance', 4800.00),
(50, '2025-05-11', 'Cash', 5200.00);


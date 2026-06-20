
-- 1.	Display all patients from the patient table.

SELECT * FROM patients;

-- 2.	Show patient name, gender, and date of birth.

SELECT first_name , last_name , gender, date_of_birth
FROM patients ; 

-- 3.	List all doctors with their department IDs.

SELECT first_name , last_name , department_id 
FROM doctors ;

-- 4.	Display all appointments with status = 'Scheduled'.

SELECT * FROM appointments 
WHERE status = 'Schedule';

-- 5.	Show all bills where total amount is greater than 5000.

SELECT * FROM billing 
WHERE total_amount > 5000;

-- 6.	Find patients whose name ends with 'Kumar'.

SELECT * FROM patients 
WHERE last_name = 'Kumar';

-- 7.	Count total number of doctors in the hospital.

SELECT COUNT(doctor_id) FROM doctors ;

-- 8.	Show departments ordered by department name.

SELECT department_name FROM departments 
ORDER BY department_name;

-- 9.	Display all admitted patients.

SELECT CONCAT(first_name ,' ', last_name) AS admitted 
FROM patients ;

-- 10.	Insert a new department called “Physiotherapy”.

START TRANSACTION ;
INSERT into departments (department_id , department_name , description)
   VALUES (11,'Physiotherapy','can work on legs');
ROLLBACK;

-- 11.	Insert a new patient record with valid details.

-- 12.	Update the contact number of a patient using patient_id.

START TRANSACTION ;
UPDATE patients
SET phone = '1234689'
WHERE patient_id = 1;
ROLLBACK;

-- 13.	Increase all doctor salaries by 5%.

START TRANSACTION ;
UPDATE invoice_items
SET amount = amount + (amount * 0.05)
WHERE description like '%Doctor%';
ROLLBACK;

-- 14.	Delete an appointment that is marked as 'Cancelled'.

START TRANSACTION ;
DELETE FROM appointments 
WHERE appointment_id = 3 AND status = 'cancelled';
ROLLBACK;

-- 15.	Delete patients who were never admitted (use a simple condition).

-- idk get what this one is asking i don't even know where the admit thing is bcz 
-- it's not mention in any of them 

-- 1.	Display patient names along with their doctor names.

SELECT CONCAT(p.first_name,' ',p.last_name) AS patients_name ,
		CONCAT(d.first_name,' ',d.last_name) AS doctors_name
FROM patients p
JOIN records r 
ON p.patient_id = r.patient_id
JOIN doctors d 
ON d.doctor_id = r.doctor_id ;

-- 2.	Show doctor names and their department names using JOINs.

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctors_name ,
		department_name
FROM doctors d 
LEFT JOIN departments de
ON d.department_id = de.department_id ;

-- 3.	Find total number of appointments handled by each doctor.

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctors_name ,
		COUNT(appointment_id)
FROM doctors d 
LEFT JOIN appointments a
ON d.doctor_id = a.doctor_id 
GROUP BY doctors_name ;

-- 4.	Display departments having more than 2 doctors.

SELECT COUNT(CONCAT(d.first_name,' ',d.last_name)) AS total_doctors ,
		department_name
FROM doctors d 
LEFT JOIN departments de
ON d.department_id = de.department_id 
GROUP BY department_name ;

-- 5.	Find patients whose bill amount is higher than the average bill amount (subquery).

SELECT p.patient_id,
		CONCAT(p.first_name,' ',p.last_name) AS patients_name ,
        total_amount
FROM patients p 
JOIN billing b 
ON p.patient_id = b.patient_id 
WHERE total_amount > (SELECT AVG(total_amount) FROM billing);

-- 6.	Display doctors who belong to the department 'Cardiology' (subquery).

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctors_name 
FROM doctors d
WHERE department_id IN (SELECT department_id FROM departments
						WHERE department_name = 'Cardiology');

-- 7.	Update bill amount by adding 10% tax to all bills.

START TRANSACTION ;
UPDATE billing 
SET total_amount = total_amount + (total_amount *0.10);
ROLLBACK;

-- 8.	Delete bills where total amount is less than 1000.

START TRANSACTION ;
DELETE FROM billing 
WHERE total_amount > 1000 ;
ROLLBACK;

-- 9.	Find doctors who have no appointments (LEFT JOIN).

SELECT CONCAT(d.first_name,' ',d.last_name) AS doctors_name 
FROM doctors d 
LEFT JOIN appointments a 
ON d.doctor_id = a.doctor_id 
WHERE appointment_id IS NULL ;

-- 10.	Show patients who never had any appointments (subquery).

SELECT  CONCAT(first_name,' ',last_name) AS patient_name , patient_id
FROM patients 
WHERE patient_id NOT IN (SELECT patient_id FROM appointments);

-- 11.	Insert a new appointment for an existing patient and doctor.

START TRANSACTION ;
INSERT INTO appointments(patient_id , doctor_id ,appointment_date,status)
 VALUES 
(1,9,'2025-01-10 10:00:00','Schedule');
ROLLBACK;

-- 12.	Display total revenue generated per department.

-- there isn't any table which rep the dep revenue or link table like that
-- only invoice have them but it has test etc amount

-- 13.	Update appointment status to 'Completed' where appointment date < today.

START TRANSACTION ;
UPDATE appointments 
SET appointment_date = CURRENT_TIMESTAMP()
WHERE status = 'Complete';
ROLLBACK;

-- 14.	Find the department with the highest number of patients.

SELECT department_name ,
		COUNT(CONCAT(p.first_name,' ',p.last_name)) AS total_patient 		
FROM patients p 
LEFT JOIN records r ON p.patient_id = r.patient_id
LEFT JOIN doctors d ON r.doctor_id = d.doctor_id 
JOIN departments de ON d.department_id = de.department_id 
GROUP BY department_name 
ORDER BY total_patient DESC 
LIMIT 1 ;

-- 15.	Delete duplicate appointments (same patient, same doctor, same date).

START TRANSACTION ;
DELETE a1 
FROM appointments a1 
join appointments a2
on a1.patient_id = a2.patient_id 
AND a1.doctor_id = a2.doctor_id 
AND a1.appointment_date = a2.appointment_date 
AND a1.appointment_id > a2.appointment_id ;
ROLLBACK;

USE lifecare_hospital;

SELECT department_name , SUM(total_amount) AS dep_total
FROM departments dep 
JOIN doctors doc 
ON dep.department_id = doc.department_id 
JOIN records rec 
ON doc.doctor_id = rec.doctor_id 
JOIN patients pat 
ON rec.patient_id = pat.patient_id
JOIN billing bill 
ON pat.patient_id = bill.patient_id 
GROUP BY department_name ;

SELECT CONCAT(first_name,' ',last_name) AS full_name , 
CASE 
	WHEN YEAR(date_of_birth) < 1980 THEN "Senior Citizen"
    WHEN YEAR(date_of_birth)BETWEEN 1980 AND 1990 THEN "Adult"
    WHEN YEAR(date_of_birth) > 1990 THEN "Child"
 END AS patient_category
 FROM patients ;
 
 START TRANSACTION ;
 DELETE FROM appointments 
 WHERE status = "cancelled" AND DATE(appointment_date) < 2025-01-01 ;
ROLLBACK;

SELECT day_of_week , case_type ,COUNT(case_type) 
FROM doctor_availability da 
JOIN doctors doc 
ON da.doctor_id = doc.doctor_id 
JOIN records rec 
ON doc.doctor_id = rec.doctor_id 
JOIN patients pat 
ON rec.patient_id = pat.patient_id 
JOIN cases c 
ON pat.patient_id = c.patient_id 
GROUP BY day_of_week , case_type 
HAVING case_type = "Emergency";

SELECT CONCAT(doc.first_name,' ',doc.last_name) AS full_name , 
ii.description , SUM(total_amount) AS doc_total
FROM doctors doc 
JOIN records rec 
ON doc.doctor_id = rec.doctor_id 
JOIN patients pat 
ON rec.patient_id = pat.patient_id
JOIN billing bill 
ON pat.patient_id = bill.patient_id 
JOIN invoice_items ii 
ON bill.bill_id = ii.bill_id
WHERE ii.description LIKE "%doc%"
GROUP BY full_name , ii.description 
ORDER BY doc_total DESC ;

SELECT total_amount ,
CASE 
	WHEN total_amount < 1000 THEN "Low Cost"
    WHEN total_amount BETWEEN 1000 AND 5000 THEN "Medium Cost"
    WHEN total_amount > 5000 THEN "High Cost"
END AS bill_category
FROM billing ;

SELECT * from records ;

SELECT CONCAT(first_name,' ',last_name) AS full_name ,
payment_method 
FROM patients p 
JOIN billing bil
ON p.patient_id = bil.patient_id 
JOIN payments pay 
ON bil.bill_id = pay.bill_id 
WHERE payment_method = "Card";

SELECT CONCAT(first_name,' ',last_name) AS full_name, 
department_name
FROM doctors doc
JOIN departments dep 
ON dep.department_id = doc.department_id 
WHERE department_name =  "Cardiology" OR department_name = "Neurology" ;

START TRANSACTION ;

UPDATE billing 
SET total_amount = 5500
WHERE bill_id = 5 ;
ROLLBACK ;

SELECT status , COUNT(status) AS total 
FROM appointments 
GROUP BY status 
HAVING status = "complete" OR status = "cancelled";


















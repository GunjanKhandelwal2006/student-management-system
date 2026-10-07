-- ====================================================================
-- STUDENT MANAGEMENT SYSTEM - DATABASE CREATION & SEED SCRIPT
-- Compatible with MySQL 5.5+, MySQL 8.0+, MariaDB (XAMPP Default)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS student_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE student_management;

DROP TABLE IF EXISTS students;

CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    gender ENUM('Male', 'Female', 'Other') DEFAULT 'Male',
    dob DATE,
    course VARCHAR(100) NOT NULL,
    semester INT NOT NULL DEFAULT 1,
    department VARCHAR(100) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_student_name (name),
    INDEX idx_student_dept (department),
    INDEX idx_student_course (course)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO students (name, email, phone, gender, dob, course, semester, department, address) VALUES
('Aarav Sharma', 'aarav.sharma@example.edu', '9876543210', 'Male', '2003-04-15', 'B.Tech Computer Science', 5, 'Computer Science', '42 Tech Park Avenue, Bengaluru, Karnataka'),
('Priya Patel', 'priya.patel@example.edu', '9823456789', 'Female', '2003-08-22', 'B.Tech Information Technology', 5, 'Information Technology', '15 Green Valley Residency, Ahmedabad, Gujarat'),
('Rohan Verma', 'rohan.verma@example.edu', '9712345678', 'Male', '2002-11-05', 'B.Tech Electronics & Comm', 7, 'Electronics & Communication', '88 Hill View Heights, Pune, Maharashtra'),
('Ananya Iyer', 'ananya.iyer@example.edu', '9934567890', 'Female', '2004-01-30', 'BCA', 3, 'Computer Applications', '21 Temple Bell Road, Chennai, Tamil Nadu'),
('Karan Malhotra', 'karan.m@example.edu', '9845612345', 'Male', '2001-09-18', 'MCA', 3, 'Computer Applications', '702 Skyline Towers, Cyber City, Gurugram, Haryana'),
('Sneha Mukherjee', 'sneha.m@example.edu', '9890123456', 'Female', '2003-06-12', 'B.Tech Computer Science', 5, 'Computer Science', '104 Lake Gardens, Kolkata, West Bengal'),
('Vikram Singh', 'vikram.singh@example.edu', '9789012345', 'Male', '2002-12-08', 'B.Tech Electronics & Comm', 7, 'Electronics & Communication', '33 Royal Enclave, Jaipur, Rajasthan'),
('Diya Nair', 'diya.nair@example.edu', '9912348765', 'Female', '2004-03-25', 'B.Tech Information Technology', 3, 'Information Technology', '5 Coastal Breeze Apartments, Kochi, Kerala'),
('Aditya Joshi', 'aditya.joshi@example.edu', '9867543219', 'Male', '2003-07-14', 'BCA', 5, 'Computer Applications', '19 Prabhat Road, Shivaji Nagar, Pune, Maharashtra'),
('Neha Gupta', 'neha.gupta@example.edu', '9822334455', 'Female', '2002-10-10', 'MCA', 1, 'Computer Applications', '67 Civil Lines, New Delhi, Delhi');

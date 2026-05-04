-- ============================================================
-- PROJECT 02: HOSPITAL MANAGEMENT SYSTEM
-- DATCOM Lab - NEU College of Technology
-- File: 01_schema.sql - Tạo cơ sở dữ liệu và các bảng
-- ============================================================

CREATE DATABASE IF NOT EXISTS HospitalManagementDB
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE HospitalManagementDB;

-- Bảng Departments (Khoa khám bệnh)
CREATE TABLE Departments (
    DepartmentID    INT             AUTO_INCREMENT PRIMARY KEY,
    DepartmentName  VARCHAR(150)    NOT NULL UNIQUE
);

-- Bảng Patients (Bệnh nhân)
CREATE TABLE Patients (
    PatientID       INT             AUTO_INCREMENT PRIMARY KEY,
    PatientName     VARCHAR(100)    NOT NULL,
    DateOfBirth     DATE            NOT NULL,
    Gender          ENUM('Male', 'Female', 'Other') DEFAULT 'Other',
    Address         VARCHAR(255),
    PhoneNumber     VARCHAR(15)
);

-- Bảng Doctors (Bác sĩ)
CREATE TABLE Doctors (
    DoctorID        INT             AUTO_INCREMENT PRIMARY KEY,
    DoctorName      VARCHAR(100)    NOT NULL,
    DepartmentID    INT             NOT NULL,
    Specialty       VARCHAR(150),
    CONSTRAINT fk_doctor_department
        FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Bảng Appointments (Lịch hẹn khám)
CREATE TABLE Appointments (
    AppointmentID   INT             AUTO_INCREMENT PRIMARY KEY,
    DoctorID        INT             NOT NULL,
    PatientID       INT             NOT NULL,
    AppointmentDate DATE            NOT NULL,
    AppointmentTime TIME            NOT NULL,
    Status          ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uq_appointment UNIQUE (DoctorID, AppointmentDate, AppointmentTime)
);

-- Bảng Invoices (Hóa đơn)
CREATE TABLE Invoices (
    InvoiceID       INT             AUTO_INCREMENT PRIMARY KEY,
    PatientID       INT             NOT NULL,
    InvoiceDate     DATE            NOT NULL DEFAULT (CURRENT_DATE),
    TotalAmount     DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    PaymentStatus   ENUM('Unpaid', 'Paid') DEFAULT 'Unpaid',
    CONSTRAINT fk_invoice_patient
        FOREIGN KEY (PatientID) REFERENCES Patients(PatientID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- Bảng SystemAuditLog (Phục vụ Trigger ghi lại lịch sử)
CREATE TABLE SystemAuditLog (
    LogID           INT             AUTO_INCREMENT PRIMARY KEY,
    ActionType      VARCHAR(50)     NOT NULL,
    TableName       VARCHAR(50)     NOT NULL,
    RecordID        INT,
    ActionTime      DATETIME        DEFAULT CURRENT_TIMESTAMP,
    Description     VARCHAR(255)
);

-- ============================================================
-- File: 02_sample_data.sql - Dữ liệu mẫu (5-10 bản ghi mỗi bảng)
-- ============================================================
USE HospitalManagementDB;

-- Dữ liệu Departments (5 khoa)
INSERT INTO Departments (DepartmentName) VALUES
('Cardiology'), 
('Neurology'), 
('Pediatrics'), 
('Orthopedics'), 
('Dermatology');

-- Dữ liệu Doctors (10 bác sĩ)
INSERT INTO Doctors (DoctorName, DepartmentID, Specialty) VALUES
('Dr. Nguyen Van Tuan', 1, 'Heart Surgery'),
('Dr. Tran Thi Lan', 1, 'Cardiovascular Diseases'),
('Dr. Le Bao Minh', 2, 'Brain Specialist'),
('Dr. Pham Thu Ha', 2, 'Nerve Disorders'),
('Dr. Hoang Ngoc Mai', 3, 'Child Care & Nutrition'),
('Dr. Vu Van Kien', 3, 'Pediatric Surgery'),
('Dr. Do Minh Dung', 4, 'Bone Specialist'),
('Dr. Bui Thi Hoa', 4, 'Sports Injuries'),
('Dr. Dang Van Hung', 5, 'Skin Diseases'),
('Dr. Ngo Thi Cam', 5, 'Cosmetic Dermatology');

-- Dữ liệu Patients (10 bệnh nhân)
INSERT INTO Patients (PatientName, DateOfBirth, Gender, Address, PhoneNumber) VALUES
('Tran Van A', '1985-04-12', 'Male', 'Hanoi', '0901234567'),
('Nguyen Thi B', '1992-08-25', 'Female', 'Hanoi', '0912345678'),
('Le Van C', '1978-11-03', 'Male', 'Hai Phong', '0923456789'),
('Pham Ngoc D', '2005-01-15', 'Female', 'Da Nang', '0934567890'),
('Hoang Van E', '1965-07-30', 'Male', 'HCMC', '0945678901'),
('Vu Thi F', '1999-02-14', 'Female', 'Can Tho', '0956789012'),
('Do Minh G', '1988-09-09', 'Male', 'Hue', '0967890123'),
('Bui Van H', '1975-12-20', 'Male', 'Quang Ninh', '0978901234'),
('Dang Thi I', '2010-05-05', 'Female', 'Nam Dinh', '0989012345'),
('Ngo Van K', '1995-10-10', 'Male', 'Thanh Hoa', '0990123456');

-- Dữ liệu Appointments (10 lịch hẹn)
INSERT INTO Appointments (DoctorID, PatientID, AppointmentDate, AppointmentTime, Status) VALUES
(1, 1, CURDATE(), '08:00:00', 'Scheduled'),
(2, 2, CURDATE(), '09:30:00', 'Completed'),
(3, 3, CURDATE(), '10:00:00', 'Scheduled'),
(5, 4, '2026-05-10', '08:30:00', 'Scheduled'),
(7, 5, '2026-05-11', '14:00:00', 'Scheduled'),
(9, 6, '2026-05-12', '15:30:00', 'Scheduled'),
(4, 7, '2026-05-10', '09:00:00', 'Cancelled'),
(6, 8, '2026-05-11', '10:30:00', 'Scheduled'),
(8, 9, '2026-05-12', '13:00:00', 'Scheduled'),
(10, 10, '2026-05-13', '16:00:00', 'Scheduled');

-- Dữ liệu Invoices (10 hóa đơn)
INSERT INTO Invoices (PatientID, InvoiceDate, TotalAmount, PaymentStatus) VALUES
(2, CURDATE(), 500000.00, 'Paid'),
(1, CURDATE(), 250000.00, 'Unpaid'),
(3, CURDATE(), 750000.00, 'Paid'),
(4, '2026-05-10', 300000.00, 'Unpaid'),
(5, '2026-05-11', 1200000.00, 'Unpaid'),
(6, '2026-05-12', 450000.00, 'Unpaid'),
(7, '2026-05-10', 150000.00, 'Paid'),
(8, '2026-05-11', 800000.00, 'Unpaid'),
(9, '2026-05-12', 350000.00, 'Unpaid'),
(10, '2026-05-13', 600000.00, 'Unpaid');


-- ============================================================
-- File: 03_indexes.sql - Chỉ mục tăng tốc độ truy vấn
-- ============================================================
USE HospitalManagementDB;

-- Index tìm kiếm bệnh nhân theo tên hoặc số điện thoại
CREATE INDEX idx_patient_name ON Patients(PatientName);
CREATE INDEX idx_patient_phone ON Patients(PhoneNumber);

-- Index tìm kiếm bác sĩ theo chuyên khoa
CREATE INDEX idx_doctor_specialty ON Doctors(Specialty);

-- Index tra cứu lịch hẹn theo ngày (Tối ưu cho báo cáo hàng ngày)
CREATE INDEX idx_appointment_date ON Appointments(AppointmentDate);

-- Index tra cứu hóa đơn theo trạng thái thanh toán
CREATE INDEX idx_invoice_status ON Invoices(PaymentStatus);


-- ============================================================
-- File: 04_views.sql - View truy cập nhanh dữ liệu
-- ============================================================
USE HospitalManagementDB;

-- View 1: Danh sách lịch hẹn trong ngày (Daily Appointments)
CREATE OR REPLACE VIEW vw_DailyAppointments AS
SELECT 
    a.AppointmentID, 
    a.AppointmentTime, 
    p.PatientName, 
    d.DoctorName, 
    dep.DepartmentName,
    a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
WHERE a.AppointmentDate = CURDATE();

-- View 2: Tóm tắt doanh thu theo bệnh nhân
CREATE OR REPLACE VIEW vw_PatientFinancialSummary AS
SELECT 
    p.PatientID,
    p.PatientName,
    COUNT(i.InvoiceID) AS TotalInvoices,
    SUM(i.TotalAmount) AS TotalBilled,
    SUM(CASE WHEN i.PaymentStatus = 'Paid' THEN i.TotalAmount ELSE 0 END) AS TotalPaid,
    SUM(CASE WHEN i.PaymentStatus = 'Unpaid' THEN i.TotalAmount ELSE 0 END) AS OutstandingBalance
FROM Patients p
LEFT JOIN Invoices i ON p.PatientID = i.PatientID
GROUP BY p.PatientID, p.PatientName;

-- View 3: Thống kê lượng khám của bác sĩ
CREATE OR REPLACE VIEW vw_DoctorWorkload AS
SELECT 
    d.DoctorID,
    d.DoctorName,
    dep.DepartmentName,
    COUNT(a.AppointmentID) AS TotalAppointments,
    SUM(a.Status = 'Completed') AS CompletedAppointments
FROM Doctors d
JOIN Departments dep ON d.DepartmentID = dep.DepartmentID
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.DoctorID, d.DoctorName, dep.DepartmentName;


-- ============================================================
-- File: 05_stored_procedures.sql - Tự động hóa quy trình
-- ============================================================
USE HospitalManagementDB;

DELIMITER $$

-- SP 1: Đặt lịch hẹn mới (Kiểm tra trùng lịch bác sĩ)
CREATE PROCEDURE sp_ScheduleAppointment(
    IN p_DoctorID INT,
    IN p_PatientID INT,
    IN p_Date DATE,
    IN p_Time TIME,
    OUT p_Message VARCHAR(255)
)
BEGIN
    DECLARE v_conflict INT DEFAULT 0;
    
    -- Kiểm tra xem bác sĩ đã có lịch giờ đó chưa
    SELECT COUNT(*) INTO v_conflict
    FROM Appointments
    WHERE DoctorID = p_DoctorID AND AppointmentDate = p_Date AND AppointmentTime = p_Time;
    
    IF v_conflict > 0 THEN
        SET p_Message = 'Bác sĩ đã có lịch hẹn vào thời gian này. Vui lòng chọn giờ khác!';
    ELSE
        INSERT INTO Appointments (DoctorID, PatientID, AppointmentDate, AppointmentTime)
        VALUES (p_DoctorID, p_PatientID, p_Date, p_Time);
        SET p_Message = 'Đặt lịch hẹn thành công!';
    END IF;
END$$

-- SP 2: Tạo hóa đơn thanh toán
CREATE PROCEDURE sp_GenerateInvoice(
    IN p_PatientID INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    INSERT INTO Invoices (PatientID, InvoiceDate, TotalAmount, PaymentStatus)
    VALUES (p_PatientID, CURRENT_DATE, p_Amount, 'Unpaid');
END$$

DELIMITER ;


-- ============================================================
-- File: 06_functions.sql - Hàm người dùng tự định nghĩa
-- ============================================================
USE HospitalManagementDB;

DELIMITER $$

-- Hàm 1: Tính tổng doanh thu của bệnh viện trong một tháng cụ thể
CREATE FUNCTION fn_CalculateMonthlyRevenue(p_Month INT, p_Year INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_TotalRevenue DECIMAL(12,2) DEFAULT 0.00;
    
    SELECT SUM(TotalAmount) INTO v_TotalRevenue
    FROM Invoices
    WHERE MONTH(InvoiceDate) = p_Month 
      AND YEAR(InvoiceDate) = p_Year 
      AND PaymentStatus = 'Paid';
      
    RETURN IFNULL(v_TotalRevenue, 0.00);
END$$

-- Hàm 2: Đếm số lượng lịch hẹn của một bệnh nhân
CREATE FUNCTION fn_CountPatientAppointments(p_PatientID INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_Count INT;
    SELECT COUNT(*) INTO v_Count
    FROM Appointments 
    WHERE PatientID = p_PatientID;
    RETURN v_Count;
END$$

DELIMITER ;


-- ============================================================
-- File: 07_triggers.sql - Trigger tự động cập nhật
-- ============================================================
USE HospitalManagementDB;

DELIMITER $$

-- Trigger 1: Tự động ghi Log khi có lịch hẹn mới bị hủy
CREATE TRIGGER trg_AfterAppointmentUpdate
AFTER UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.Status <> NEW.Status AND NEW.Status = 'Cancelled' THEN
        INSERT INTO SystemAuditLog (ActionType, TableName, RecordID, Description)
        VALUES ('UPDATE', 'Appointments', NEW.AppointmentID, CONCAT('Lịch hẹn bị hủy cho bệnh nhân ID: ', NEW.PatientID));
    END IF;
END$$

-- Trigger 2: Tự động sinh hóa đơn khám cơ bản (200,000 VND) khi lịch hẹn được đánh dấu Completed
CREATE TRIGGER trg_AutoGenerateInvoice
AFTER UPDATE ON Appointments
FOR EACH ROW
BEGIN
    IF OLD.Status <> 'Completed' AND NEW.Status = 'Completed' THEN
        INSERT INTO Invoices (PatientID, InvoiceDate, TotalAmount, PaymentStatus)
        VALUES (NEW.PatientID, NEW.AppointmentDate, 200000.00, 'Unpaid');
        
        INSERT INTO SystemAuditLog (ActionType, TableName, RecordID, Description)
        VALUES ('AUTO_INSERT', 'Invoices', LAST_INSERT_ID(), 'Tự động tạo hóa đơn khám bệnh cơ bản');
    END IF;
END$$

DELIMITER ;


-- ============================================================
-- File: 08_security.sql - Bảo mật và phân quyền
-- ============================================================

-- Xóa user nếu đã tồn tại để tránh lỗi
DROP USER IF EXISTS 'admin_hospital'@'localhost';
DROP USER IF EXISTS 'doctor_role'@'localhost';
DROP USER IF EXISTS 'receptionist_role'@'localhost';

-- Tạo user Quản trị viên (Toàn quyền)
CREATE USER 'admin_hospital'@'localhost' IDENTIFIED BY 'Admin@2024Hosp';
GRANT ALL PRIVILEGES ON HospitalManagementDB.* TO 'admin_hospital'@'localhost';

-- Tạo user Bác sĩ (Chỉ xem lịch hẹn của mình và cập nhật trạng thái)
CREATE USER 'doctor_role'@'localhost' IDENTIFIED BY 'Doctor@2024';
GRANT SELECT ON HospitalManagementDB.Patients TO 'doctor_role'@'localhost';
GRANT SELECT, UPDATE ON HospitalManagementDB.Appointments TO 'doctor_role'@'localhost';
GRANT SELECT ON HospitalManagementDB.vw_DailyAppointments TO 'doctor_role'@'localhost';

-- Tạo user Lễ tân (Quản lý bệnh nhân, lịch hẹn, hóa đơn)
CREATE USER 'receptionist_role'@'localhost' IDENTIFIED BY 'Reception@2024';
GRANT SELECT, INSERT, UPDATE ON HospitalManagementDB.Patients TO 'receptionist_role'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON HospitalManagementDB.Appointments TO 'receptionist_role'@'localhost';
GRANT SELECT, INSERT, UPDATE ON HospitalManagementDB.Invoices TO 'receptionist_role'@'localhost';
GRANT EXECUTE ON PROCEDURE HospitalManagementDB.sp_ScheduleAppointment TO 'receptionist_role'@'localhost';

FLUSH PRIVILEGES;
-- Banking Fraud Detection & Risk Analytics System using Advanced SQL

DROP DATABASE IF EXISTS FraudDetectionDB;
CREATE DATABASE FraudDetectionDB;
USE FraudDetectionDB;

-- Table 1 : Users

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    user_status VARCHAR(20) NOT NULL,
    kyc_status VARCHAR(20) NOT NULL
);

-- Table 2 : GeoLocation

CREATE TABLE GeoLocation (
    ip_address VARCHAR(50) PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL
);

-- Table 3 : Devices

CREATE TABLE Devices (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    device_type VARCHAR(50) NOT NULL,
    ip_address VARCHAR(50) UNIQUE,
    location VARCHAR(100),
    FOREIGN KEY (ip_address)
        REFERENCES GeoLocation(ip_address)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 4 : Accounts

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    account_type VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    CHECK (balance >= 0),
    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 5 : Transactions

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    device_id INT,
    CHECK (amount > 0),
    FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (device_id)
        REFERENCES Devices(device_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Table 6 : FraudAlerts

CREATE TABLE FraudAlerts (
    alert_id INT PRIMARY KEY AUTO_INCREMENT,
    transaction_id INT,
    account_id INT,
    user_id INT,
    alert_type VARCHAR(50) NOT NULL,
    alert_date TIMESTAMP NOT NULL,
    risk_score DECIMAL(5,2),
    CHECK (risk_score BETWEEN 0 AND 100),
    FOREIGN KEY (transaction_id)
        REFERENCES Transactions(transaction_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (account_id)
        REFERENCES Accounts(account_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 7 : AuditLogs

CREATE TABLE AuditLogs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    device_id INT,
    login_time TIMESTAMP NOT NULL,
    login_status VARCHAR(30) NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (device_id)
        REFERENCES Devices(device_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table 8 : RiskScores

CREATE TABLE RiskScores (
    risk_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    score DECIMAL(5,2),
    risk_level VARCHAR(20),
    last_updated TIMESTAMP NOT NULL,
    CHECK (score BETWEEN 0 AND 100),
    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- INDEXES

CREATE INDEX idx_transaction_date
ON Transactions(transaction_date);

CREATE INDEX idx_transaction_account
ON Transactions(account_id);

CREATE INDEX idx_transaction_device
ON Transactions(device_id);

CREATE INDEX idx_fraud_risk
ON FraudAlerts(risk_score);

CREATE INDEX idx_fraud_user
ON FraudAlerts(user_id);

CREATE INDEX idx_audit_login
ON AuditLogs(login_time);

CREATE INDEX idx_risk_score
ON RiskScores(score);

CREATE INDEX idx_accounts_user
ON Accounts(user_id);


INSERT INTO Users (user_id, first_name, last_name, email, phone, registration_date, user_status, kyc_status) 
VALUES
(1, 'Ravi', 'Kumar', 'ravi.kumar@fdproject.com', 9876543210, '2023-08-26', 'Suspended', 'Pending'),
(2, 'Anita', 'Sharma', 'anita.sharma@fdproject.com', 9123456780, '2021-10-12', 'Active', 'Rejected'),
(3, 'Mohammed', 'Ali', 'mohammed.ali@fdproject.com', 9988776655, '2022-01-05', 'Active', 'Verified'),
(4, 'Priya', 'Singh', 'priya.singh@fdproject.com', 9876501234, '2024-07-06', 'Dormant', 'Rejected'),
(5, 'David', 'Johnson', 'david.johnson@fdproject.com', 9001122334, '2023-05-06', 'Active', 'Verified'),
(6, 'Sneha', 'Reddy', 'sneha.reddy@fdproject.com', 9556677889, '2023-06-10', 'Active', 'Verified'),
(7, 'Arun', 'Mehta', 'arun.mehta@fdproject.com', 9112233445, '2022-01-19', 'Dormant', 'Verified'),
(8, 'Meera', 'Joshi', 'meera.joshi@fdproject.com', 9132109876, '2021-12-29', 'Blocked', 'Verified'),
(9, 'John', 'Smith', 'john.smith@fdproject.com', 9121098765, '2021-09-15', 'Dormant', 'Verified'),
(10, 'Lakshmi', 'Menon', 'lakshmi.menon@fdproject.com', 9110987654, '2025-01-30', 'Blocked', 'Verified'),
(11, 'Global', 'Traders Ltd', 'contact@globaltraders.com', 8009988776, '2021-07-15', 'Active', 'Rejected'),
(12, 'TechNova', 'Solutions', 'info@technova.com', 8012345678, '2021-03-19', 'Active', 'Verified'),
(13, 'FinSecure', 'Pvt Ltd', 'support@finsecure.com', 8023456789, '2022-02-06', 'Dormant', 'Verified'),
(14, 'SafeBank', 'Corp', 'admin@safebank.com', 8034567890, '2024-08-23', 'Blocked', 'Verified'),
(15, 'DataShield', 'Analytics', 'contact@datashield.com', 8045678901, '2021-09-23', 'Suspended', 'Verified'),
(16, 'Carlos', 'Gomez', 'carlos.gomez@fdproject.com', 9165432109, '2023-11-11', 'Blocked', 'Verified'),
(17, 'Emily', 'Brown', 'emily.brown@fdproject.com', 9198765432, '2024-12-21', 'Active', 'Rejected'),
(18, 'Chen', 'Wei', 'chen.wei@fdproject.com', 9187654321, '2024-05-23', 'Dormant', 'Pending'),
(19, 'Fatima', 'Noor', 'fatima.noor@fdproject.com', 9176543210, '2024-08-27', 'Active', 'Pending'),
(20, 'Sophia', 'Patel', 'sophia.patel@fdproject.com', 9154321098, '2022-05-23', 'Suspended', 'Rejected'),
(21, 'Rahul', 'Verma', 'rahul.verma@fdproject.com', 9876123450, '2021-06-19', 'Blocked', 'Rejected'),
(22, 'Kavita', 'Nair', 'kavita.nair@fdproject.com', 9123409876, '2025-03-16', 'Suspended', 'Verified'),
(23, 'Rajesh', 'Iyer', 'rajesh.iyer@fdproject.com', 9143210987, '2022-01-21', 'Dormant', 'Verified'),
(24, 'Jessica', 'Wong', 'jessica.wong@fdproject.com', 9009876543, '2024-04-17', 'Blocked', 'Verified'),
(25, 'Thomas', 'Lee', 'thomas.lee@fdproject.com', 8987654321, '2021-05-07', 'Suspended', 'Pending'),
(26, 'Virat', 'Kohli', 'virat.kohli@fdproject.com', 9812345678, '2023-03-16', 'Active', 'Pending'),
(27, 'MS', 'Dhoni', 'ms.dhoni@fdproject.com', 9823456789, '2021-05-24', 'Active', 'Verified'),
(28, 'Sachin', 'Tendulkar', 'sachin.tendulkar@fdproject.com', 9834567890, '2025-04-25', 'Active', 'Rejected'),
(29, 'Rohit', 'Sharma', 'rohit.sharma@fdproject.com', 9845678901, '2024-07-30', 'Active', 'Verified'),
(30, 'KL', 'Rahul', 'kl.rahul@fdproject.com', 9856789012, '2023-11-20', 'Blocked', 'Pending'),
(31, 'Hardik', 'Pandya', 'hardik.pandya@fdproject.com', 9867890123, '2023-02-09', 'Suspended', 'Verified'),
(32, 'Jasprit', 'Bumrah', 'jasprit.bumrah@fdproject.com', 9878901234, '2023-01-18', 'Active', 'Pending'),
(33, 'Shikhar', 'Dhawan', 'shikhar.dhawan@fdproject.com', 9889012345, '2022-11-07', 'Suspended', 'Verified'),
(34, 'Yuvraj', 'Singh', 'yuvraj.singh@fdproject.com', 9890123456, '2022-02-06', 'Active', 'Verified'),
(35, 'Sourav', 'Ganguly', 'sourav.ganguly@fdproject.com', 9901234567, '2024-07-31', 'Active', 'Verified'),
(36, 'Kapil', 'Dev', 'kapil.dev@fdproject.com', 9912345678, '2023-04-07', 'Active', 'Verified'),
(37, 'Rahul', 'Dravid', 'rahul.dravid@fdproject.com', 9923456789, '2021-10-25', 'Active', 'Verified'),
(38, 'Anil', 'Kumble', 'anil.kumble@fdproject.com', 9934567890, '2021-04-27', 'Suspended', 'Verified'),
(39, 'Sunil', 'Gavaskar', 'sunil.gavaskar@fdproject.com', 9945678901, '2023-08-31', 'Active', 'Verified'),
(40, 'Mohammad', 'Azharuddin', 'azharuddin@fdproject.com', 9956789012, '2021-08-22', 'Active', 'Pending'),
(41, 'Ravindra', 'Jadeja', 'ravindra.jadeja@fdproject.com', 9967890123, '2023-12-17', 'Active', 'Verified'),
(42, 'Bhuvneshwar', 'Kumar', 'bhuvi.kumar@fdproject.com', 9978901234, '2021-11-03', 'Blocked', 'Pending'),
(43, 'Rishabh', 'Pant', 'rishabh.pant@fdproject.com', 9989012345, '2022-10-07', 'Active', 'Verified'),
(44, 'Mohammed', 'Shami', 'mohammed.shami@fdproject.com', 9990123456, '2023-02-27', 'Blocked', 'Verified'),
(45, 'Suryakumar', 'Yadav', 'surya.yadav@fdproject.com', 9811122233, '2021-03-02', 'Active', 'Verified'),
(46, 'Sanju', 'Samson', 'sanju.samson@fdproject.com', 9822233344, '2024-06-29', 'Active', 'Pending'),
(47, 'Ishan', 'Kishan', 'ishan.kishan@fdproject.com', 9833344455, '2024-05-28', 'Active', 'Pending'),
(48, 'Kuldeep', 'Yadav', 'kuldeep.yadav@fdproject.com', 9844455566, '2022-08-31', 'Dormant', 'Verified'),
(49, 'Axar', 'Patel', 'axar.patel@fdproject.com', 9855566677, '2022-11-09', 'Active', 'Pending'),
(50, 'Ashwin', 'Ravichandran', 'ashwin.r@fdproject.com', 9866677788, '2025-01-21', 'Suspended', 'Pending'),
(51, 'Chris', 'Gayle', 'chris.gayle@fdproject.com', 9877788899, '2025-03-05', 'Blocked', 'Pending'),
(52, 'AB', 'de Villiers', 'ab.devilliers@fdproject.com', 9888899900, '2021-10-20', 'Suspended', 'Rejected'),
(53, 'Brian', 'Lara', 'brian.lara@fdproject.com', 9899900011, '2025-03-25', 'Active', 'Pending'),
(54, 'Jacques', 'Kallis', 'jacques.kallis@fdproject.com', 9900011122, '2023-11-29', 'Suspended', 'Verified'),
(55, 'Ricky', 'Ponting', 'ricky.ponting@fdproject.com', 9911122233, '2025-03-06', 'Active', 'Verified'),
(56, 'Steve', 'Smith', 'steve.smith@fdproject.com', 9922233344, '2024-10-01', 'Active', 'Rejected'),
(57, 'David', 'Warner', 'david.warner@fdproject.com', 9933344455, '2023-01-27', 'Active', 'Verified'),
(58, 'Kane', 'Williamson', 'kane.williamson@fdproject.com', 9944455566, '2025-04-14', 'Suspended', 'Verified'),
(59, 'Brendon', 'McCullum', 'brendon.mccullum@fdproject.com', 9955566677, '2025-01-09', 'Dormant', 'Verified'),
(60, 'Muttiah', 'Muralitharan', 'murali@fdproject.com', 9966677788, '2023-06-01', 'Active', 'Verified'),
(61, 'Shane', 'Warne', 'shane.warne@fdproject.com', 9977788899, '2022-02-24', 'Active', 'Verified'),
(62, 'Glenn', 'McGrath', 'glenn.mcgrath@fdproject.com', 9988899900, '2023-02-15', 'Blocked', 'Verified'),
(63, 'Adam', 'Gilchrist', 'adam.gilchrist@fdproject.com', 9999900011, '2021-06-14', 'Active', 'Verified'),
(64, 'Michael', 'Clarke', 'michael.clarke@fdproject.com', 9910011122, '2021-09-16', 'Dormant', 'Verified'),
(65, 'Brett', 'Lee', 'brett.lee@fdproject.com', 9921122233, '2022-04-08', 'Active', 'Verified'),
(66, 'Shahid', 'Afridi', 'shahid.afridi@fdproject.com', 9932233344, '2021-06-16', 'Dormant', 'Verified'),
(67, 'Inzamam', 'Ul Haq', 'inzamam.ulhaq@fdproject.com', 9943344455, '2023-12-31', 'Active', 'Pending'),
(68, 'Wasim', 'Akram', 'wasim.akram@fdproject.com', 9954455566, '2023-12-21', 'Blocked', 'Verified'),
(69, 'Waqar', 'Younis', 'waqar.younis@fdproject.com', 9965566677, '2024-12-29', 'Active', 'Rejected'),
(70, 'Allan', 'Donald', 'allan.donald@fdproject.com', 9976677788, '2022-05-09', 'Active', 'Verified'),
(71, 'Graeme', 'Smith', 'graeme.smith@fdproject.com', 9987788899, '2021-08-20', 'Blocked', 'Verified'),
(72, 'Mahela', 'Jayawardene', 'mahela.jayawardene@fdproject.com', 9998899900, '2021-07-08', 'Blocked', 'Verified'),
(73, 'Kumar', 'Sangakkara', 'kumar.sangakkara@fdproject.com', 9919900011, '2021-06-18', 'Dormant', 'Verified'),
(74, 'Aravinda', 'De Silva', 'aravinda.desilva@fdproject.com', 9920011122, '2023-01-07', 'Active', 'Verified'),
(75, 'Chaminda', 'Vaas', 'chaminda.vaas@fdproject.com', 9931122233, '2021-06-22', 'Active', 'Rejected'),
(76, 'Daniel', 'Vettori', 'daniel.vettori@fdproject.com', 9942233344, '2021-09-10', 'Dormant', 'Verified'),
(77, 'Ross', 'Taylor', 'ross.taylor@fdproject.com', 9953344455, '2024-05-28', 'Blocked', 'Verified'),
(78, 'Martin', 'Guptill', 'martin.guptill@fdproject.com', 9964455566, '2024-11-22', 'Active', 'Rejected'),
(79, 'Trent', 'Boult', 'trent.boult@fdproject.com', 9975566677, '2023-10-27', 'Suspended', 'Rejected'),
(80, 'Tim', 'Southee', 'tim.southee@fdproject.com', 9986677788, '2021-02-02', 'Active', 'Verified');


INSERT INTO GeoLocation (ip_address, country, city) 
VALUES
('22.128.104.162', 'Singapore', 'Singapore'),
('158.65.165.94', 'USA', 'Chicago'),
('221.146.79.73', 'Singapore', 'Singapore'),
('95.209.24.161', 'USA', 'San Francisco'),
('141.60.36.75', 'India', 'Hyderabad'),
('78.182.243.150', 'Germany', 'Munich'),
('165.208.155.4', 'UK', 'Manchester'),
('201.237.236.33', 'UK', 'London'),
('149.59.201.197', 'UK', 'Manchester'),
('163.60.213.247', 'India', 'Mumbai'),
('196.213.168.7', 'UAE', 'Dubai'),
('158.208.17.210', 'UK', 'Manchester'),
('131.58.185.73', 'Germany', 'Berlin'),
('212.53.121.102', 'UAE', 'Dubai'),
('153.18.132.12', 'Germany', 'Berlin'),
('129.57.71.123', 'India', 'Hyderabad'),
('170.138.86.211', 'Singapore', 'Singapore'),
('193.18.39.187', 'UK', 'Manchester'),
('52.238.98.233', 'India', 'Hyderabad'),
('165.228.110.69', 'Germany', 'Berlin'),
('111.221.151.7', 'Singapore', 'Singapore'),
('216.13.65.86', 'USA', 'Dallas'),
('174.136.174.114', 'UAE', 'Abu Dhabi'),
('146.96.145.101', 'Germany', 'Berlin'),
('155.87.44.111', 'UAE', 'Dubai'),
('216.60.227.161', 'UK', 'London'),
('180.141.255.9', 'Germany', 'Berlin'),
('139.150.190.56', 'UK', 'London'),
('166.9.152.194', 'UK', 'Manchester'),
('159.188.25.139', 'UAE', 'Abu Dhabi'),
('207.70.222.57', 'USA', 'San Francisco'),
('163.29.22.64', 'Germany', 'Berlin'),
('210.245.77.3', 'UK', 'Manchester'),
('190.133.221.14', 'USA', 'New York'),
('96.231.23.65', 'UAE', 'Abu Dhabi'),
('199.172.37.19', 'Singapore', 'Singapore'),
('139.47.78.32', 'Germany', 'Munich'),
('193.25.117.6', 'USA', 'New York'),
('197.0.237.122', 'Germany', 'Berlin'),
('135.85.25.100', 'India', 'Delhi'),
('128.137.130.246', 'Singapore', 'Singapore'),
('129.18.122.156', 'Singapore', 'Singapore'),
('184.111.43.186', 'India', 'Bangalore'),
('55.194.143.70', 'Singapore', 'Singapore'),
('75.162.214.67', 'Germany', 'Berlin'),
('119.247.218.157', 'India', 'Chennai'),
('49.193.61.26', 'UAE', 'Abu Dhabi'),
('85.61.98.45', 'USA', 'Chicago'),
('160.15.93.146', 'UK', 'London'),
('41.15.132.18', 'Singapore', 'Singapore'),
('181.49.148.151', 'UAE', 'Dubai'),
('137.7.232.70', 'Germany', 'Munich'),
('218.210.180.88', 'UAE', 'Dubai'),
('219.147.88.220', 'UAE', 'Abu Dhabi'),
('210.151.182.92', 'India', 'Hyderabad'),
('187.53.43.62', 'Singapore', 'Singapore'),
('192.180.6.5', 'Germany', 'Berlin'),
('212.113.242.17', 'UK', 'London'),
('169.27.202.230', 'USA', 'Dallas'),
('54.180.56.114', 'Germany', 'Berlin');

INSERT INTO Devices (device_id, device_type, ip_address, location) 
VALUES
(1, 'Mobile', '22.128.104.162', 'Singapore'),
(2, 'ATM Machine', '158.65.165.94', 'Chicago'),
(3, 'Mobile', '221.146.79.73', 'Singapore'),
(4, 'Mobile', '95.209.24.161', 'San Francisco'),
(5, 'POS Terminal', '141.60.36.75', 'Hyderabad'),
(6, 'ATM Machine', '78.182.243.150', 'Munich'),
(7, 'Mobile', '165.208.155.4', 'Manchester'),
(8, 'Tablet', '201.237.236.33', 'London'),
(9, 'Desktop', '149.59.201.197', 'Manchester'),
(10, 'Mobile', '163.60.213.247', 'Mumbai'),
(11, 'POS Terminal', '196.213.168.7', 'Dubai'),
(12, 'Mobile', '158.208.17.210', 'Manchester'),
(13, 'POS Terminal', '131.58.185.73', 'Berlin'),
(14, 'Mobile', '212.53.121.102', 'Dubai'),
(15, 'Mobile', '153.18.132.12', 'Berlin'),
(16, 'Tablet', '129.57.71.123', 'Hyderabad'),
(17, 'Mobile', '170.138.86.211', 'Singapore'),
(18, 'Laptop', '193.18.39.187', 'Manchester'),
(19, 'Desktop', '52.238.98.233', 'Hyderabad'),
(20, 'Mobile', '165.228.110.69', 'Berlin'),
(21, 'Tablet', '111.221.151.7', 'Singapore'),
(22, 'Desktop', '216.13.65.86', 'Dallas'),
(23, 'POS Terminal', '174.136.174.114', 'Abu Dhabi'),
(24, 'Laptop', '146.96.145.101', 'Berlin'),
(25, 'Laptop', '155.87.44.111', 'Dubai'),
(26, 'Desktop', '216.60.227.161', 'London'),
(27, 'Laptop', '180.141.255.9', 'Berlin'),
(28, 'Tablet', '139.150.190.56', 'London'),
(29, 'Mobile', '166.9.152.194', 'Manchester'),
(30, 'Tablet', '159.188.25.139', 'Abu Dhabi'),
(31, 'Mobile', '207.70.222.57', 'San Francisco'),
(32, 'ATM Machine', '163.29.22.64', 'Berlin'),
(33, 'Desktop', '210.245.77.3', 'Manchester'),
(34, 'POS Terminal', '190.133.221.14', 'New York'),
(35, 'POS Terminal', '96.231.23.65', 'Abu Dhabi'),
(36, 'POS Terminal', '199.172.37.19', 'Singapore'),
(37, 'POS Terminal', '139.47.78.32', 'Munich'),
(38, 'Mobile', '193.25.117.6', 'New York'),
(39, 'Desktop', '197.0.237.122', 'Berlin'),
(40, 'Tablet', '135.85.25.100', 'Delhi'),
(41, 'Laptop', '128.137.130.246', 'Singapore'),
(42, 'Tablet', '129.18.122.156', 'Singapore'),
(43, 'Desktop', '184.111.43.186', 'Bangalore'),
(44, 'Mobile', '55.194.143.70', 'Singapore'),
(45, 'Mobile', '75.162.214.67', 'Berlin'),
(46, 'ATM Machine', '119.247.218.157', 'Chennai'),
(47, 'Mobile', '49.193.61.26', 'Abu Dhabi'),
(48, 'POS Terminal', '85.61.98.45', 'Chicago'),
(49, 'POS Terminal', '160.15.93.146', 'London'),
(50, 'Tablet', '41.15.132.18', 'Singapore'),
(51, 'Tablet', '181.49.148.151', 'Dubai'),
(52, 'Laptop', '137.7.232.70', 'Munich'),
(53, 'POS Terminal', '218.210.180.88', 'Dubai'),
(54, 'ATM Machine', '219.147.88.220', 'Abu Dhabi'),
(55, 'POS Terminal', '210.151.182.92', 'Hyderabad'),
(56, 'POS Terminal', '187.53.43.62', 'Singapore'),
(57, 'Desktop', '192.180.6.5', 'Berlin'),
(58, 'ATM Machine', '212.113.242.17', 'London'),
(59, 'Tablet', '169.27.202.230', 'Dallas'),
(60, 'Mobile', '54.180.56.114', 'Berlin');


INSERT INTO Accounts (account_id, user_id, account_type, balance, status) 
VALUES
(1, 25, 'Business', 394142.72, 'Dormant'),
(2, 50, 'Business', 308312.3, 'Active'),
(3, 3, 'Salary', 499572.55, 'Active'),
(4, 9, 'Business', 423909.77, 'Active'),
(5, 47, 'Current', 280397.44, 'Active'),
(6, 11, 'Salary', 181394.68, 'Active'),
(7, 13, 'Salary', 180004.17, 'Dormant'),
(8, 7, 'Business', 477716.73, 'Active'),
(9, 67, 'Savings', 12593.75, 'Active'),
(10, 47, 'Business', 345709.97, 'Dormant'),
(11, 37, 'Savings', 170499.3, 'Suspended'),
(12, 49, 'Salary', 389940.45, 'Active'),
(13, 28, 'Business', 63187.78, 'Frozen'),
(14, 21, 'Savings', 234404.83, 'Active'),
(15, 21, 'Savings', 460907.9, 'Dormant'),
(16, 31, 'Savings', 272408.34, 'Active'),
(17, 53, 'Current', 407852.68, 'Dormant'),
(18, 27, 'Business', 98065.51, 'Suspended'),
(19, 59, 'Salary', 233853.49, 'Active'),
(20, 19, 'Current', 172673.95, 'Suspended'),
(21, 19, 'Salary', 452158.87, 'Suspended'),
(22, 19, 'Business', 182640.37, 'Frozen'),
(23, 66, 'Business', 131576.98, 'Active'),
(24, 35, 'Salary', 71231.86, 'Active'),
(25, 49, 'Savings', 166565.83, 'Active'),
(26, 57, 'Current', 168844.16, 'Active'),
(27, 61, 'Salary', 395417.72, 'Frozen'),
(28, 75, 'Current', 334522.37, 'Active'),
(29, 21, 'Salary', 263538.98, 'Dormant'),
(30, 8, 'Savings', 392520.93, 'Dormant'),
(31, 34, 'Savings', 25392.29, 'Active'),
(32, 66, 'Salary', 45952.04, 'Frozen'),
(33, 25, 'Business', 324001.94, 'Frozen'),
(34, 26, 'Business', 200734.7, 'Active'),
(35, 14, 'Business', 202408.14, 'Active'),
(36, 1, 'Current', 170213.85, 'Active'),
(37, 41, 'Salary', 309925.84, 'Suspended'),
(38, 43, 'Current', 277423.37, 'Active'),
(39, 2, 'Current', 285990.6, 'Suspended'),
(40, 73, 'Savings', 13990.72, 'Active'),
(41, 19, 'Savings', 55252.64, 'Active'),
(42, 10, 'Current', 468927.78, 'Suspended'),
(43, 2, 'Salary', 466477.77, 'Suspended'),
(44, 12, 'Current', 303295.78, 'Dormant'),
(45, 41, 'Savings', 334522.89, 'Active'),
(46, 48, 'Current', 120311.16, 'Frozen'),
(47, 71, 'Savings', 277900.69, 'Suspended'),
(48, 73, 'Current', 157769.28, 'Active'),
(49, 33, 'Business', 123217.51, 'Active'),
(50, 55, 'Current', 481338.62, 'Active'),
(51, 76, 'Business', 266228.67, 'Active'),
(52, 13, 'Current', 399960.57, 'Active'),
(53, 21, 'Salary', 202926.61, 'Dormant'),
(54, 50, 'Salary', 330970.2, 'Frozen'),
(55, 42, 'Business', 73386.44, 'Dormant'),
(56, 46, 'Current', 63505.95, 'Active'),
(57, 18, 'Savings', 134434.48, 'Active'),
(58, 16, 'Savings', 375948.43, 'Dormant'),
(59, 37, 'Current', 382667.54, 'Dormant'),
(60, 42, 'Current', 236512.17, 'Active'),
(61, 36, 'Salary', 307410.29, 'Suspended'),
(62, 16, 'Salary', 112670.99, 'Suspended'),
(63, 79, 'Business', 490898.97, 'Active'),
(64, 26, 'Current', 421919.1, 'Suspended'),
(65, 77, 'Current', 31259.31, 'Active'),
(66, 52, 'Salary', 316473.11, 'Dormant'),
(67, 54, 'Business', 283378.34, 'Active'),
(68, 58, 'Business', 211800.0, 'Active'),
(69, 5, 'Business', 340147.16, 'Active'),
(70, 64, 'Salary', 98554.14, 'Dormant'),
(71, 13, 'Business', 490215.47, 'Active'),
(72, 48, 'Salary', 191662.54, 'Suspended'),
(73, 11, 'Current', 459915.49, 'Frozen'),
(74, 80, 'Savings', 337950.56, 'Active'),
(75, 15, 'Savings', 136889.79, 'Active'),
(76, 4, 'Current', 381233.95, 'Suspended'),
(77, 39, 'Current', 100521.22, 'Active'),
(78, 35, 'Savings', 360534.15, 'Suspended'),
(79, 66, 'Savings', 390309.34, 'Active'),
(80, 16, 'Salary', 38978.95, 'Frozen'),
(81, 67, 'Salary', 319777.39, 'Suspended'),
(82, 29, 'Salary', 438847.76, 'Frozen'),
(83, 32, 'Business', 132337.93, 'Suspended'),
(84, 4, 'Current', 229161.42, 'Active'),
(85, 44, 'Salary', 470350.22, 'Active'),
(86, 38, 'Savings', 277560.68, 'Active'),
(87, 36, 'Salary', 41528.9, 'Dormant'),
(88, 12, 'Current', 415873.65, 'Active'),
(89, 19, 'Current', 213154.17, 'Active'),
(90, 29, 'Current', 119198.66, 'Active'),
(91, 25, 'Business', 145440.78, 'Dormant'),
(92, 63, 'Salary', 76007.46, 'Active'),
(93, 71, 'Savings', 114119.81, 'Frozen'),
(94, 42, 'Current', 126397.59, 'Suspended'),
(95, 73, 'Business', 173056.24, 'Active'),
(96, 17, 'Business', 91932.94, 'Active'),
(97, 74, 'Salary', 113891.26, 'Active'),
(98, 59, 'Salary', 260987.52, 'Suspended'),
(99, 6, 'Savings', 94906.24, 'Active'),
(100, 44, 'Business', 121138.43, 'Active'),
(101, 30, 'Savings', 191218.29, 'Active'),
(102, 48, 'Savings', 208967.25, 'Active'),
(103, 61, 'Current', 50125.65, 'Dormant'),
(104, 66, 'Savings', 497649.63, 'Dormant'),
(105, 37, 'Business', 214538.37, 'Suspended'),
(106, 63, 'Salary', 340527.41, 'Active'),
(107, 62, 'Salary', 91926.66, 'Active'),
(108, 37, 'Savings', 211307.04, 'Suspended'),
(109, 19, 'Current', 22122.55, 'Active'),
(110, 67, 'Salary', 211836.57, 'Suspended'),
(111, 31, 'Business', 14793.01, 'Active'),
(112, 64, 'Salary', 251055.8, 'Active'),
(113, 26, 'Current', 287576.87, 'Dormant'),
(114, 54, 'Salary', 25302.39, 'Suspended'),
(115, 68, 'Savings', 124213.8, 'Suspended'),
(116, 65, 'Salary', 311982.05, 'Active'),
(117, 77, 'Current', 397148.85, 'Active'),
(118, 28, 'Savings', 131682.74, 'Active'),
(119, 52, 'Current', 77075.49, 'Suspended'),
(120, 55, 'Savings', 236425.79, 'Frozen'),
(121, 48, 'Current', 257394.36, 'Active'),
(122, 71, 'Savings', 213167.0, 'Active'),
(123, 72, 'Business', 396219.21, 'Active'),
(124, 45, 'Business', 449800.93, 'Active'),
(125, 58, 'Business', 465058.76, 'Active'),
(126, 20, 'Savings', 477780.69, 'Suspended'),
(127, 5, 'Business', 117747.66, 'Active'),
(128, 7, 'Current', 265360.79, 'Dormant'),
(129, 76, 'Business', 466484.32, 'Dormant'),
(130, 45, 'Salary', 94567.41, 'Active');


INSERT INTO Transactions (transaction_id, account_id, transaction_date, amount, transaction_type, location, device_id) 
VALUES
(1, 114, '2024-08-21 02:28:41', 30405.22, 'Transfer', 'London', 49),
(2, 73, '2025-02-12 12:00:11', 47774.3, 'Bill Payment', 'Berlin', 13),
(3, 78, '2024-12-10 02:15:28', 60685.0, 'Purchase', 'Munich', 52),
(4, 99, '2024-02-11 02:28:18', 19988.72, 'Bill Payment', 'London', 28),
(5, 93, '2025-03-13 08:46:39', 29482.66, 'Purchase', 'New York', 34),
(6, 23, '2024-11-08 23:10:20', 43122.58, 'Purchase', 'London', 8),
(7, 107, '2024-01-27 00:09:11', 37077.05, 'ATM Withdrawal', 'Singapore', 41),
(8, 35, '2024-12-13 20:21:02', 64839.36, 'Withdrawal', 'Abu Dhabi', 54),
(9, 86, '2024-09-09 18:13:29', 80607.18, 'Bill Payment', 'Berlin', 15),
(10, 130, '2024-04-22 11:16:19', 4260.59, 'Transfer', 'Dubai', 51),
(11, 29, '2024-09-09 07:41:18', 82349.73, 'Withdrawal', 'New York', 38),
(12, 94, '2024-07-28 04:31:12', 704.71, 'Purchase', 'Munich', 52),
(13, 40, '2024-12-29 16:15:45', 77578.02, 'Deposit', 'Abu Dhabi', 54),
(14, 68, '2024-10-20 14:07:16', 35354.3, 'Withdrawal', 'Berlin', 57),
(15, 95, '2024-12-12 18:06:05', 15466.01, 'Deposit', 'Manchester', 33),
(16, 32, '2024-04-30 23:46:48', 36003.42, 'Withdrawal', 'Berlin', 20),
(17, 54, '2024-09-02 02:49:58', 26679.65, 'Withdrawal', 'Berlin', 24),
(18, 97, '2024-03-11 17:51:30', 78252.11, 'ATM Withdrawal', 'Singapore', 41),
(19, 52, '2024-06-23 21:55:58', 500450.28, 'Transfer', 'Dubai', 53),
(20, 111, '2024-12-22 09:13:57', 48915.89, 'Bill Payment', 'Berlin', 24),
(21, 129, '2024-10-23 02:44:10', 51461.05, 'Transfer', 'Dubai', 11),
(22, 30, '2024-10-01 23:11:46', 517160.21, 'Withdrawal', 'Manchester', 33),
(23, 69, '2024-01-07 10:03:47', 57356.61, 'Bill Payment', 'Chicago', 48),
(24, 122, '2024-11-19 22:25:14', 49747.12, 'Deposit', 'Berlin', 15),
(25, 115, '2024-05-21 20:59:36', 75010.68, 'Transfer', 'Abu Dhabi', 54),
(26, 39, '2024-02-15 05:09:38', 45728.83, 'Bill Payment', 'Singapore', 44),
(27, 23, '2024-02-12 18:52:57', 29967.44, 'Withdrawal', 'Singapore', 17),
(28, 2, '2024-09-09 06:17:04', 34081.28, 'Withdrawal', 'London', 49),
(29, 116, '2024-11-07 08:26:50', 73694.87, 'ATM Withdrawal', 'London', 49),
(30, 95, '2024-09-22 21:23:10', 35702.19, 'Bill Payment', 'Singapore', 36),
(31, 93, '2024-09-13 22:51:06', 70177.96, 'ATM Withdrawal', 'London', 26),
(32, 2, '2024-04-26 15:55:38', 54327.21, 'ATM Withdrawal', 'Abu Dhabi', 23),
(33, 49, '2024-12-20 20:01:19', 65825.9, 'Bill Payment', 'Manchester', 9),
(34, 125, '2025-01-15 21:20:43', 23179.89, 'ATM Withdrawal', 'Manchester', 9),
(35, 57, '2024-08-08 09:12:28', 78557.47, 'ATM Withdrawal', 'Bangalore', 43),
(36, 43, '2024-09-14 05:52:43', 21871.19, 'Purchase', 'Hyderabad', 19),
(37, 100, '2024-12-25 05:59:37', 1125.37, 'Purchase', 'San Francisco', 4),
(38, 16, '2024-03-15 01:21:55', 65353.01, 'Transfer', 'Chicago', 2),
(39, 91, '2024-06-07 19:15:21', 50575.87, 'Bill Payment', 'Berlin', 45),
(40, 36, '2024-08-04 01:48:14', 83689.58, 'Transfer', 'New York', 34),
(41, 67, '2024-06-21 23:44:33', 10855.41, 'Deposit', 'Munich', 37),
(42, 128, '2024-12-15 22:25:57', 36298.79, 'Transfer', 'Berlin', 60),
(43, 37, '2024-04-28 21:10:36', 58305.09, 'Transfer', 'Singapore', 21),
(44, 19, '2025-04-17 13:30:33', 496069.85, 'ATM Withdrawal', 'San Francisco', 4),
(45, 115, '2024-01-18 23:31:35', 78351.07, 'Transfer', 'Singapore', 44),
(46, 85, '2024-02-20 23:08:37', 26727.77, 'Withdrawal', 'Manchester', 12),
(47, 58, '2024-09-04 04:45:55', 73797.08, 'ATM Withdrawal', 'Dubai', 51),
(48, 102, '2024-06-01 23:28:14', 79621.58, 'Deposit', 'Hyderabad', 16),
(49, 81, '2025-04-27 12:56:04', 580957.75, 'Deposit', 'Singapore', 21),
(50, 26, '2024-06-18 16:21:43', 49402.25, 'Purchase', 'Singapore', 44),
(51, 52, '2024-05-25 18:18:30', 26631.27, 'Transfer', 'Singapore', 17),
(52, 32, '2024-05-16 20:39:51', 5190.98, 'Deposit', 'Singapore', 21),
(53, 104, '2024-11-11 08:05:37', 15010.51, 'Bill Payment', 'Singapore', 50),
(54, 96, '2024-06-22 19:48:23', 56168.64, 'Transfer', 'Dubai', 53),
(55, 57, '2024-04-20 08:09:32', 51692.17, 'Purchase', 'Manchester', 18),
(56, 103, '2024-11-08 00:56:37', 8545.83, 'Bill Payment', 'Berlin', 39),
(57, 91, '2025-03-08 13:27:35', 40737.21, 'Bill Payment', 'Abu Dhabi', 23),
(58, 71, '2024-09-14 21:47:19', 70535.72, 'Transfer', 'Berlin', 13),
(59, 59, '2024-01-11 12:10:52', 38754.51, 'Withdrawal', 'London', 28),
(60, 24, '2024-04-20 11:24:02', 55605.06, 'Withdrawal', 'Berlin', 15),
(61, 17, '2024-04-29 22:11:03', 24947.07, 'Deposit', 'London', 58),
(62, 50, '2024-11-01 00:46:21', 63215.57, 'Purchase', 'Berlin', 27),
(63, 61, '2024-05-02 15:43:05', 16559.27, 'Purchase', 'Munich', 6),
(64, 130, '2024-09-29 16:32:03', 48758.11, 'Bill Payment', 'London', 8),
(65, 37, '2024-08-29 17:08:18', 80274.58, 'Withdrawal', 'Dallas', 59),
(66, 60, '2024-05-02 21:24:53', 531109.02, 'Withdrawal', 'Hyderabad', 5),
(67, 112, '2024-09-08 22:08:13', 7837.23, 'Bill Payment', 'Munich', 52),
(68, 9, '2024-01-09 18:17:53', 51982.37, 'Deposit', 'Chicago', 2),
(69, 28, '2024-08-25 03:41:35', 75585.85, 'Deposit', 'Hyderabad', 19),
(70, 43, '2024-04-22 11:48:55', 451151.52, 'Deposit', 'Berlin', 45),
(71, 109, '2025-01-07 18:18:37', 52020.91, 'ATM Withdrawal', 'Dubai', 53),
(72, 102, '2024-12-29 08:13:44', 4326.28, 'Transfer', 'Delhi', 40),
(73, 49, '2024-10-26 01:53:45', 59041.25, 'Purchase', 'Manchester', 33),
(74, 4, '2024-03-05 22:24:32', 11114.38, 'Transfer', 'Berlin', 57),
(75, 26, '2024-08-31 06:04:56', 19417.64, 'Withdrawal', 'Hyderabad', 5),
(76, 108, '2024-05-02 17:24:09', 34389.21, 'ATM Withdrawal', 'London', 49),
(77, 44, '2024-01-23 18:41:03', 15894.6, 'Transfer', 'Berlin', 24),
(78, 78, '2024-09-06 14:38:36', 55360.45, 'ATM Withdrawal', 'Berlin', 57),
(79, 28, '2024-04-17 02:12:15', 61894.87, 'Deposit', 'Hyderabad', 55),
(80, 60, '2024-05-31 06:10:29', 82132.18, 'Purchase', 'London', 26),
(81, 124, '2024-08-26 02:47:06', 57944.12, 'Transfer', 'Singapore', 56),
(82, 66, '2024-11-01 14:05:53', 47313.33, 'ATM Withdrawal', 'Dubai', 11),
(83, 117, '2024-07-21 23:23:26', 76769.88, 'Bill Payment', 'Abu Dhabi', 54),
(84, 27, '2025-03-06 13:25:33', 80890.36, 'Transfer', 'Dubai', 11),
(85, 120, '2024-07-13 16:48:48', 59421.45, 'Bill Payment', 'Berlin', 32),
(86, 28, '2024-05-25 02:31:51', 65044.34, 'Bill Payment', 'Abu Dhabi', 30),
(87, 44, '2024-02-22 01:18:48', 69825.11, 'Transfer', 'New York', 38),
(88, 69, '2024-01-05 03:33:12', 69758.75, 'Deposit', 'Berlin', 27),
(89, 16, '2024-12-23 00:34:02', 744458.69, 'Purchase', 'Berlin', 15),
(90, 76, '2025-04-09 05:24:55', 30488.56, 'Withdrawal', 'Chicago', 48),
(91, 57, '2024-11-22 08:40:31', 30090.22, 'Bill Payment', 'Munich', 6),
(92, 39, '2024-11-01 10:45:34', 77873.58, 'Purchase', 'Singapore', 42),
(93, 45, '2024-03-28 00:43:16', 74200.18, 'Purchase', 'London', 8),
(94, 89, '2025-04-28 19:21:55', 5016.62, 'Transfer', 'Hyderabad', 19),
(95, 75, '2024-06-10 05:30:30', 75496.62, 'Transfer', 'Manchester', 29),
(96, 43, '2024-11-12 10:27:29', 22067.4, 'Purchase', 'Hyderabad', 19),
(97, 129, '2024-07-10 04:18:37', 74599.05, 'Transfer', 'Manchester', 12),
(98, 77, '2024-07-05 23:01:45', 45398.66, 'Transfer', 'London', 49),
(99, 23, '2024-08-06 01:07:24', 49467.85, 'Withdrawal', 'Berlin', 27),
(100, 88, '2025-03-07 18:33:35', 64229.58, 'Purchase', 'Munich', 37),
(101, 2, '2024-10-01 05:05:53', 33797.21, 'Bill Payment', 'Berlin', 13),
(102, 27, '2024-07-02 12:04:07', 22348.44, 'Transfer', 'Bangalore', 43),
(103, 16, '2024-04-03 13:08:28', 84920.45, 'Purchase', 'Hyderabad', 19),
(104, 129, '2024-05-25 02:08:08', 2058.5, 'Transfer', 'Berlin', 15),
(105, 96, '2024-09-17 14:13:48', 73480.91, 'ATM Withdrawal', 'London', 8),
(106, 100, '2024-01-10 05:28:54', 26778.56, 'Bill Payment', 'Munich', 6),
(107, 96, '2024-10-15 07:35:15', 15012.55, 'Deposit', 'New York', 38),
(108, 44, '2025-02-12 10:09:35', 22341.51, 'Transfer', 'Singapore', 3),
(109, 60, '2024-12-25 09:25:47', 347042.54, 'Deposit', 'Singapore', 1),
(110, 23, '2024-03-07 16:45:44', 25034.43, 'Purchase', 'Berlin', 32),
(111, 89, '2024-09-06 16:47:45', 53930.17, 'Bill Payment', 'Dubai', 25),
(112, 90, '2025-03-20 10:14:45', 45565.12, 'ATM Withdrawal', 'Abu Dhabi', 54),
(113, 82, '2024-03-19 23:02:50', 22052.9, 'Transfer', 'Chennai', 46),
(114, 102, '2024-05-16 11:34:56', 49563.02, 'Bill Payment', 'Hyderabad', 55),
(115, 3, '2024-06-21 09:03:26', 18264.18, 'Purchase', 'Bangalore', 43),
(116, 42, '2024-12-01 08:44:05', 66661.24, 'Bill Payment', 'Singapore', 3),
(117, 118, '2024-01-13 14:02:20', 32668.47, 'Bill Payment', 'Berlin', 27),
(118, 123, '2024-12-03 07:55:34', 70530.11, 'Withdrawal', 'Mumbai', 10),
(119, 121, '2025-01-16 08:04:56', 16351.02, 'Deposit', 'Abu Dhabi', 54),
(120, 111, '2024-03-27 05:42:38', 57605.3, 'Transfer', 'Singapore', 17),
(121, 93, '2024-08-15 06:57:09', 44182.89, 'ATM Withdrawal', 'London', 49),
(122, 112, '2024-02-16 02:44:18', 50237.75, 'Purchase', 'Singapore', 41),
(123, 103, '2024-06-11 16:22:17', 29867.16, 'ATM Withdrawal', 'Berlin', 15),
(124, 9, '2025-01-14 15:44:10', 18901.28, 'Withdrawal', 'Dubai', 25),
(125, 85, '2024-06-02 06:45:55', 80925.37, 'Transfer', 'Berlin', 15),
(126, 33, '2024-11-19 02:49:50', 64148.63, 'Withdrawal', 'Abu Dhabi', 23),
(127, 32, '2024-09-27 09:52:41', 42597.06, 'Withdrawal', 'Singapore', 1),
(128, 81, '2024-07-10 06:38:45', 68562.46, 'Deposit', 'Berlin', 27),
(129, 74, '2024-08-11 09:46:18', 43830.27, 'Deposit', 'Chicago', 48),
(130, 60, '2024-03-29 01:57:43', 62775.43, 'Transfer', 'Berlin', 24),
(131, 106, '2024-02-02 00:22:32', 65824.42, 'Deposit', 'Dubai', 11),
(132, 40, '2024-12-08 11:44:42', 79510.35, 'ATM Withdrawal', 'Berlin', 15),
(133, 43, '2024-02-14 10:21:44', 18528.57, 'Purchase', 'Berlin', 32),
(134, 84, '2024-09-06 20:23:28', 18133.59, 'Bill Payment', 'Dubai', 51),
(135, 11, '2024-07-07 20:35:08', 80199.71, 'Deposit', 'Chicago', 2),
(136, 23, '2025-02-10 20:11:26', 21886.0, 'Purchase', 'Berlin', 60),
(137, 104, '2024-07-03 16:00:10', 53019.13, 'Bill Payment', 'Abu Dhabi', 30),
(138, 29, '2024-08-13 09:19:22', 62085.68, 'ATM Withdrawal', 'Manchester', 9),
(139, 121, '2024-10-20 02:12:03', 78287.42, 'Bill Payment', 'London', 58),
(140, 12, '2024-06-26 15:44:02', 55209.71, 'ATM Withdrawal', 'New York', 38),
(141, 15, '2025-01-20 19:02:10', 80478.05, 'Transfer', 'London', 26),
(142, 74, '2025-03-21 02:00:18', 11010.89, 'ATM Withdrawal', 'Berlin', 32),
(143, 92, '2024-04-08 17:49:10', 30232.5, 'Purchase', 'Manchester', 18),
(144, 88, '2025-01-20 05:11:13', 3854.55, 'Deposit', 'Manchester', 33),
(145, 37, '2025-03-26 20:14:35', 35385.31, 'Deposit', 'New York', 34),
(146, 88, '2025-01-19 21:56:32', 42900.5, 'Deposit', 'London', 26),
(147, 85, '2024-03-14 14:53:12', 75804.1, 'Bill Payment', 'Dubai', 11),
(148, 54, '2024-09-09 01:24:09', 20689.45, 'Bill Payment', 'Berlin', 32),
(149, 25, '2024-04-12 10:37:07', 1214.9, 'Transfer', 'Singapore', 3),
(150, 10, '2024-05-17 01:37:52', 18064.47, 'Withdrawal', 'London', 49),
(151, 91, '2024-05-17 09:10:17', 22236.6, 'Withdrawal', 'Manchester', 18),
(152, 72, '2024-05-20 03:34:34', 49086.52, 'Purchase', 'Manchester', 12),
(153, 55, '2025-01-08 19:25:24', 33119.62, 'Purchase', 'London', 58),
(154, 65, '2025-04-12 11:46:16', 44171.42, 'Withdrawal', 'San Francisco', 31),
(155, 17, '2024-01-28 17:19:53', 81929.69, 'Transfer', 'Berlin', 45),
(156, 37, '2024-06-05 05:26:50', 533122.76, 'Transfer', 'Manchester', 12),
(157, 102, '2024-05-19 18:40:09', 73504.38, 'Deposit', 'Manchester', 7),
(158, 108, '2025-03-08 22:29:18', 70594.84, 'Withdrawal', 'Singapore', 44),
(159, 55, '2024-05-12 09:18:02', 9798.24, 'Purchase', 'Abu Dhabi', 47),
(160, 130, '2024-08-31 08:00:50', 72493.48, 'Deposit', 'Berlin', 57),
(161, 88, '2024-01-30 07:04:26', 663.27, 'Purchase', 'Manchester', 18),
(162, 82, '2024-03-22 15:13:13', 74167.85, 'Withdrawal', 'Dubai', 51),
(163, 86, '2024-05-29 16:57:05', 27368.17, 'Deposit', 'Berlin', 20),
(164, 64, '2024-12-14 08:09:41', 7552.17, 'Withdrawal', 'Chicago', 48),
(165, 99, '2024-10-27 13:51:36', 80388.16, 'Purchase', 'Manchester', 18),
(166, 103, '2024-08-26 01:11:39', 73701.25, 'Withdrawal', 'Singapore', 21),
(167, 98, '2024-12-29 11:39:00', 72585.19, 'Withdrawal', 'Berlin', 15),
(168, 103, '2024-08-08 14:56:21', 46899.23, 'Purchase', 'Berlin', 13),
(169, 77, '2024-02-09 01:54:11', 26339.01, 'Withdrawal', 'Hyderabad', 16),
(170, 28, '2024-09-28 12:15:39', 32578.41, 'ATM Withdrawal', 'Dubai', 14),
(171, 59, '2024-02-26 08:40:57', 40795.6, 'Purchase', 'Chennai', 46),
(172, 111, '2024-08-06 09:00:41', 40010.64, 'Purchase', 'Manchester', 9),
(173, 81, '2024-01-01 12:16:25', 66500.27, 'Transfer', 'Berlin', 57),
(174, 60, '2024-06-17 15:08:03', 24853.62, 'Purchase', 'Singapore', 36),
(175, 73, '2024-08-10 13:38:17', 5808.26, 'Transfer', 'Singapore', 44),
(176, 73, '2025-01-26 09:34:52', 84352.44, 'Bill Payment', 'Hyderabad', 19),
(177, 96, '2024-09-10 23:13:18', 78846.98, 'Purchase', 'Dubai', 51),
(178, 48, '2025-03-15 09:30:43', 121083.97, 'Deposit', 'Abu Dhabi', 23),
(179, 126, '2024-01-07 20:21:05', 49894.74, 'Transfer', 'Delhi', 40),
(180, 93, '2024-02-24 14:07:59', 65335.01, 'ATM Withdrawal', 'Munich', 37),
(181, 67, '2025-03-13 13:15:22', 52044.77, 'Deposit', 'Hyderabad', 5),
(182, 77, '2024-01-16 19:19:16', 76411.05, 'Bill Payment', 'Chicago', 2),
(183, 85, '2024-02-24 14:26:36', 65009.59, 'Deposit', 'Manchester', 33),
(184, 118, '2024-06-29 07:15:27', 33285.2, 'Withdrawal', 'Dubai', 51),
(185, 15, '2024-01-06 13:45:50', 61262.82, 'Bill Payment', 'Hyderabad', 19),
(186, 20, '2025-04-17 13:14:52', 50265.17, 'Withdrawal', 'San Francisco', 4),
(187, 128, '2025-04-26 00:52:40', 1194.83, 'Withdrawal', 'London', 49),
(188, 96, '2024-04-10 05:45:44', 61926.66, 'Purchase', 'Berlin', 32),
(189, 18, '2024-01-31 11:42:36', 631967.98, 'Deposit', 'Manchester', 12),
(190, 99, '2024-12-28 22:45:13', 73437.3, 'ATM Withdrawal', 'Abu Dhabi', 54),
(191, 14, '2024-01-05 00:12:19', 65535.77, 'Deposit', 'Manchester', 9),
(192, 128, '2024-05-15 22:53:19', 79471.78, 'ATM Withdrawal', 'Dubai', 51),
(193, 18, '2024-08-07 15:06:11', 30404.85, 'Bill Payment', 'Munich', 52),
(194, 20, '2024-03-07 15:10:25', 45517.8, 'Purchase', 'Manchester', 33),
(195, 87, '2024-11-17 05:33:02', 417487.24, 'Transfer', 'Singapore', 3),
(196, 9, '2025-01-21 01:00:50', 59309.15, 'Withdrawal', 'Berlin', 32),
(197, 4, '2025-01-03 15:23:00', 51385.07, 'Purchase', 'Manchester', 18),
(198, 101, '2024-04-02 11:53:23', 24529.66, 'ATM Withdrawal', 'Berlin', 20),
(199, 36, '2024-07-12 11:16:23', 28254.11, 'ATM Withdrawal', 'Berlin', 20),
(200, 59, '2024-03-31 08:01:31', 3311.18, 'Transfer', 'London', 26),
(201, 85, '2024-09-07 20:45:25', 77773.05, 'Bill Payment', 'Munich', 37),
(202, 112, '2024-11-15 13:08:45', 60287.81, 'Deposit', 'Berlin', 20),
(203, 94, '2024-09-04 09:47:33', 73272.12, 'ATM Withdrawal', 'London', 49),
(204, 17, '2024-06-19 23:03:33', 23003.95, 'Bill Payment', 'Berlin', 32),
(205, 121, '2024-10-19 07:46:41', 57564.61, 'Purchase', 'Abu Dhabi', 54),
(206, 77, '2024-04-03 12:42:36', 38321.83, 'Deposit', 'Singapore', 44),
(207, 41, '2025-04-17 15:31:51', 70299.1, 'Bill Payment', 'Singapore', 3),
(208, 64, '2024-10-02 18:45:48', 17031.46, 'Purchase', 'Singapore', 36),
(209, 79, '2024-08-15 05:58:29', 1839.16, 'Deposit', 'Berlin', 20),
(210, 87, '2024-10-26 23:45:37', 66425.68, 'Purchase', 'Munich', 52),
(211, 67, '2024-02-17 17:35:40', 53538.63, 'Transfer', 'Manchester', 18),
(212, 124, '2025-04-12 16:07:47', 71086.92, 'Bill Payment', 'Chennai', 46),
(213, 106, '2024-06-10 12:34:06', 3427.06, 'Deposit', 'Dallas', 22),
(214, 52, '2024-12-30 11:46:55', 55050.58, 'Transfer', 'Berlin', 39),
(215, 26, '2024-01-27 17:53:45', 72148.96, 'Deposit', 'Hyderabad', 16),
(216, 95, '2024-12-12 17:48:18', 8174.8, 'Purchase', 'London', 28),
(217, 96, '2024-07-30 20:27:52', 34296.74, 'ATM Withdrawal', 'Singapore', 42),
(218, 62, '2025-01-08 01:43:34', 11101.21, 'ATM Withdrawal', 'Singapore', 41),
(219, 100, '2024-01-20 10:13:58', 72783.35, 'Withdrawal', 'Abu Dhabi', 30),
(220, 55, '2024-05-12 14:26:51', 28967.37, 'Transfer', 'Abu Dhabi', 23),
(221, 60, '2024-10-01 05:27:32', 39529.91, 'Deposit', 'New York', 38),
(222, 19, '2024-01-11 06:11:22', 19247.81, 'Purchase', 'Manchester', 29),
(223, 85, '2024-07-30 07:54:40', 41311.48, 'ATM Withdrawal', 'Singapore', 42),
(224, 104, '2024-02-13 02:45:34', 31773.57, 'Transfer', 'Singapore', 3),
(225, 130, '2025-03-15 03:28:01', 16725.55, 'Purchase', 'Singapore', 21),
(226, 12, '2025-04-11 05:47:27', 31662.52, 'ATM Withdrawal', 'Singapore', 3),
(227, 60, '2024-07-20 22:21:35', 39603.67, 'Bill Payment', 'Manchester', 29),
(228, 99, '2024-03-12 04:24:03', 56543.15, 'Purchase', 'Berlin', 27),
(229, 25, '2024-05-26 01:46:59', 26699.22, 'Transfer', 'Singapore', 3),
(230, 54, '2025-01-08 02:56:39', 26848.59, 'ATM Withdrawal', 'Munich', 52),
(231, 8, '2024-08-27 00:02:11', 38447.91, 'Purchase', 'Munich', 52),
(232, 92, '2025-02-20 10:10:35', 9970.87, 'ATM Withdrawal', 'Mumbai', 10),
(233, 23, '2025-01-01 02:21:07', 122006.69, 'Transfer', 'Munich', 6),
(234, 85, '2025-01-18 16:24:23', 874.47, 'Transfer', 'London', 49),
(235, 52, '2024-09-19 23:01:14', 19844.22, 'Withdrawal', 'Manchester', 12),
(236, 71, '2024-08-21 22:37:02', 15261.26, 'Bill Payment', 'Singapore', 3),
(237, 88, '2024-12-13 00:17:04', 48449.46, 'ATM Withdrawal', 'Chennai', 46),
(238, 73, '2024-02-29 17:08:37', 33652.98, 'Deposit', 'Singapore', 56),
(239, 45, '2024-02-18 08:07:41', 648.97, 'Withdrawal', 'Chicago', 48),
(240, 103, '2024-05-30 05:27:26', 71551.83, 'ATM Withdrawal', 'Singapore', 44),
(241, 19, '2025-03-10 10:28:56', 72641.87, 'Purchase', 'Abu Dhabi', 35),
(242, 65, '2025-04-22 16:04:33', 38916.76, 'Withdrawal', 'London', 28),
(243, 102, '2024-05-19 22:52:49', 83130.35, 'Deposit', 'Berlin', 45),
(244, 130, '2024-06-08 01:49:19', 58617.38, 'Withdrawal', 'Manchester', 29),
(245, 104, '2025-01-11 10:37:01', 5150.14, 'Withdrawal', 'Berlin', 13),
(246, 4, '2024-06-05 18:23:18', 33238.05, 'Bill Payment', 'Berlin', 60),
(247, 109, '2024-11-05 19:50:34', 25508.49, 'Transfer', 'Hyderabad', 16),
(248, 72, '2025-01-15 06:19:17', 5894.77, 'Deposit', 'Manchester', 33),
(249, 33, '2025-01-14 05:11:23', 17728.39, 'Purchase', 'Berlin', 20),
(250, 38, '2025-01-01 19:56:14', 18085.86, 'Purchase', 'Dallas', 22),
(251, 112, '2024-01-23 19:55:13', 46241.16, 'ATM Withdrawal', 'Abu Dhabi', 47),
(252, 22, '2025-04-11 13:24:56', 54391.69, 'Deposit', 'Dubai', 14),
(253, 91, '2024-03-14 09:01:21', 26308.91, 'Bill Payment', 'Berlin', 45),
(254, 55, '2024-01-30 12:31:11', 13286.57, 'Bill Payment', 'Munich', 52),
(255, 6, '2024-05-01 20:02:43', 62811.19, 'Transfer', 'Hyderabad', 55),
(256, 82, '2024-08-18 18:39:43', 1363.94, 'Bill Payment', 'Singapore', 42),
(257, 91, '2024-12-26 08:47:24', 74950.97, 'Withdrawal', 'Dallas', 59),
(258, 31, '2025-01-14 23:08:15', 28160.22, 'Bill Payment', 'Berlin', 57),
(259, 32, '2025-03-17 19:08:47', 54836.41, 'Bill Payment', 'Abu Dhabi', 30),
(260, 1, '2024-05-22 10:58:13', 47470.77, 'Bill Payment', 'London', 49),
(261, 66, '2025-03-29 20:01:28', 82509.55, 'Transfer', 'Singapore', 21),
(262, 55, '2024-01-23 14:21:40', 9418.03, 'Purchase', 'Abu Dhabi', 23),
(263, 40, '2025-04-21 19:00:06', 64032.8, 'ATM Withdrawal', 'Dallas', 22),
(264, 38, '2024-05-20 06:40:11', 81300.94, 'Purchase', 'Munich', 52),
(265, 74, '2025-04-03 02:33:58', 70990.3, 'Purchase', 'Chicago', 48),
(266, 98, '2024-05-27 20:46:23', 44172.62, 'Deposit', 'San Francisco', 31),
(267, 110, '2024-07-28 14:22:35', 76887.38, 'Deposit', 'Berlin', 20),
(268, 48, '2025-02-20 18:23:51', 58811.9, 'ATM Withdrawal', 'Abu Dhabi', 35),
(269, 13, '2024-07-06 23:55:52', 51629.02, 'Deposit', 'Chennai', 46),
(270, 41, '2025-03-03 03:02:10', 68133.39, 'Transfer', 'Dubai', 25),
(271, 129, '2025-03-12 10:14:44', 699495.22, 'Withdrawal', 'Manchester', 9),
(272, 44, '2024-09-20 18:42:34', 68359.14, 'Deposit', 'Berlin', 24),
(273, 123, '2025-04-06 09:35:58', 80888.35, 'Purchase', 'Singapore', 50),
(274, 25, '2024-05-04 15:40:26', 82894.33, 'Transfer', 'Hyderabad', 16),
(275, 5, '2024-05-05 04:24:47', 68153.15, 'Bill Payment', 'Singapore', 50),
(276, 51, '2025-02-09 09:13:50', 351506.13, 'Deposit', 'Abu Dhabi', 47),
(277, 60, '2024-07-12 16:58:12', 80921.29, 'Deposit', 'Abu Dhabi', 54),
(278, 98, '2025-01-02 13:52:07', 15689.86, 'Bill Payment', 'Berlin', 60),
(279, 70, '2024-01-23 10:39:13', 56600.01, 'Purchase', 'Singapore', 44),
(280, 129, '2024-01-25 20:26:31', 64532.16, 'ATM Withdrawal', 'Mumbai', 10),
(281, 103, '2024-05-06 17:16:55', 19214.96, 'Transfer', 'Bangalore', 43),
(282, 85, '2024-04-18 18:48:06', 80131.65, 'Transfer', 'Hyderabad', 19),
(283, 83, '2024-03-02 00:57:10', 61037.88, 'Purchase', 'Singapore', 44),
(284, 44, '2024-09-06 15:15:04', 131737.64, 'Transfer', 'Singapore', 50),
(285, 78, '2024-02-05 17:00:40', 5056.2, 'Purchase', 'Munich', 52),
(286, 13, '2024-04-10 05:27:05', 34256.19, 'Purchase', 'Singapore', 36),
(287, 82, '2024-05-14 04:17:20', 60376.8, 'Withdrawal', 'Dubai', 53),
(288, 79, '2024-10-28 19:02:34', 41587.14, 'Deposit', 'Abu Dhabi', 35),
(289, 127, '2025-02-23 20:18:06', 17086.37, 'ATM Withdrawal', 'Berlin', 60),
(290, 111, '2025-01-03 18:45:06', 76064.0, 'Withdrawal', 'Manchester', 9),
(291, 32, '2025-04-18 09:40:43', 60778.05, 'Withdrawal', 'New York', 34),
(292, 11, '2024-10-24 11:04:43', 65940.57, 'Purchase', 'Abu Dhabi', 35),
(293, 24, '2024-03-23 09:13:11', 22688.32, 'Transfer', 'Hyderabad', 19),
(294, 43, '2024-05-10 19:18:24', 23789.2, 'Deposit', 'Manchester', 33),
(295, 26, '2024-08-06 20:06:09', 10322.98, 'Withdrawal', 'Chicago', 2),
(296, 36, '2024-07-09 07:14:02', 5743.17, 'Transfer', 'New York', 34),
(297, 79, '2025-01-10 18:23:21', 19503.48, 'Withdrawal', 'Munich', 52),
(298, 36, '2024-10-24 01:31:52', 41880.03, 'Bill Payment', 'Hyderabad', 19),
(299, 106, '2024-09-25 21:39:44', 9230.56, 'ATM Withdrawal', 'Manchester', 12),
(300, 90, '2025-02-25 03:40:31', 303480.74, 'Bill Payment', 'Hyderabad', 19),
(301, 45, '2024-07-11 12:21:07', 59742.0, 'Deposit', 'Berlin', 45),
(302, 41, '2024-06-22 01:20:43', 28813.94, 'Withdrawal', 'New York', 34),
(303, 50, '2024-06-23 05:22:38', 19257.33, 'Deposit', 'Hyderabad', 55),
(304, 35, '2024-01-15 23:45:13', 34948.26, 'Bill Payment', 'Singapore', 1),
(305, 34, '2024-05-31 15:36:09', 29498.48, 'Deposit', 'London', 58),
(306, 111, '2025-03-06 17:18:35', 41997.29, 'Deposit', 'Singapore', 17),
(307, 37, '2024-12-07 04:29:42', 46581.31, 'Bill Payment', 'Delhi', 40),
(308, 116, '2024-03-21 23:38:49', 56571.41, 'Bill Payment', 'Singapore', 21),
(309, 28, '2024-07-21 14:23:00', 5603.57, 'Withdrawal', 'Hyderabad', 16),
(310, 57, '2025-04-18 11:22:14', 79594.54, 'Deposit', 'Berlin', 57),
(311, 95, '2024-01-13 15:08:22', 67481.09, 'Bill Payment', 'Singapore', 1),
(312, 85, '2024-11-16 20:06:31', 38957.5, 'Withdrawal', 'Singapore', 1),
(313, 30, '2024-05-27 00:39:23', 9400.75, 'Deposit', 'Berlin', 39),
(314, 119, '2025-01-29 01:01:50', 26746.39, 'Withdrawal', 'Chennai', 46);


INSERT INTO FraudAlerts (alert_id, transaction_id, account_id, user_id, alert_type, alert_date, risk_score) 
VALUES
(1, 133, 43, 2, 'Foreign Transaction', '2024-02-14 11:19:44', 44.51),
(2, 34, 125, 58, 'Rapid Transactions', '2025-01-15 22:18:43', 51.99),
(3, 223, 85, 44, 'Rapid Transactions', '2024-07-30 08:51:40', 86.68),
(4, 58, 71, 13, 'Multiple Failed Logins', '2024-09-14 22:31:19', 43.43),
(5, 257, 91, 25, 'Multiple Failed Logins', '2024-12-26 08:58:24', 80.05),
(6, 205, 121, 48, 'Foreign Transaction', '2024-10-19 08:36:41', 82.63),
(7, 26, 39, 2, 'Suspicious Location', '2024-02-15 05:49:38', 86.93),
(8, 10, 130, 45, 'Rapid Transactions', '2024-04-22 11:53:19', 43.99),
(9, 243, 102, 48, 'Rapid Transactions', '2024-05-19 22:57:49', 49.29),
(10, 225, 130, 45, 'Foreign Transaction', '2025-03-15 03:29:01', 51.13),
(11, 279, 70, 64, 'Device Mismatch', '2024-01-23 10:41:13', 50.13),
(12, 203, 94, 42, 'High Amount', '2024-09-04 10:00:33', 40.01),
(13, 239, 45, 41, 'Rapid Transactions', '2024-02-18 09:04:41', 77.44),
(14, 46, 85, 44, 'Rapid Transactions', '2024-02-20 23:46:37', 65.07),
(15, 77, 44, 12, 'Suspicious Location', '2024-01-23 19:10:03', 53.6),
(16, 198, 101, 30, 'Multiple Failed Logins', '2024-04-02 12:46:23', 46.73),
(17, 43, 37, 41, 'Device Mismatch', '2024-04-28 22:08:36', 85.07),
(18, 177, 96, 17, 'Device Mismatch', '2024-09-10 23:25:18', 77.85),
(19, 178, 48, 73, 'Rapid Transactions', '2025-03-15 09:37:43', 77.86),
(20, 153, 55, 42, 'Multiple Failed Logins', '2025-01-08 19:37:24', 65.77),
(21, 6, 23, 66, 'Device Mismatch', '2024-11-08 23:51:20', 82.61),
(22, 127, 32, 66, 'Device Mismatch', '2024-09-27 10:36:41', 57.19),
(23, 47, 58, 16, 'Foreign Transaction', '2024-09-04 05:22:55', 80.79),
(24, 140, 12, 49, 'Multiple Failed Logins', '2024-06-26 16:33:02', 40.22),
(25, 295, 26, 57, 'Device Mismatch', '2024-08-06 20:07:09', 57.44),
(26, 120, 111, 31, 'Device Mismatch', '2024-03-27 05:51:38', 43.52),
(27, 288, 79, 66, 'Device Mismatch', '2024-10-28 19:35:34', 85.14),
(28, 219, 100, 44, 'High Amount', '2024-01-20 11:01:58', 61.27),
(29, 148, 54, 50, 'Rapid Transactions', '2024-09-09 01:53:09', 88.71),
(30, 155, 17, 53, 'Device Mismatch', '2024-01-28 17:50:53', 55.86),
(31, 173, 81, 67, 'Foreign Transaction', '2024-01-01 13:10:25', 60.26),
(32, 79, 28, 75, 'Rapid Transactions', '2024-04-17 02:24:15', 60.35),
(33, 145, 37, 41, 'Rapid Transactions', '2025-03-26 21:11:35', 71.47),
(34, 207, 41, 19, 'High Amount', '2025-04-17 16:16:51', 51.02),
(35, 280, 129, 76, 'High Amount', '2024-01-25 21:01:31', 48.64),
(36, 276, 51, 76, 'High Amount', '2025-02-09 09:55:50', 88.88),
(37, 232, 92, 63, 'Foreign Transaction', '2025-02-20 10:21:35', 56.26),
(38, 4, 99, 6, 'Device Mismatch', '2024-02-11 02:56:18', 61.97),
(39, 61, 17, 53, 'Suspicious Location', '2024-04-29 22:32:03', 52.29),
(40, 156, 37, 41, 'Foreign Transaction', '2024-06-05 06:01:50', 90.94),
(41, 78, 78, 35, 'Rapid Transactions', '2024-09-06 15:10:36', 59.9),
(42, 83, 117, 77, 'Rapid Transactions', '2024-07-22 00:14:26', 63.24),
(43, 76, 108, 37, 'Foreign Transaction', '2024-05-02 17:39:09', 53.08),
(44, 181, 67, 54, 'Device Mismatch', '2025-03-13 13:29:22', 68.71),
(45, 18, 97, 74, 'Rapid Transactions', '2024-03-11 18:31:30', 80.61),
(46, 180, 93, 71, 'Foreign Transaction', '2024-02-24 15:03:59', 58.5),
(47, 164, 64, 26, 'Device Mismatch', '2024-12-14 08:48:41', 66.34),
(48, 301, 45, 41, 'Foreign Transaction', '2024-07-11 12:56:07', 47.03),
(49, 25, 115, 68, 'Device Mismatch', '2024-05-21 21:55:36', 51.58),
(50, 95, 75, 15, 'Suspicious Location', '2024-06-10 06:26:30', 86.6),
(51, 204, 17, 53, 'Device Mismatch', '2024-06-19 23:32:33', 62.37),
(52, 293, 24, 35, 'Foreign Transaction', '2024-03-23 09:23:11', 56.14),
(53, 235, 52, 13, 'Foreign Transaction', '2024-09-19 23:16:14', 48.86),
(54, 115, 3, 3, 'Foreign Transaction', '2024-06-21 09:33:26', 47.32),
(55, 112, 90, 29, 'Multiple Failed Logins', '2025-03-20 10:44:45', 60.88),
(56, 8, 35, 14, 'Foreign Transaction', '2024-12-13 20:40:02', 89.8),
(57, 292, 11, 37, 'Device Mismatch', '2024-10-24 11:42:43', 69.07),
(58, 85, 120, 55, 'High Amount', '2024-07-13 17:14:48', 49.9),
(59, 91, 57, 18, 'Suspicious Location', '2024-11-22 08:44:31', 45.5),
(60, 64, 130, 45, 'Rapid Transactions', '2024-09-29 17:25:03', 71.05),
(61, 147, 85, 44, 'Device Mismatch', '2024-03-14 15:47:12', 67.29),
(62, 117, 118, 28, 'High Amount', '2024-01-13 14:57:20', 61.59),
(63, 184, 118, 28, 'Suspicious Location', '2024-06-29 07:35:27', 61.62),
(64, 114, 102, 48, 'Multiple Failed Logins', '2024-05-16 12:17:56', 46.8),
(65, 102, 27, 61, 'Multiple Failed Logins', '2024-07-02 12:07:07', 81.11);


INSERT INTO AuditLogs (log_id, user_id, device_id, login_time, login_status) 
VALUES
(1, 80, 21, '2024-05-09 09:14:31', 'Success'),
(2, 30, 2, '2024-10-08 06:36:48', 'Failed Password'),
(3, 42, 19, '2025-04-15 08:06:25', 'Suspicious Device'),
(4, 45, 36, '2024-11-12 15:43:34', 'OTP Failed'),
(5, 23, 51, '2024-06-22 14:12:47', 'Suspicious Device'),
(6, 76, 9, '2025-03-14 02:33:49', 'Success'),
(7, 19, 32, '2024-03-10 04:51:07', 'Suspicious Device'),
(8, 52, 36, '2025-04-04 20:09:32', 'Success'),
(9, 52, 35, '2024-03-26 07:06:02', 'Suspicious Device'),
(10, 45, 34, '2024-01-31 06:25:25', 'Failed Password'),
(11, 17, 55, '2024-05-01 23:10:10', 'OTP Failed'),
(12, 35, 31, '2024-09-20 16:33:47', 'OTP Failed'),
(13, 46, 17, '2024-08-08 03:18:54', 'Failed Password'),
(14, 11, 48, '2024-11-05 14:44:40', 'OTP Failed'),
(15, 74, 50, '2024-06-26 16:18:23', 'Failed Password'),
(16, 35, 7, '2024-09-20 06:48:11', 'Account Locked'),
(17, 70, 52, '2024-08-10 02:56:50', 'OTP Failed'),
(18, 44, 18, '2024-08-28 08:59:03', 'Success'),
(19, 42, 33, '2025-03-05 02:47:20', 'Success'),
(20, 34, 11, '2025-01-04 00:30:50', 'Suspicious Device'),
(21, 58, 20, '2025-04-27 10:15:23', 'OTP Failed'),
(22, 36, 10, '2025-03-07 01:20:10', 'Success'),
(23, 78, 41, '2025-01-15 17:45:14', 'Account Locked'),
(24, 47, 59, '2024-07-27 03:44:21', 'Suspicious Device'),
(25, 59, 40, '2024-11-02 19:56:44', 'Suspicious Device'),
(26, 11, 29, '2025-03-18 14:23:15', 'OTP Failed'),
(27, 54, 14, '2024-10-24 07:57:10', 'Failed Password'),
(28, 35, 43, '2024-07-13 03:21:48', 'Suspicious Device'),
(29, 49, 38, '2024-08-02 11:27:22', 'Account Locked'),
(30, 24, 52, '2024-05-26 17:51:55', 'Account Locked'),
(31, 71, 7, '2025-03-10 18:02:35', 'Account Locked'),
(32, 10, 18, '2024-09-16 04:48:34', 'Success'),
(33, 25, 52, '2025-02-20 20:54:01', 'Success'),
(34, 38, 21, '2024-04-26 13:20:28', 'Success'),
(35, 19, 10, '2024-10-25 06:37:01', 'Success'),
(36, 17, 46, '2025-04-14 19:57:25', 'Success'),
(37, 40, 52, '2025-02-23 17:53:37', 'OTP Failed'),
(38, 33, 1, '2024-01-15 16:40:20', 'Success'),
(39, 21, 58, '2024-04-08 00:08:00', 'Success'),
(40, 21, 25, '2024-04-21 02:35:12', 'Success'),
(41, 66, 30, '2025-04-06 16:46:04', 'Suspicious Device'),
(42, 39, 42, '2024-06-03 18:44:16', 'Success'),
(43, 9, 29, '2024-12-29 09:12:21', 'Success'),
(44, 20, 60, '2024-06-25 12:40:50', 'Success'),
(45, 43, 10, '2024-02-05 02:31:04', 'Failed Password'),
(46, 65, 11, '2025-02-16 05:01:25', 'Success'),
(47, 56, 6, '2024-12-15 19:44:53', 'Account Locked'),
(48, 15, 51, '2025-02-19 18:42:05', 'Success'),
(49, 45, 18, '2024-07-13 08:03:16', 'OTP Failed'),
(50, 37, 25, '2024-08-08 11:50:29', 'OTP Failed'),
(51, 24, 42, '2024-08-25 07:39:10', 'Success'),
(52, 61, 3, '2025-03-26 08:36:51', 'Account Locked'),
(53, 28, 58, '2024-05-25 13:28:16', 'Success'),
(54, 2, 52, '2024-01-05 18:40:47', 'OTP Failed'),
(55, 18, 27, '2025-02-06 23:15:57', 'Success'),
(56, 57, 18, '2024-04-03 10:19:49', 'Suspicious Device'),
(57, 21, 54, '2024-05-14 11:26:13', 'Success'),
(58, 62, 56, '2024-04-13 09:28:38', 'Success'),
(59, 34, 4, '2024-12-30 18:44:03', 'Success'),
(60, 51, 6, '2025-03-14 07:49:36', 'Success'),
(61, 22, 2, '2024-12-26 12:08:43', 'Success'),
(62, 78, 39, '2024-07-21 15:50:04', 'Success'),
(63, 55, 50, '2024-09-23 05:53:10', 'Failed Password'),
(64, 54, 49, '2024-09-17 17:12:58', 'Failed Password'),
(65, 37, 16, '2024-07-15 14:08:16', 'Success'),
(66, 17, 13, '2024-01-07 23:36:00', 'Suspicious Device'),
(67, 24, 41, '2024-04-30 03:12:20', 'Success'),
(68, 7, 47, '2025-04-27 13:42:12', 'OTP Failed'),
(69, 69, 58, '2025-03-21 20:45:15', 'Success'),
(70, 2, 26, '2024-12-12 04:43:17', 'Success'),
(71, 79, 1, '2025-03-09 17:20:57', 'Account Locked'),
(72, 59, 47, '2024-12-07 16:16:56', 'Success'),
(73, 54, 40, '2024-09-25 15:13:11', 'Success'),
(74, 28, 37, '2024-09-19 05:02:22', 'Success'),
(75, 42, 21, '2025-03-05 04:43:26', 'Failed Password'),
(76, 34, 28, '2024-05-08 07:50:26', 'Success'),
(77, 38, 39, '2024-10-30 10:23:57', 'Failed Password'),
(78, 69, 22, '2024-04-07 21:57:38', 'Success'),
(79, 16, 60, '2024-12-29 15:53:14', 'Success'),
(80, 26, 39, '2024-09-27 08:13:33', 'Success'),
(81, 42, 42, '2024-08-07 10:26:33', 'Success'),
(82, 6, 8, '2024-05-29 19:32:05', 'Failed Password'),
(83, 45, 8, '2025-02-28 23:15:17', 'Suspicious Device'),
(84, 47, 59, '2025-03-10 10:57:06', 'Success'),
(85, 5, 16, '2024-12-02 02:27:13', 'OTP Failed'),
(86, 70, 24, '2024-07-04 11:43:36', 'Success'),
(87, 50, 22, '2024-08-06 11:18:37', 'Success'),
(88, 74, 35, '2024-04-11 08:06:53', 'OTP Failed'),
(89, 65, 10, '2024-04-14 09:40:38', 'Success'),
(90, 28, 25, '2024-07-29 10:18:50', 'Failed Password'),
(91, 55, 35, '2025-04-24 22:29:25', 'OTP Failed'),
(92, 9, 27, '2024-05-29 00:04:04', 'Success'),
(93, 38, 52, '2025-03-07 16:11:59', 'Account Locked'),
(94, 61, 57, '2025-02-28 17:13:06', 'Suspicious Device'),
(95, 5, 6, '2024-09-15 06:35:13', 'Success'),
(96, 34, 22, '2025-03-13 09:06:32', 'OTP Failed'),
(97, 12, 23, '2024-04-23 07:00:47', 'Account Locked'),
(98, 3, 21, '2024-12-28 14:15:46', 'OTP Failed'),
(99, 5, 55, '2024-07-05 20:50:19', 'OTP Failed'),
(100, 15, 13, '2024-09-28 02:44:25', 'Suspicious Device'),
(101, 43, 35, '2024-12-05 05:22:00', 'Account Locked'),
(102, 39, 26, '2024-11-27 16:33:49', 'Success'),
(103, 38, 30, '2024-05-05 20:04:05', 'Suspicious Device'),
(104, 69, 53, '2024-10-28 12:05:51', 'Suspicious Device'),
(105, 17, 55, '2024-01-07 07:48:18', 'Failed Password'),
(106, 74, 45, '2024-03-23 21:29:15', 'OTP Failed'),
(107, 14, 39, '2025-04-07 20:43:20', 'Failed Password'),
(108, 71, 58, '2024-11-06 09:55:11', 'Account Locked'),
(109, 73, 3, '2024-03-15 01:47:50', 'Success'),
(110, 22, 6, '2024-07-29 07:51:34', 'Success'),
(111, 19, 57, '2025-02-12 23:17:50', 'Account Locked'),
(112, 61, 32, '2024-10-28 19:15:42', 'Failed Password'),
(113, 33, 51, '2025-02-19 14:19:08', 'Success'),
(114, 49, 26, '2024-04-15 00:33:16', 'Failed Password'),
(115, 10, 24, '2024-01-25 02:45:00', 'Success'),
(116, 27, 21, '2025-03-06 12:26:37', 'Suspicious Device'),
(117, 74, 58, '2025-02-19 23:59:13', 'Success'),
(118, 25, 24, '2024-11-23 02:08:45', 'Success'),
(119, 46, 51, '2025-01-07 15:20:56', 'Success'),
(120, 36, 39, '2024-08-16 06:09:10', 'OTP Failed'),
(121, 51, 18, '2025-01-14 03:46:37', 'Suspicious Device'),
(122, 28, 35, '2024-01-25 17:09:03', 'Success'),
(123, 76, 40, '2025-04-22 03:22:40', 'Account Locked'),
(124, 67, 39, '2024-07-07 12:30:26', 'Account Locked'),
(125, 53, 49, '2025-03-25 05:42:44', 'OTP Failed'),
(126, 36, 8, '2024-10-16 09:20:36', 'OTP Failed'),
(127, 9, 52, '2024-06-26 15:55:57', 'Failed Password'),
(128, 51, 44, '2024-12-08 04:06:46', 'Success'),
(129, 77, 46, '2024-10-29 16:48:05', 'Suspicious Device'),
(130, 59, 16, '2024-06-07 09:10:32', 'Success'),
(131, 29, 5, '2024-03-16 19:10:27', 'OTP Failed'),
(132, 48, 59, '2024-08-12 17:20:27', 'Suspicious Device'),
(133, 9, 53, '2024-12-05 23:06:19', 'Success'),
(134, 36, 10, '2024-12-21 22:31:02', 'Success'),
(135, 5, 36, '2024-03-09 07:39:14', 'Success'),
(136, 68, 40, '2025-04-05 03:21:48', 'OTP Failed'),
(137, 63, 59, '2024-11-11 22:05:18', 'OTP Failed'),
(138, 79, 16, '2024-07-21 05:16:53', 'Failed Password'),
(139, 56, 46, '2024-05-17 22:04:58', 'Suspicious Device'),
(140, 31, 45, '2025-03-26 17:13:28', 'Account Locked'),
(141, 36, 58, '2024-03-27 22:14:10', 'Success'),
(142, 46, 49, '2024-07-15 06:36:53', 'Success'),
(143, 78, 41, '2024-09-16 08:50:55', 'Suspicious Device'),
(144, 66, 19, '2024-10-07 23:35:50', 'Success'),
(145, 11, 52, '2024-07-27 01:29:21', 'Failed Password'),
(146, 73, 13, '2024-05-24 21:22:42', 'Success'),
(147, 39, 6, '2024-11-05 17:08:23', 'Suspicious Device'),
(148, 71, 7, '2024-10-15 20:26:50', 'Success'),
(149, 59, 47, '2024-04-26 03:38:37', 'Suspicious Device'),
(150, 24, 17, '2024-04-01 02:51:19', 'OTP Failed'),
(151, 34, 35, '2024-12-16 15:15:54', 'OTP Failed'),
(152, 36, 56, '2024-07-04 05:22:49', 'Success'),
(153, 58, 18, '2025-01-10 18:37:21', 'Account Locked'),
(154, 8, 46, '2024-06-03 09:56:26', 'Account Locked'),
(155, 40, 15, '2024-11-23 05:00:39', 'Failed Password'),
(156, 51, 46, '2024-12-28 08:50:35', 'Failed Password'),
(157, 57, 58, '2024-09-18 18:13:36', 'Account Locked'),
(158, 51, 1, '2024-08-10 08:41:59', 'Success'),
(159, 40, 55, '2024-03-27 15:15:54', 'Success'),
(160, 58, 1, '2024-04-25 22:01:04', 'Suspicious Device'),
(161, 68, 24, '2024-06-14 02:15:14', 'Failed Password'),
(162, 8, 40, '2025-02-25 09:12:21', 'Suspicious Device'),
(163, 24, 12, '2024-08-08 18:03:41', 'Account Locked'),
(164, 79, 14, '2024-07-07 13:44:25', 'Suspicious Device'),
(165, 29, 22, '2024-05-24 15:07:29', 'Suspicious Device'),
(166, 69, 23, '2024-06-12 18:01:33', 'Success'),
(167, 7, 13, '2024-02-05 08:54:11', 'OTP Failed'),
(168, 5, 50, '2024-01-14 22:38:27', 'Suspicious Device'),
(169, 65, 18, '2024-07-09 14:36:52', 'Success'),
(170, 7, 31, '2025-01-08 05:38:23', 'Failed Password'),
(171, 63, 18, '2024-07-10 08:37:01', 'Success'),
(172, 10, 22, '2024-02-20 07:43:49', 'Success'),
(173, 31, 30, '2024-12-08 04:44:51', 'Success'),
(174, 25, 6, '2024-03-22 04:25:24', 'Failed Password'),
(175, 18, 1, '2024-06-18 17:29:43', 'Account Locked'),
(176, 37, 54, '2024-06-16 01:47:32', 'Success'),
(177, 25, 30, '2024-05-30 00:14:59', 'Failed Password'),
(178, 33, 32, '2024-01-25 14:40:33', 'Account Locked'),
(179, 69, 1, '2024-02-28 17:26:41', 'Account Locked'),
(180, 5, 59, '2024-04-27 05:22:22', 'Suspicious Device'),
(181, 23, 4, '2025-02-14 15:22:52', 'Success'),
(182, 26, 43, '2024-01-06 18:10:51', 'Success'),
(183, 73, 28, '2024-11-29 12:00:16', 'Success'),
(184, 57, 9, '2024-12-25 08:19:45', 'Success'),
(185, 35, 42, '2024-12-03 02:13:01', 'Suspicious Device'),
(186, 55, 24, '2025-03-25 10:02:44', 'Failed Password'),
(187, 52, 25, '2024-06-05 06:14:48', 'Success'),
(188, 3, 45, '2024-01-17 16:57:08', 'Success'),
(189, 76, 6, '2024-07-23 22:40:04', 'Success'),
(190, 75, 27, '2025-01-05 12:11:29', 'OTP Failed'),
(191, 48, 58, '2024-02-20 08:06:18', 'Success'),
(192, 3, 56, '2024-04-23 23:49:48', 'Failed Password'),
(193, 24, 15, '2024-09-06 06:04:40', 'OTP Failed'),
(194, 80, 25, '2024-01-06 00:43:57', 'Account Locked'),
(195, 11, 9, '2024-06-08 03:08:41', 'Account Locked'),
(196, 56, 34, '2024-07-17 01:28:05', 'Success'),
(197, 45, 49, '2024-12-02 13:15:38', 'Success'),
(198, 25, 28, '2025-03-23 17:37:44', 'OTP Failed'),
(199, 14, 23, '2024-11-14 06:04:09', 'Success'),
(200, 2, 53, '2024-02-25 16:01:03', 'Suspicious Device'),
(201, 57, 13, '2024-02-07 09:34:45', 'OTP Failed'),
(202, 36, 15, '2024-12-28 16:35:20', 'Success'),
(203, 65, 25, '2024-03-07 20:31:12', 'Failed Password'),
(204, 17, 29, '2024-02-04 07:09:24', 'OTP Failed'),
(205, 28, 2, '2025-04-30 21:08:47', 'OTP Failed'),
(206, 11, 45, '2024-09-26 08:35:46', 'Success'),
(207, 67, 20, '2024-10-06 08:31:41', 'OTP Failed'),
(208, 55, 41, '2024-07-19 14:39:47', 'Failed Password'),
(209, 51, 53, '2024-10-10 20:23:37', 'Success'),
(210, 27, 52, '2024-06-22 13:42:27', 'Account Locked'),
(211, 43, 17, '2024-08-13 13:54:20', 'Account Locked'),
(212, 27, 57, '2024-05-29 22:08:08', 'Success'),
(213, 75, 8, '2024-08-05 06:42:27', 'Account Locked'),
(214, 1, 36, '2024-12-14 23:46:54', 'Failed Password'),
(215, 21, 2, '2025-04-25 03:30:19', 'Failed Password'),
(216, 8, 55, '2024-04-19 19:08:05', 'Success'),
(217, 12, 58, '2024-10-08 02:35:19', 'Failed Password'),
(218, 38, 7, '2024-09-07 11:29:56', 'Account Locked'),
(219, 31, 37, '2024-09-07 15:08:55', 'Account Locked'),
(220, 70, 27, '2024-06-08 18:53:36', 'Success'),
(221, 45, 41, '2024-11-21 02:51:59', 'Success'),
(222, 49, 50, '2024-06-05 04:24:10', 'Failed Password'),
(223, 31, 19, '2025-04-22 17:50:45', 'Suspicious Device'),
(224, 21, 42, '2024-06-03 00:41:34', 'Account Locked'),
(225, 50, 19, '2025-03-20 23:57:58', 'Account Locked'),
(226, 53, 30, '2025-01-10 16:21:30', 'Success'),
(227, 32, 6, '2024-07-09 00:05:19', 'Success'),
(228, 60, 19, '2025-04-03 06:03:38', 'Success'),
(229, 80, 11, '2024-02-22 12:45:44', 'Success'),
(230, 61, 45, '2024-02-16 05:59:19', 'OTP Failed'),
(231, 57, 16, '2024-01-26 13:31:52', 'Suspicious Device'),
(232, 66, 45, '2024-03-09 16:19:06', 'Suspicious Device'),
(233, 73, 20, '2025-04-22 21:22:06', 'Success'),
(234, 76, 44, '2024-08-26 23:13:49', 'Success'),
(235, 15, 38, '2025-04-10 18:00:26', 'Success'),
(236, 1, 23, '2024-12-02 17:16:21', 'Suspicious Device'),
(237, 27, 48, '2024-02-25 14:12:43', 'Account Locked'),
(238, 64, 17, '2024-02-23 23:06:19', 'Suspicious Device'),
(239, 44, 40, '2025-02-16 00:59:46', 'Suspicious Device'),
(240, 30, 55, '2025-04-05 21:50:11', 'OTP Failed'),
(241, 57, 9, '2025-04-24 18:03:42', 'Account Locked'),
(242, 80, 33, '2025-02-19 12:38:01', 'Suspicious Device'),
(243, 78, 48, '2025-03-27 04:37:20', 'Success'),
(244, 11, 23, '2024-03-12 15:24:24', 'Success'),
(245, 74, 34, '2024-07-02 19:50:37', 'Success'),
(246, 46, 33, '2025-02-13 15:49:32', 'Success'),
(247, 44, 5, '2024-02-09 16:51:01', 'Suspicious Device'),
(248, 2, 55, '2025-03-31 08:49:24', 'Success'),
(249, 42, 4, '2024-08-07 04:05:33', 'Success'),
(250, 20, 55, '2024-01-06 07:44:17', 'Account Locked'),
(251, 21, 34, '2024-10-12 10:45:43', 'Success'),
(252, 34, 57, '2024-02-04 14:17:54', 'Success'),
(253, 2, 44, '2024-03-01 16:19:50', 'Success'),
(254, 40, 47, '2024-01-17 03:37:29', 'Success'),
(255, 39, 12, '2024-11-24 22:45:50', 'OTP Failed'),
(256, 38, 45, '2025-04-09 03:10:52', 'OTP Failed'),
(257, 72, 22, '2024-01-25 11:32:43', 'Success'),
(258, 15, 37, '2024-12-05 17:19:58', 'Success'),
(259, 38, 52, '2024-09-18 07:01:16', 'Success'),
(260, 15, 39, '2024-06-11 13:50:45', 'OTP Failed'),
(261, 22, 21, '2024-09-16 17:59:38', 'Failed Password'),
(262, 73, 3, '2025-04-14 23:20:31', 'OTP Failed'),
(263, 1, 44, '2024-03-08 06:15:22', 'Account Locked'),
(264, 14, 5, '2024-01-16 01:49:09', 'Success'),
(265, 26, 42, '2024-09-17 04:50:12', 'Suspicious Device'),
(266, 29, 20, '2024-06-02 10:26:49', 'Success'),
(267, 71, 7, '2024-10-07 12:32:00', 'Success'),
(268, 73, 28, '2025-01-01 21:47:19', 'Success'),
(269, 50, 9, '2024-07-08 22:56:08', 'Suspicious Device'),
(270, 70, 56, '2024-02-21 04:59:57', 'OTP Failed'),
(271, 70, 11, '2024-08-20 17:50:57', 'Success'),
(272, 46, 58, '2024-04-21 23:37:02', 'Success'),
(273, 58, 3, '2025-01-22 22:12:00', 'Failed Password'),
(274, 75, 6, '2024-04-17 03:50:34', 'Success'),
(275, 57, 35, '2025-04-02 10:17:05', 'OTP Failed'),
(276, 66, 60, '2024-03-11 20:44:01', 'Success'),
(277, 67, 59, '2025-02-22 08:19:19', 'Success'),
(278, 28, 37, '2024-09-19 06:41:47', 'Suspicious Device'),
(279, 31, 4, '2024-09-03 18:23:04', 'Success'),
(280, 70, 50, '2025-04-23 15:16:11', 'Success'),
(281, 4, 48, '2025-03-29 06:33:40', 'Success'),
(282, 31, 43, '2025-03-17 23:02:13', 'Account Locked'),
(283, 37, 34, '2024-11-02 00:42:00', 'Success'),
(284, 76, 23, '2024-09-08 16:04:09', 'Success'),
(285, 73, 9, '2024-10-16 02:23:38', 'OTP Failed'),
(286, 37, 50, '2025-01-04 17:05:24', 'Success'),
(287, 48, 47, '2024-05-26 01:09:04', 'Account Locked'),
(288, 58, 2, '2024-05-09 06:48:40', 'Account Locked'),
(289, 36, 15, '2025-01-12 19:12:21', 'Failed Password'),
(290, 46, 20, '2025-03-19 19:27:13', 'Success'),
(291, 56, 14, '2024-05-04 11:27:23', 'Account Locked'),
(292, 55, 3, '2024-05-08 07:33:32', 'OTP Failed'),
(293, 80, 39, '2024-11-13 06:22:30', 'Success'),
(294, 8, 36, '2024-02-03 23:45:13', 'Success'),
(295, 5, 50, '2024-04-22 15:36:47', 'Success'),
(296, 23, 24, '2024-02-05 13:04:06', 'OTP Failed'),
(297, 32, 9, '2024-03-20 06:06:35', 'Account Locked'),
(298, 56, 11, '2024-03-16 17:35:57', 'Success'),
(299, 45, 47, '2025-04-06 07:54:13', 'Account Locked'),
(300, 2, 48, '2024-10-08 14:21:34', 'Suspicious Device'),
(301, 73, 28, '2024-08-14 05:10:48', 'Suspicious Device'),
(302, 66, 16, '2024-11-03 10:48:15', 'Account Locked'),
(303, 18, 3, '2024-12-22 12:54:57', 'OTP Failed'),
(304, 52, 46, '2025-02-04 19:50:58', 'OTP Failed'),
(305, 72, 17, '2024-02-22 10:13:08', 'Success'),
(306, 65, 39, '2024-09-17 10:36:17', 'OTP Failed'),
(307, 14, 38, '2024-03-24 03:20:58', 'Failed Password'),
(308, 25, 46, '2024-04-20 22:42:16', 'Failed Password'),
(309, 8, 19, '2024-04-29 12:19:25', 'Account Locked'),
(310, 17, 15, '2025-02-25 02:43:10', 'Success'),
(311, 31, 9, '2024-10-08 04:56:45', 'Failed Password'),
(312, 56, 59, '2025-04-10 07:30:53', 'Success'),
(313, 39, 21, '2024-01-02 20:00:21', 'OTP Failed'),
(314, 70, 48, '2024-10-11 13:52:59', 'Suspicious Device'),
(315, 37, 1, '2025-03-03 21:34:26', 'Success'),
(316, 34, 52, '2025-04-04 01:22:01', 'Success'),
(317, 29, 47, '2024-10-20 22:42:33', 'Success'),
(318, 14, 58, '2024-03-09 05:17:35', 'OTP Failed'),
(319, 17, 20, '2024-07-12 11:20:43', 'Success'),
(320, 1, 44, '2024-10-07 09:55:55', 'OTP Failed'),
(321, 63, 56, '2024-09-21 20:56:52', 'Failed Password'),
(322, 60, 2, '2024-07-06 18:33:41', 'Account Locked'),
(323, 61, 55, '2024-07-01 15:09:26', 'Account Locked'),
(324, 46, 11, '2024-08-26 13:27:57', 'Success'),
(325, 17, 44, '2025-03-16 11:27:33', 'Suspicious Device'),
(326, 5, 41, '2025-01-12 22:02:13', 'Account Locked'),
(327, 4, 43, '2024-04-01 06:25:23', 'Suspicious Device'),
(328, 16, 38, '2025-02-09 20:56:14', 'Failed Password'),
(329, 38, 6, '2024-07-28 16:20:29', 'Suspicious Device'),
(330, 22, 14, '2024-12-13 22:39:50', 'Success'),
(331, 36, 36, '2024-01-19 07:56:22', 'Success'),
(332, 35, 31, '2025-03-23 17:13:33', 'Success'),
(333, 61, 1, '2025-01-14 20:39:33', 'Failed Password'),
(334, 2, 30, '2024-06-21 09:04:56', 'Account Locked'),
(335, 18, 25, '2024-02-18 23:38:24', 'Failed Password'),
(336, 75, 5, '2024-08-01 21:30:26', 'Failed Password'),
(337, 25, 8, '2024-12-02 05:19:12', 'Account Locked'),
(338, 30, 28, '2024-02-22 11:27:28', 'OTP Failed'),
(339, 41, 17, '2024-09-17 22:21:05', 'Success'),
(340, 6, 7, '2024-03-11 23:21:26', 'Success'),
(341, 73, 4, '2025-02-19 04:36:31', 'Account Locked'),
(342, 19, 59, '2025-03-27 10:42:19', 'Account Locked'),
(343, 8, 34, '2025-01-24 15:18:28', 'Success'),
(344, 59, 48, '2025-03-30 16:37:01', 'Success'),
(345, 80, 2, '2024-03-15 04:18:55', 'Account Locked'),
(346, 76, 12, '2024-08-27 19:00:38', 'Failed Password'),
(347, 30, 8, '2024-07-31 21:53:32', 'Suspicious Device'),
(348, 28, 13, '2024-06-04 10:31:39', 'Failed Password'),
(349, 61, 54, '2024-06-03 23:08:01', 'Success'),
(350, 35, 17, '2025-04-18 00:50:02', 'Success'),
(351, 43, 39, '2025-04-25 15:28:53', 'OTP Failed'),
(352, 30, 18, '2025-01-16 10:12:57', 'Suspicious Device'),
(353, 58, 53, '2025-02-08 10:17:54', 'Success'),
(354, 64, 22, '2024-01-20 16:36:44', 'Success'),
(355, 15, 24, '2024-09-01 12:01:39', 'Account Locked'),
(356, 9, 51, '2025-02-05 04:33:59', 'Failed Password'),
(357, 24, 55, '2025-03-16 16:56:38', 'Success'),
(358, 41, 4, '2024-01-22 15:54:18', 'Account Locked'),
(359, 16, 11, '2024-12-04 21:38:29', 'Success'),
(360, 14, 43, '2024-03-28 00:09:03', 'Success'),
(361, 70, 22, '2024-06-25 06:26:32', 'Suspicious Device'),
(362, 66, 25, '2024-08-02 08:36:09', 'Success'),
(363, 67, 56, '2024-11-28 09:39:55', 'Failed Password'),
(364, 80, 44, '2024-04-22 00:28:58', 'OTP Failed'),
(365, 56, 3, '2025-04-16 10:33:10', 'Failed Password'),
(366, 41, 40, '2024-04-17 20:42:56', 'Account Locked'),
(367, 13, 47, '2024-05-22 02:14:39', 'Suspicious Device'),
(368, 3, 39, '2024-04-28 21:13:16', 'Suspicious Device'),
(369, 36, 13, '2024-08-18 03:13:36', 'Suspicious Device'),
(370, 24, 29, '2025-03-21 05:57:45', 'Success'),
(371, 58, 34, '2024-04-05 01:47:40', 'OTP Failed'),
(372, 16, 25, '2025-04-30 13:27:05', 'Success'),
(373, 28, 8, '2025-02-03 10:08:45', 'OTP Failed'),
(374, 4, 40, '2024-09-16 00:42:41', 'Failed Password'),
(375, 26, 60, '2024-07-27 09:39:01', 'OTP Failed'),
(376, 26, 40, '2024-04-26 00:02:25', 'Failed Password'),
(377, 3, 20, '2025-03-03 17:38:17', 'Account Locked'),
(378, 57, 27, '2025-03-19 00:33:14', 'Suspicious Device'),
(379, 66, 50, '2024-04-07 12:06:26', 'Suspicious Device'),
(380, 55, 54, '2025-04-22 13:21:11', 'Failed Password'),
(381, 15, 32, '2024-04-21 02:55:11', 'Success'),
(382, 11, 35, '2024-03-05 07:01:32', 'Failed Password'),
(383, 66, 33, '2024-08-02 12:33:35', 'Success'),
(384, 14, 29, '2024-06-22 10:07:09', 'Failed Password'),
(385, 15, 48, '2024-05-13 15:57:50', 'Success'),
(386, 69, 45, '2024-06-20 10:57:31', 'Success'),
(387, 60, 41, '2025-01-22 07:15:37', 'Failed Password'),
(388, 66, 36, '2024-05-27 13:42:05', 'Success'),
(389, 31, 25, '2024-12-20 14:35:36', 'Success'),
(390, 79, 44, '2024-03-22 18:30:57', 'Failed Password'),
(391, 72, 1, '2024-07-13 13:44:41', 'Suspicious Device'),
(392, 56, 17, '2024-04-19 11:09:18', 'Suspicious Device'),
(393, 41, 1, '2025-03-13 22:07:33', 'Suspicious Device'),
(394, 30, 10, '2024-07-04 18:08:05', 'Success'),
(395, 12, 14, '2025-01-20 18:14:13', 'Success'),
(396, 73, 21, '2024-12-10 01:11:21', 'Success'),
(397, 18, 13, '2024-02-28 23:00:51', 'Account Locked'),
(398, 32, 12, '2024-04-14 11:36:27', 'OTP Failed'),
(399, 13, 45, '2024-05-19 12:44:51', 'Failed Password'),
(400, 29, 45, '2024-01-31 00:37:54', 'Success'),
(401, 32, 59, '2024-08-26 06:47:11', 'Success'),
(402, 60, 59, '2024-03-02 21:14:47', 'Success'),
(403, 55, 58, '2024-12-26 14:46:37', 'Success'),
(404, 71, 5, '2025-04-08 08:42:14', 'OTP Failed'),
(405, 36, 41, '2025-03-24 06:12:00', 'Account Locked'),
(406, 14, 12, '2024-11-01 15:39:30', 'Account Locked'),
(407, 49, 34, '2024-03-23 17:13:14', 'Success'),
(408, 43, 31, '2024-09-30 07:15:50', 'Failed Password'),
(409, 32, 18, '2024-08-21 22:17:26', 'OTP Failed'),
(410, 16, 17, '2025-03-14 11:06:04', 'Success'),
(411, 12, 40, '2024-03-17 05:36:34', 'Success'),
(412, 68, 9, '2024-02-22 03:37:27', 'Account Locked'),
(413, 64, 33, '2024-12-01 07:29:41', 'Success'),
(414, 33, 56, '2024-07-09 16:04:18', 'Account Locked'),
(415, 70, 48, '2025-03-18 02:40:11', 'Success'),
(416, 71, 55, '2024-09-29 01:52:01', 'Failed Password'),
(417, 25, 24, '2025-02-16 00:28:50', 'Success'),
(418, 55, 44, '2024-04-21 08:54:20', 'Success'),
(419, 21, 14, '2024-03-10 14:56:27', 'Success'),
(420, 80, 21, '2025-01-26 13:00:06', 'Account Locked');


INSERT INTO RiskScores (risk_id, user_id, score, risk_level, last_updated) 
VALUES
(1, 1, 81.57, 'Critical', '2024-09-07 20:35:00'),
(2, 2, 19.9, 'Low', '2025-02-27 06:46:00'),
(3, 3, 34.4, 'Low', '2024-11-18 04:42:05'),
(4, 4, 20.89, 'Low', '2024-11-06 01:24:06'),
(5, 5, 57.67, 'Medium', '2024-08-18 10:36:18'),
(6, 6, 41.28, 'Medium', '2024-04-30 04:53:23'),
(7, 7, 71.25, 'High', '2024-08-09 01:58:23'),
(8, 8, 23.01, 'Low', '2024-08-04 07:21:07'),
(9, 9, 31.22, 'Low', '2024-08-26 08:31:05'),
(10, 10, 64.99, 'High', '2025-04-26 19:32:53'),
(11, 11, 59.26, 'Medium', '2024-11-18 16:05:11'),
(12, 12, 39.99, 'Medium', '2024-01-30 16:10:21'),
(13, 13, 47.56, 'Medium', '2024-06-04 14:29:24'),
(14, 14, 95.89, 'Critical', '2024-09-10 10:08:19'),
(15, 15, 28.0, 'Low', '2025-04-09 02:40:46'),
(16, 16, 35.33, 'Medium', '2025-02-27 21:00:46'),
(17, 17, 24.85, 'Low', '2024-04-28 17:11:32'),
(18, 18, 88.51, 'Critical', '2024-07-13 06:06:53'),
(19, 19, 55.98, 'Medium', '2024-08-04 14:23:55'),
(20, 20, 32.9, 'Low', '2024-12-18 23:53:02'),
(21, 21, 86.36, 'Critical', '2025-02-26 02:39:08'),
(22, 22, 90.06, 'Critical', '2025-04-17 00:26:56'),
(23, 23, 73.29, 'High', '2024-10-31 07:27:37'),
(24, 24, 26.6, 'Low', '2024-01-07 02:46:52'),
(25, 25, 72.75, 'High', '2024-09-14 11:44:46'),
(26, 26, 84.92, 'Critical', '2025-04-23 00:35:11'),
(27, 27, 97.39, 'Critical', '2024-02-13 04:20:44'),
(28, 28, 5.6, 'Low', '2024-03-08 05:49:47'),
(29, 29, 37.44, 'Medium', '2024-06-11 16:48:50'),
(30, 30, 19.5, 'Low', '2024-04-28 00:51:49'),
(31, 31, 14.34, 'Low', '2024-09-15 09:01:32'),
(32, 32, 77.25, 'High', '2024-09-10 08:10:25'),
(33, 33, 39.48, 'Medium', '2025-01-01 01:40:43'),
(34, 34, 88.85, 'Critical', '2024-07-21 12:51:40'),
(35, 35, 86.31, 'Critical', '2025-04-29 09:32:04'),
(36, 36, 68.74, 'High', '2024-02-07 11:12:09'),
(37, 37, 69.69, 'High', '2024-11-17 22:16:31'),
(38, 38, 14.54, 'Low', '2024-08-16 03:48:46'),
(39, 39, 30.04, 'Low', '2024-07-27 01:37:00'),
(40, 40, 60.61, 'High', '2024-10-06 04:18:54'),
(41, 41, 40.53, 'Medium', '2025-01-04 20:53:14'),
(42, 42, 23.6, 'Low', '2025-03-14 01:16:41'),
(43, 43, 25.58, 'Low', '2024-08-06 10:52:19'),
(44, 44, 19.8, 'Low', '2024-11-05 11:49:03'),
(45, 45, 75.03, 'High', '2024-09-23 06:18:37'),
(46, 46, 41.93, 'Medium', '2024-05-17 13:12:38'),
(47, 47, 11.21, 'Low', '2024-06-27 00:36:22'),
(48, 48, 96.67, 'Critical', '2024-08-04 16:26:49'),
(49, 49, 75.97, 'High', '2024-03-09 17:54:49'),
(50, 50, 51.06, 'Medium', '2024-01-19 05:55:45'),
(51, 51, 65.24, 'High', '2025-03-07 19:38:46'),
(52, 52, 21.93, 'Low', '2024-03-19 19:20:33'),
(53, 53, 46.02, 'Medium', '2024-11-01 12:05:44'),
(54, 54, 64.23, 'High', '2025-01-15 01:17:08'),
(55, 55, 69.98, 'High', '2024-07-11 03:45:56'),
(56, 56, 67.66, 'High', '2025-03-02 04:57:38'),
(57, 57, 29.54, 'Low', '2025-04-29 10:33:26'),
(58, 58, 36.87, 'Medium', '2025-04-05 20:22:56'),
(59, 59, 52.11, 'Medium', '2024-03-30 11:47:54'),
(60, 60, 63.87, 'High', '2024-06-12 03:11:26'),
(61, 61, 97.49, 'Critical', '2024-11-19 10:44:44'),
(62, 62, 89.2, 'Critical', '2024-11-17 03:39:53'),
(63, 63, 70.57, 'High', '2024-10-30 11:16:27'),
(64, 64, 74.04, 'High', '2024-08-24 07:47:43'),
(65, 65, 16.92, 'Low', '2024-11-26 00:07:51'),
(66, 66, 16.7, 'Low', '2024-11-22 15:26:29'),
(67, 67, 79.97, 'High', '2024-11-22 10:20:57'),
(68, 68, 64.32, 'High', '2024-11-24 16:20:19'),
(69, 69, 82.83, 'Critical', '2025-04-17 09:28:38'),
(70, 70, 31.55, 'Low', '2024-01-19 14:09:14'),
(71, 71, 7.43, 'Low', '2024-01-27 16:03:23'),
(72, 72, 89.18, 'Critical', '2024-07-26 07:46:31'),
(73, 73, 77.77, 'High', '2024-08-20 04:22:07'),
(74, 74, 47.21, 'Medium', '2024-08-07 17:22:32'),
(75, 75, 85.17, 'Critical', '2024-05-10 13:49:19'),
(76, 76, 34.49, 'Low', '2025-04-14 15:55:31'),
(77, 77, 5.03, 'Low', '2024-03-28 05:50:23'),
(78, 78, 24.45, 'Low', '2024-01-19 12:20:12'),
(79, 79, 66.31, 'High', '2024-04-08 20:06:17'),
(80, 80, 83.62, 'Critical', '2024-02-24 00:50:04');


select * from users;
select * from geolocation;
select * from devices;
select * from accounts;
select * from transactions;
select * from fraudalerts;
select * from auditlogs;
select * from riskscores;


-- QUERIES AND FINDINGS

-- 1. USER & ACCOUNT ANALYTICS

-- 1a) How many unique users are registered in the system?
SELECT DISTINCT user_id, CONCAT(first_name, ' ', last_name) AS full_name
FROM Users;

-- 1b) Which users own multiple bank accounts?
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(a.account_id) AS total_accounts
FROM Users u
JOIN Accounts a
    ON u.user_id = a.user_id
GROUP BY
    u.user_id,
    full_name
HAVING COUNT(a.account_id) > 1
ORDER BY total_accounts DESC;

-- 1c) What is the average account balance by account type?
SELECT
    account_type,
    COUNT(account_id) AS total_accounts,
    ROUND(AVG(balance), 2) AS average_balance,
    ROUND(SUM(balance), 2) AS total_balance
FROM Accounts
GROUP BY account_type
ORDER BY average_balance DESC;

-- 1d) Which users have the highest total account balances?
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(a.account_id) AS total_accounts,
    ROUND(SUM(a.balance), 2) AS total_balance
FROM Users u
JOIN Accounts a
    ON u.user_id = a.user_id
GROUP BY
    u.user_id,
    full_name
ORDER BY total_balance DESC
LIMIT 10;

-- 1e) How many users are currently suspended or dormant?
SELECT
    user_status,
    COUNT(DISTINCT user_id) AS total_users
FROM Users
WHERE user_status IN ('Suspended', 'Dormant')
GROUP BY user_status
ORDER BY total_users DESC;

-- 1f) What is the distribution of account statuses across the system?
SELECT
    status AS account_status,
    COUNT(account_id) AS total_accounts,
    ROUND(
        COUNT(account_id) * 100.0 /
        (SELECT COUNT(*) FROM Accounts),
        2
    ) AS percentage_distribution
FROM Accounts
GROUP BY status
ORDER BY total_accounts DESC;

-- SECTION 2 — TRANSACTION ANALYTICS.

-- 2a) What is the total transaction volume processed by the system?
SELECT
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_volume,
    ROUND(AVG(amount), 2) AS average_transaction_value,
    ROUND(MAX(amount), 2) AS highest_transaction,
    ROUND(MIN(amount), 2) AS lowest_transaction
FROM Transactions;

-- 2b) Which transaction types occur most frequently?
SELECT
    transaction_type,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_amount,
    ROUND(AVG(amount), 2) AS average_transaction_amount,
    ROUND(
        COUNT(transaction_id) * 100.0 /
        (SELECT COUNT(*) FROM Transactions),
        2
    ) AS transaction_percentage
FROM Transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- 2c) Which accounts perform the highest number of transactions?
SELECT
    a.account_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    a.account_type,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_transaction_amount,
    ROUND(AVG(t.amount), 2) AS average_transaction_amount
FROM Accounts a
JOIN Users u
    ON a.user_id = u.user_id
JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    a.account_id,
    full_name,
    a.account_type
ORDER BY total_transactions DESC
LIMIT 10;

-- 2d) What are the monthly transaction trends?
SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_transaction_volume,
    ROUND(AVG(amount), 2) AS average_transaction_amount
FROM Transactions
GROUP BY transaction_month
ORDER BY transaction_month;

-- 2e) Which transactions have exceptionally high amounts?
SELECT
    t.transaction_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    a.account_type,
    t.transaction_type,
    t.amount,
    t.location,
    t.transaction_date
FROM Transactions t
JOIN Accounts a
    ON t.account_id = a.account_id
JOIN Users u
    ON a.user_id = u.user_id
WHERE t.amount >
(
    SELECT AVG(amount) * 3
    FROM Transactions
)
ORDER BY t.amount DESC;

-- 2f) Which locations generate the highest transaction activity?
SELECT
    g.country,
    g.city,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS total_transaction_volume,
    ROUND(AVG(t.amount), 2) AS average_transaction_amount
FROM Transactions t
JOIN Devices d
    ON t.device_id = d.device_id
JOIN GeoLocation g
    ON d.ip_address = g.ip_address
GROUP BY
    g.country,
    g.city
ORDER BY total_transaction_volume DESC;

-- SECTION 3 — FRAUD & RISK ANALYTICS

-- 3a) Which users have the highest fraud risk scores?
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    rs.score,
    rs.risk_level,
    COUNT(f.alert_id) AS total_fraud_alerts
FROM Users u
JOIN RiskScores rs
    ON u.user_id = rs.user_id
LEFT JOIN FraudAlerts f
    ON u.user_id = f.user_id
GROUP BY
    u.user_id,
    full_name,
    rs.score,
    rs.risk_level
ORDER BY rs.score DESC
LIMIT 10;

-- 3b) Which transactions have the highest fraud risk?
SELECT
    f.transaction_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    f.alert_type,
    f.risk_score,
    t.amount,
    t.location
FROM FraudAlerts f
JOIN Transactions t
    ON f.transaction_id = t.transaction_id
JOIN Users u
    ON f.user_id = u.user_id
ORDER BY f.risk_score DESC,
         t.amount DESC
LIMIT 10;

-- 3c) Which countries generate the most fraud alerts?
SELECT
    g.country,
    COUNT(f.alert_id) AS total_fraud_alerts,
    ROUND(AVG(f.risk_score), 2) AS average_risk_score
FROM FraudAlerts f
JOIN Transactions t
    ON f.transaction_id = t.transaction_id
JOIN Devices d
    ON t.device_id = d.device_id
JOIN GeoLocation g
    ON d.ip_address = g.ip_address
GROUP BY g.country
ORDER BY total_fraud_alerts DESC;

-- 3d) Which devices are linked to suspicious transactions?
SELECT
    d.device_id,
    d.device_type,
    g.country,
    g.city,
    COUNT(f.alert_id) AS suspicious_transactions,
    ROUND(AVG(f.risk_score), 2) AS average_risk_score
FROM FraudAlerts f
JOIN Transactions t
    ON f.transaction_id = t.transaction_id
JOIN Devices d
    ON t.device_id = d.device_id
JOIN GeoLocation g
    ON d.ip_address = g.ip_address
GROUP BY
    d.device_id,
    d.device_type,
    g.country,
    g.city
ORDER BY suspicious_transactions DESC;

-- 3e) What percentage of transactions are marked as suspicious?
SELECT
    COUNT(DISTINCT f.transaction_id) AS suspicious_transactions,
    (SELECT COUNT(*) FROM Transactions) AS total_transactions,
    ROUND(
        COUNT(DISTINCT f.transaction_id) * 100.0 /
        (SELECT COUNT(*) FROM Transactions),
        2
    ) AS suspicious_transaction_percentage
FROM FraudAlerts f;

-- 3f) Which users repeatedly appear in fraud alerts?
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(f.alert_id) AS total_fraud_alerts,
    ROUND(AVG(f.risk_score), 2) AS average_risk_score
FROM Users u
JOIN FraudAlerts f
    ON u.user_id = f.user_id
GROUP BY
    u.user_id,
    full_name
HAVING COUNT(f.alert_id) > 1
ORDER BY total_fraud_alerts DESC,
         average_risk_score DESC;
         		
-- SECTION 4 — SECURITY & BEHAVIORAL ANALYTICS

-- 4a) Which users have the highest number of failed login attempts?
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(a.log_id) AS failed_login_attempts
FROM Users u
JOIN AuditLogs a
    ON u.user_id = a.user_id
WHERE a.login_status IN
(
    'Failed Password',
    'OTP Failed',
    'Account Locked',
    'Suspicious Device'
)
GROUP BY
    u.user_id,
    full_name
ORDER BY failed_login_attempts DESC
LIMIT 10;

-- 4b) Which devices are associated with suspicious login behavior?
SELECT
    d.device_id,
    d.device_type,
    g.country,
    g.city,
    COUNT(a.log_id) AS suspicious_logins
FROM AuditLogs a
JOIN Devices d
    ON a.device_id = d.device_id
JOIN GeoLocation g
    ON d.ip_address = g.ip_address
WHERE a.login_status IN
(
    'Failed Password',
    'OTP Failed',
    'Account Locked',
    'Suspicious Device'
)
GROUP BY
    d.device_id,
    d.device_type,
    g.country,
    g.city
ORDER BY suspicious_logins DESC;

-- 4c) What are the most common login failure reasons?
SELECT
    login_status,
    COUNT(log_id) AS total_occurrences,
    ROUND(
        COUNT(log_id) * 100.0 /
        (SELECT COUNT(*) FROM AuditLogs),
        2
    ) AS percentage_distribution
FROM AuditLogs
WHERE login_status <> 'Success'
GROUP BY login_status
ORDER BY total_occurrences DESC;

-- 4d) Which users access the system from multiple locations?
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    COUNT(DISTINCT g.city) AS unique_locations,
    COUNT(DISTINCT d.device_id) AS unique_devices
FROM Users u
JOIN AuditLogs a
    ON u.user_id = a.user_id
JOIN Devices d
    ON a.device_id = d.device_id
JOIN GeoLocation g
    ON d.ip_address = g.ip_address
GROUP BY
    u.user_id,
    full_name
HAVING COUNT(DISTINCT g.city) > 1
ORDER BY unique_locations DESC;

-- 4e) Which devices are used by multiple users?
SELECT
    d.device_id,
    d.device_type,
    g.country,
    g.city,
    COUNT(DISTINCT a.user_id) AS unique_users
FROM Devices d
JOIN AuditLogs a
    ON d.device_id = a.device_id
JOIN GeoLocation g
    ON d.ip_address = g.ip_address
GROUP BY
    d.device_id,
    d.device_type,
    g.country,
    g.city
HAVING COUNT(DISTINCT a.user_id) > 1
ORDER BY unique_users DESC;

-- 4f) What are the peak login activity hours?
SELECT
    HOUR(login_time) AS login_hour,
    COUNT(log_id) AS total_logins
FROM AuditLogs
GROUP BY login_hour
ORDER BY total_logins DESC;

-- SECTION 5 — ADVANCED SQL & DATABASE FEATURES

-- 5a) Rank users based on total transaction amounts using window functions.
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    ROUND(SUM(t.amount), 2) AS total_transaction_amount,
    RANK() OVER
    (
        ORDER BY SUM(t.amount) DESC
    ) AS transaction_rank
FROM Users u
JOIN Accounts a
    ON u.user_id = a.user_id
JOIN Transactions t
    ON a.account_id = t.account_id
GROUP BY
    u.user_id,
    full_name;
    

-- 5b) Identify monthly transaction growth using LAG().

WITH MonthlyTransactions AS
(
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m') AS transaction_month,
        ROUND(SUM(amount), 2) AS monthly_transaction_volume
    FROM Transactions
    GROUP BY transaction_month
)

SELECT
    transaction_month,
    monthly_transaction_volume,
    LAG(monthly_transaction_volume)
    OVER (ORDER BY transaction_month)
    AS previous_month_volume,

    ROUND
    (
        monthly_transaction_volume -
        LAG(monthly_transaction_volume)
        OVER (ORDER BY transaction_month),
        2
    ) AS growth_difference
FROM MonthlyTransactions;

-- 5c) Detect top risky users using CTE-based analytics.

WITH UserFraudAnalysis AS
(
    SELECT
        u.user_id,
        CONCAT(u.first_name, ' ', u.last_name) AS full_name,
        COUNT(f.alert_id) AS total_fraud_alerts,
        ROUND(AVG(f.risk_score), 2) AS average_risk_score
    FROM Users u
    JOIN FraudAlerts f
        ON u.user_id = f.user_id
    GROUP BY
        u.user_id,
        full_name
)

SELECT *
FROM UserFraudAnalysis
WHERE average_risk_score > 70
ORDER BY total_fraud_alerts DESC;

-- 5d) Create a view for high-risk users and suspicious transactions.

CREATE OR REPLACE VIEW HighRiskUsers AS
SELECT
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS full_name,
    rs.score,
    rs.risk_level,
    COUNT(f.alert_id) AS total_fraud_alerts
FROM Users u
JOIN RiskScores rs
    ON u.user_id = rs.user_id
LEFT JOIN FraudAlerts f
    ON u.user_id = f.user_id
GROUP BY
    u.user_id,
    full_name,
    rs.score,
    rs.risk_level;
    
SELECT * FROM HighRiskUsers;
    
-- 5e) Implement a stored procedure for fraud detection and risk analysis.

DELIMITER //

CREATE PROCEDURE DetectHighRiskTransactions()
BEGIN
    SELECT
        t.transaction_id,
        CONCAT(u.first_name, ' ', u.last_name) AS full_name,
        t.amount,
        f.risk_score,
        f.alert_type
    FROM FraudAlerts f
    JOIN Transactions t
        ON f.transaction_id = t.transaction_id
    JOIN Users u
        ON f.user_id = u.user_id
    WHERE f.risk_score > 75
    ORDER BY f.risk_score DESC;
END //

DELIMITER ;

CALL DetectHighRiskTransactions();

-- 5f) Create a trigger to automatically generate fraud alerts for high-risk transactions.

DELIMITER //

CREATE TRIGGER trg_high_value_transaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.amount > 500000 THEN

        INSERT INTO FraudAlerts
        (
            transaction_id,
            account_id,
            user_id,
            alert_type,
            alert_date,
            risk_score
        )

        VALUES
        (
            NEW.transaction_id,

            NEW.account_id,

            (
                SELECT user_id
                FROM Accounts
                WHERE account_id = NEW.account_id
            ),

            'High Amount Transaction',

            NOW(),

            95
        );
    END IF;
END //

DELIMITER ;


-- below is the example 
-- (trigger event + select)

-- 1.trigger event 
INSERT INTO Transactions
(
    account_id,
    transaction_date,
    amount,
    transaction_type,
    location,
    device_id
)

VALUES
(
    5,
    NOW(),
    750000,
    'Transfer',
    'Dubai',
    10
);


-- now select
SELECT *
FROM FraudAlerts
ORDER BY alert_id DESC;


-- THANK YOU -- --
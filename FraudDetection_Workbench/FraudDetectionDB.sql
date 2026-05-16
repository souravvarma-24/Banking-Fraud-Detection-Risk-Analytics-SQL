
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




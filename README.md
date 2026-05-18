# Banking-Fraud-Detection-Risk-Analytics-SQL

This project demonstrates how Advanced SQL can be used to design, manage, and analyze a real-world Banking Fraud Detection & Risk Analytics System.  
The system simulates modern banking operations by integrating transaction monitoring, fraud detection, behavioral analytics, device intelligence, geo-location tracking, and risk scoring into a unified relational database architecture.

This project focuses on financial fraud analytics, suspicious activity monitoring, security intelligence, and business-driven SQL analysis using advanced relational database concepts.

---

## 🚀 Project Objectives

The primary objective of this project is to build a scalable and analytics-driven SQL database system capable of simulating real-world banking fraud detection scenarios.

### ✔ Key Goals

- **Transaction Intelligence** – Analyze and monitor financial transaction activity  
- **Fraud Detection** – Detect suspicious and high-risk transactions  
- **Risk Analytics** – Identify risky users, accounts, and behavioral patterns  
- **Behavioral Monitoring** – Analyze login behavior and suspicious access attempts  
- **Device Intelligence** – Track suspicious devices and shared device usage  
- **Geo-Location Analytics** – Monitor fraud activity across locations and countries  
- **Security Analytics** – Detect failed logins, account abuse, and unusual activity  
- **Business Intelligence** – Generate analytical insights using Advanced SQL  

---

## 🗂 Database Schema Overview

The system is designed using a normalized relational database structure containing the following interconnected tables:

| Table Name | Description |
|---|---|
| Users | Stores user profile, KYC, and account status details |
| Accounts | Stores banking account information and balances |
| Transactions | Stores transaction activity and payment records |
| FraudAlerts | Stores suspicious transaction alerts and fraud risk data |
| AuditLogs | Stores login activity and security-related events |
| Devices | Stores device and IP address information |
| GeoLocation | Stores IP-based country and city mapping |
| RiskScores | Stores user-level fraud risk scores and classifications |

---

## 🖼 ER Diagram

The complete ER Diagram of the Banking Fraud Detection & Risk Analytics System is included in the repository.

📌 **Path:**  
`ER_Diagram/ER_Diagram_Fraud_Detection.png`

---

## 📁 Folder Structure

```text
FraudDetection_Datasets/
 ├── Accounts_FraudDetectionDB.csv
 ├── AuditLogs_FraudDetectionDB.csv
 ├── Devices_FraudDetectionDB.csv
 ├── FraudAlerts_FraudDetectionDB.csv
 ├── GeoLocation_FraudDetectionDB.csv
 ├── RiskScores_FraudDetectionDB.csv
 ├── Transactions_FraudDetectionDB.csv
 └── Users_FraudDetectionDB.csv

FraudDetection_Workbench/
 ├── FraudDetectionDB.sql

FraudDetection_PPTX/
 └── Banking_Fraud_Detection_Presentation.pptx

ER_Diagram/
 └── ER_Diagram_Fraud_Detection.png

README.md
```

---

## 📊 Analysis & Business Insights

This project includes advanced banking, fraud detection, behavioral, and risk analytics queries using SQL.

### 👤 User & Account Analytics

- Users owning multiple accounts  
- Account balance analysis by account type  
- High-value banking customers  
- Suspended and dormant user analysis  
- Account status distribution analysis  

### 💳 Transaction Analytics

- Total transaction volume analysis  
- Monthly transaction trends  
- High-value transaction detection  
- Transaction type distribution  
- Geo-based transaction activity analysis  

### 🚨 Fraud & Risk Analytics

- High-risk user detection  
- Fraud alert analysis  
- Fraud percentage calculation  
- Suspicious transaction monitoring  
- Country-wise fraud analysis  
- Device-based fraud analytics  

### 🔐 Security & Behavioral Analytics

- Failed login analysis  
- Suspicious device tracking  
- Login behavior monitoring  
- Multi-location user activity analysis  
- Peak login activity detection  

### ⚡ Advanced SQL Analytics

- Window Functions  
- Common Table Expressions (CTEs)  
- Views  
- Stored Procedures  
- Triggers  
- Ranking Analytics  
- Subqueries & Aggregate Analysis  

---

## ⭐ Key Recommendations

### 1️⃣ Strengthen Monitoring for High-Value Transactions
Large transaction amounts showed significantly higher fraud risk scores and suspicious activity patterns.

### 2️⃣ Improve Behavioral Authentication Systems
Users with repeated failed login attempts demonstrated elevated fraud probability.

### 3️⃣ Enhance Device Intelligence Monitoring
Devices shared across multiple users were associated with suspicious transaction behavior.

### 4️⃣ Increase Geo-Location-Based Fraud Monitoring
Foreign transactions contributed disproportionately to fraud alerts and elevated risk scores.

### 5️⃣ Apply Additional Validation for Dormant Accounts
Dormant and suspended users performing transactions may indicate potential account compromise or fraud activity.

---

## ▶️ How to Run the Project

### **Step 1 — Import CSV Datasets**

Import each CSV file into its corresponding table using MySQL Workbench Import Wizard.

| CSV File | Table Name |
|---|---|
| Users_FraudDetectionDB.csv | Users |
| Accounts_FraudDetectionDB.csv | Accounts |
| Devices_FraudDetectionDB.csv | Devices |
| Transactions_FraudDetectionDB.csv | Transactions |
| FraudAlerts_FraudDetectionDB.csv | FraudAlerts |
| AuditLogs_FraudDetectionDB.csv | AuditLogs |
| GeoLocation_FraudDetectionDB.csv | GeoLocation |
| RiskScores_FraudDetectionDB.csv | RiskScores |

---

### **Step 2 — Run the SQL Script**

Execute the following SQL script in MySQL Workbench:

```text
FraudDetection_Workbench/FraudDetectionDB.sql
```

---

### **Step 3 — View ER Diagram & Presentation**

Open the project presentation and ER diagram files:

```text
FraudDetection_PPTX/Banking_Fraud_Detection_Presentation.pptx

ER_Diagram/ER_Diagram_Fraud_Detection.png
```

---

## 🛠 Technologies Used

- MySQL / SQL  
- MySQL Workbench  
- Relational Database Design  
- ER Diagram Modeling  
- Git & GitHub  
- CSV Dataset Integration  

---

## 🧠 Challenges Faced

- Designing a normalized banking fraud detection schema  
- Managing multiple table relationships and foreign keys  
- Simulating realistic fraud and transaction scenarios  
- Implementing behavioral and geo-location analytics  
- Handling advanced SQL analytics and fraud intelligence queries  
- Automating fraud alert generation using triggers  
- Building scalable and analytics-oriented database architecture  

---

## 📘 SQL Concepts Covered

- Primary & Foreign Keys  
- Data Normalization (1NF, 2NF, 3NF)  
- INNER JOIN, LEFT JOIN & Multi-Table Joins  
- GROUP BY, HAVING & Aggregate Functions  
- Subqueries & Correlated Subqueries  
- Common Table Expressions (CTEs)  
- Window Functions (RANK, LAG)  
- Views, Stored Procedures & Triggers  
- CASE Statements & Business Logic  
- Query Optimization & Indexing  
- ER Modeling & Relational Design  

---

## 🌍 Real-World Applications

This project demonstrates practical applications of SQL in:

- Banking Analytics  
- Fraud Detection Systems  
- Financial Risk Monitoring  
- Security Analytics  
- Behavioral Analytics  
- Transaction Intelligence Platforms  
- Business Intelligence Reporting  
- Fraud Investigation Systems  

---

## 📝 Conclusion

The Banking Fraud Detection & Risk Analytics System demonstrates how Advanced SQL can be applied to solve real-world financial monitoring and fraud detection challenges through scalable relational database design and analytical querying.

By integrating transaction intelligence, fraud analytics, behavioral monitoring, security analysis, geo-location tracking, and risk scoring into a unified database architecture, this project simulates a modern banking analytics environment used in financial institutions and fraud monitoring systems.

The project showcases practical implementation of:
- Advanced SQL analytics
- Relational database modeling
- Fraud detection logic
- Risk-based analysis
- Behavioral intelligence
- Security monitoring
- Business intelligence reporting

using technologies and concepts such as:
- Joins & Aggregations
- Common Table Expressions (CTEs)
- Window Functions
- Subqueries
- Views
- Stored Procedures
- Triggers
- Query Optimization

This project highlights strong analytical, technical, and problem-solving capabilities relevant to roles including:
- Data Analyst
- Business Analyst
- SQL Developer
- Fraud Analyst
- Financial Analyst
- Analytics Engineer

The system serves as a complete end-to-end SQL analytics solution that reflects real-world applications of database systems in banking, fraud intelligence, and financial risk management.

---

⭐ Thank you for exploring this project — feedback, suggestions, and contributions are always welcome!

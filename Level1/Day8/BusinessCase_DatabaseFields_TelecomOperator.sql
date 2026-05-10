/* ============================================================
   MSSQL LAB: Telecom Data Mapping
   FULL UPDATED VERSION WITHOUT GO
   Execute section by section in SSMS
   ============================================================ */

---------------------------------------------------------------
-- 1. CREATE DATABASE
---------------------------------------------------------------

DROP DATABASE IF EXISTS TelecomDataMappingLab; 
GO

CREATE DATABASE TelecomDataMappingLab; 
GO

USE TelecomDataMappingLab;

SELECT DB_NAME();
---------------------------------------------------------------
-- 2. CREATE TABLES
---------------------------------------------------------------

-- Customers Table
CREATE TABLE customers (
    customer_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_full_name VARCHAR(100) NOT NULL,
    nrc_number VARCHAR(50),
    gender VARCHAR(10),
    city VARCHAR(50),
    created_at DATETIME DEFAULT GETDATE()
);

-- Subscribers Table
CREATE TABLE subscribers (
    subscriber_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT NOT NULL,
    msisdn VARCHAR(20) NOT NULL UNIQUE,
    sim_number VARCHAR(30) NOT NULL,
    package_type VARCHAR(50),
    activation_date DATE,
    status VARCHAR(20),

    CONSTRAINT fk_subscriber_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

-- Recharge Transactions Table
CREATE TABLE recharge_transactions (
    recharge_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_id INT NOT NULL,
    recharge_amount DECIMAL(12,2) NOT NULL,
    recharge_channel VARCHAR(50),
    recharge_created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT fk_recharge_subscriber
    FOREIGN KEY (subscriber_id)
    REFERENCES subscribers(subscriber_id)
);

-- Data Usage Table
CREATE TABLE data_usage (
    usage_id INT IDENTITY(1,1) PRIMARY KEY,
    subscriber_id INT NOT NULL,
    usage_date DATE NOT NULL,
    total_data_mb DECIMAL(12,2) NOT NULL,
    network_type VARCHAR(20),

    CONSTRAINT fk_usage_subscriber
    FOREIGN KEY (subscriber_id)
    REFERENCES subscribers(subscriber_id)
);

-- Data Mapping Catalog Table
CREATE TABLE data_mapping_catalog (
    mapping_id INT IDENTITY(1,1) PRIMARY KEY,
    business_term VARCHAR(100) NOT NULL,
    source_system VARCHAR(100),
    database_table VARCHAR(100),
    database_field VARCHAR(100),
    field_description VARCHAR(255),
    data_type VARCHAR(50),
    data_owner VARCHAR(100)
);

---------------------------------------------------------------
-- 3. INSERT SAMPLE DATA
---------------------------------------------------------------

-- Customers
INSERT INTO customers
(customer_full_name, nrc_number, gender, city)
VALUES
('Aung Aung', '12/ABC(N)123456', 'Male', 'Yangon'),
('Su Su', '10/XYZ(N)234567', 'Female', 'Mandalay'),
('Kyaw Kyaw', '8/MNO(N)345678', 'Male', 'Naypyitaw'),
('Hla Hla', '7/PQR(N)456789', 'Female', 'Bago'),
('Mya Mya', '9/STU(N)567890', 'Female', 'Yangon');

-- Subscribers
INSERT INTO subscribers
(customer_id, msisdn, sim_number, package_type, activation_date, status)
VALUES
(1, '09790000001', 'SIM100001', 'Prepaid', '2025-01-10', 'Active'),
(2, '09790000002', 'SIM100002', 'Postpaid', '2025-02-15', 'Active'),
(3, '09790000003', 'SIM100003', 'Prepaid', '2025-03-20', 'Inactive'),
(4, '09790000004', 'SIM100004', 'Prepaid', '2025-04-05', 'Active'),
(5, '09790000005', 'SIM100005', 'Postpaid', '2025-05-12', 'Active');

-- Recharge Transactions
INSERT INTO recharge_transactions
(subscriber_id, recharge_amount, recharge_channel, recharge_created_at)
VALUES
(1, 5000, 'Mobile Wallet', '2026-05-01 09:30:00'),
(1, 7000, 'Retail Shop', '2026-05-03 14:20:00'),
(2, 15000, 'Bank App', '2026-05-02 10:10:00'),
(3, 3000, 'Retail Shop', '2026-05-04 16:45:00'),
(4, 12000, 'Mobile Wallet', '2026-05-05 11:00:00'),
(5, 20000, 'Bank App', '2026-05-06 18:30:00'),
(1, 10000, 'Mobile Wallet', '2026-05-07 08:00:00');

-- Data Usage
INSERT INTO data_usage
(subscriber_id, usage_date, total_data_mb, network_type)
VALUES
(1, '2026-05-01', 1200.50, '4G'),
(1, '2026-05-02', 850.25, '4G'),
(2, '2026-05-02', 2300.75, '5G'),
(3, '2026-05-03', 400.00, '3G'),
(4, '2026-05-04', 1750.30, '4G'),
(5, '2026-05-05', 3200.90, '5G'),
(1, '2026-05-06', 1500.00, '4G');

-- Data Mapping Catalog
INSERT INTO data_mapping_catalog
(business_term, source_system, database_table, database_field, field_description, data_type, data_owner)
VALUES
('Customer Name', 'CRM System', 'customers', 'customer_full_name', 'Full name of telecom customer', 'VARCHAR(100)', 'CRM Team'),
('Customer NRC', 'CRM System', 'customers', 'nrc_number', 'National registration number', 'VARCHAR(50)', 'CRM Team'),
('Customer City', 'CRM System', 'customers', 'city', 'Customer registered city', 'VARCHAR(50)', 'CRM Team'),
('Mobile Number', 'Billing System', 'subscribers', 'msisdn', 'Customer mobile phone number', 'VARCHAR(20)', 'Billing Team'),
('SIM Number', 'Billing System', 'subscribers', 'sim_number', 'SIM card serial number', 'VARCHAR(30)', 'Billing Team'),
('Package Type', 'Billing System', 'subscribers', 'package_type', 'Prepaid or postpaid package type', 'VARCHAR(50)', 'Product Team'),
('Recharge Amount', 'Billing System', 'recharge_transactions', 'recharge_amount', 'Top-up amount by customer', 'DECIMAL(12,2)', 'Billing Team'),
('Recharge Date', 'Billing System', 'recharge_transactions', 'recharge_created_at', 'Date and time of recharge', 'DATETIME', 'Billing Team'),
('Recharge Channel', 'Billing System', 'recharge_transactions', 'recharge_channel', 'Channel used for recharge', 'VARCHAR(50)', 'Sales Team'),
('Internet Usage', 'Network System', 'data_usage', 'total_data_mb', 'Total internet usage in MB', 'DECIMAL(12,2)', 'Network Team'),
('Usage Date', 'Network System', 'data_usage', 'usage_date', 'Date of internet usage', 'DATE', 'Network Team'),
('Network Type', 'Network System', 'data_usage', 'network_type', '3G, 4G, or 5G network type', 'VARCHAR(20)', 'Network Team');

---------------------------------------------------------------
-- 4. SELECT QUERIES
---------------------------------------------------------------

SELECT * FROM customers;

SELECT * FROM subscribers;

SELECT * FROM recharge_transactions;

SELECT * FROM data_usage;

SELECT * FROM data_mapping_catalog;

---------------------------------------------------------------
-- 5. CUSTOMER + SIM INFORMATION
---------------------------------------------------------------

SELECT
    c.customer_full_name AS Customer_Name,
    c.city,
    s.msisdn AS Mobile_Number,
    s.sim_number,
    s.package_type,
    s.status
FROM customers c
INNER JOIN subscribers s
ON c.customer_id = s.customer_id;

---------------------------------------------------------------
-- 6. RECHARGE HISTORY
---------------------------------------------------------------

SELECT
    c.customer_full_name,
    s.msisdn,
    r.recharge_amount,
    r.recharge_channel,
    r.recharge_created_at
FROM customers c
INNER JOIN subscribers s
ON c.customer_id = s.customer_id
INNER JOIN recharge_transactions r
ON s.subscriber_id = r.subscriber_id
ORDER BY r.recharge_created_at;

---------------------------------------------------------------
-- 7. TOTAL RECHARGE BY CUSTOMER
---------------------------------------------------------------

SELECT
    c.customer_full_name,
    s.msisdn,
    SUM(r.recharge_amount) AS total_recharge
FROM customers c
INNER JOIN subscribers s
ON c.customer_id = s.customer_id
INNER JOIN recharge_transactions r
ON s.subscriber_id = r.subscriber_id
GROUP BY c.customer_full_name, s.msisdn
ORDER BY total_recharge DESC;

---------------------------------------------------------------
-- 8. TOTAL DATA USAGE BY CUSTOMER
---------------------------------------------------------------

SELECT
    c.customer_full_name,
    s.msisdn,
    SUM(d.total_data_mb) AS total_data_usage_mb
FROM customers c
INNER JOIN subscribers s
ON c.customer_id = s.customer_id
INNER JOIN data_usage d
ON s.subscriber_id = d.subscriber_id
GROUP BY c.customer_full_name, s.msisdn
ORDER BY total_data_usage_mb DESC;

---------------------------------------------------------------
-- 9. HIGH RECHARGE CUSTOMERS
---------------------------------------------------------------

SELECT
    c.customer_full_name,
    s.msisdn,
    SUM(r.recharge_amount) AS total_recharge
FROM customers c
INNER JOIN subscribers s
ON c.customer_id = s.customer_id
INNER JOIN recharge_transactions r
ON s.subscriber_id = r.subscriber_id
GROUP BY c.customer_full_name, s.msisdn
HAVING SUM(r.recharge_amount) > 10000;

---------------------------------------------------------------
-- 10. FINAL BUSINESS REPORT
---------------------------------------------------------------

SELECT
    c.customer_full_name AS Customer_Name,
    c.city,
    s.msisdn,
    s.package_type,
    s.status,

    ISNULL(
        (SELECT SUM(r.recharge_amount)
         FROM recharge_transactions r
         WHERE r.subscriber_id = s.subscriber_id), 0
    ) AS total_recharge,

    ISNULL(
        (SELECT SUM(d.total_data_mb)
         FROM data_usage d
         WHERE d.subscriber_id = s.subscriber_id), 0
    ) AS total_data_usage_mb

FROM customers c
INNER JOIN subscribers s
ON c.customer_id = s.customer_id
ORDER BY total_recharge DESC;
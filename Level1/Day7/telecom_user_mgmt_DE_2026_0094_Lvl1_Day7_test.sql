-- =========================================================
-- TELECOM USER ROLE MANAGEMENT SYSTEM
-- DATABASE ADMINISTRATION & SQL PRACTICAL ASSIGNMENT
-- COMPLETE SQL FORMAT SOLUTION
-- =========================================================

-- =========================================================
-- SECTION A — DDL (DATA DEFINITION LANGUAGE)
-- =========================================================

-- ---------------------------------------------------------
-- QUESTION 1
-- Create database telecom_user_mgmt
-- ---------------------------------------------------------

DROP DATABASE IF EXISTS telecom_user_mgmt;

CREATE DATABASE telecom_user_mgmt;

USE telecom_user_mgmt;

-- ---------------------------------------------------------
-- QUESTION 2
-- Create users table
-- ---------------------------------------------------------

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    department VARCHAR(50),
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------
-- QUESTION 3
-- Create roles table
-- ---------------------------------------------------------

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) UNIQUE,
    description VARCHAR(255)
);

-- ---------------------------------------------------------
-- QUESTION 4
-- Create permissions table
-- ---------------------------------------------------------

CREATE TABLE permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100),
    module_name VARCHAR(100)
);

-- ---------------------------------------------------------
-- QUESTION 5
-- Create user_roles table
-- ---------------------------------------------------------

CREATE TABLE user_roles (
    user_role_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    role_id INT,

    FOREIGN KEY (user_id)
    REFERENCES users(user_id),

    FOREIGN KEY (role_id)
    REFERENCES roles(role_id)
);

-- ---------------------------------------------------------
-- QUESTION 6
-- Create audit_logs table
-- ---------------------------------------------------------

CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action_performed VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
);

-- =========================================================
-- SECTION B — DML (DATA MANIPULATION LANGUAGE)
-- =========================================================

-- ---------------------------------------------------------
-- QUESTION 7
-- Insert users
-- ---------------------------------------------------------

INSERT INTO users (username, email, department)
VALUES
('aung_admin', 'aung@gmail.com', 'IT'),
('susu_billing', 'susu@gmail.com', 'Billing'),
('kyaw_support', 'kyaw@gmail.com', 'Customer Support'),
('mya_network', 'mya@gmail.com', 'Network Operations'),
('koko_manager', 'koko@gmail.com', 'Management');

-- ---------------------------------------------------------
-- QUESTION 8
-- Insert roles
-- ---------------------------------------------------------

INSERT INTO roles (role_name, description)
VALUES
('Admin', 'Full access to system'),
('Billing Officer', 'Manage billing operations'),
('Support Agent', 'Customer support access'),
('Network Engineer', 'Manage network operations'),
('Viewer', 'Read-only access');

-- ---------------------------------------------------------
-- QUESTION 9
-- Insert permissions
-- ---------------------------------------------------------

INSERT INTO permissions (permission_name, module_name)
VALUES
('Create User', 'User Management'),
('Update Billing', 'Billing'),
('View Reports', 'Reports'),
('Manage Network', 'Network'),
('Delete User', 'User Management');

-- ---------------------------------------------------------
-- QUESTION 10
-- Assign roles to users
-- ---------------------------------------------------------

INSERT INTO user_roles (user_id, role_id)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- ---------------------------------------------------------
-- QUESTION 11
-- Update one user status
-- ---------------------------------------------------------

UPDATE users
SET status = 'INACTIVE'
WHERE user_id = 3;

-- ---------------------------------------------------------
-- QUESTION 12
-- Delete one permission
-- ---------------------------------------------------------

DELETE FROM permissions
WHERE permission_id = 5;

-- =========================================================
-- SECTION C — DQL (DATA QUERY LANGUAGE)
-- =========================================================

-- ---------------------------------------------------------
-- QUESTION 13
-- Display all users
-- ---------------------------------------------------------

SELECT * FROM users;

-- ---------------------------------------------------------
-- QUESTION 14
-- Display active users
-- ---------------------------------------------------------

SELECT *
FROM users
WHERE status = 'ACTIVE';

-- ---------------------------------------------------------
-- QUESTION 15
-- Display users with roles
-- ---------------------------------------------------------

SELECT
    u.username,
    u.department,
    r.role_name
FROM users u
JOIN user_roles ur
ON u.user_id = ur.user_id
JOIN roles r
ON ur.role_id = r.role_id;

-- ---------------------------------------------------------
-- QUESTION 16
-- Count users by department
-- ---------------------------------------------------------

SELECT
    department,
    COUNT(*) AS total_users
FROM users
GROUP BY department;

-- ---------------------------------------------------------
-- QUESTION 17
-- Display Billing department users
-- ---------------------------------------------------------

SELECT *
FROM users
WHERE department = 'Billing';

-- ---------------------------------------------------------
-- QUESTION 18
-- Display all roles and permissions
-- ---------------------------------------------------------

SELECT
    r.role_name,
    p.permission_name,
    p.module_name
FROM roles r
CROSS JOIN permissions p;

-- ---------------------------------------------------------
-- QUESTION 19
-- Sort users by username
-- ---------------------------------------------------------

SELECT *
FROM users
ORDER BY username ASC;

-- ---------------------------------------------------------
-- QUESTION 20
-- Total users in system
-- ---------------------------------------------------------

SELECT COUNT(*) AS total_users
FROM users;

-- =========================================================
-- SECTION D — TCL / DTL
-- =========================================================

-- ---------------------------------------------------------
-- QUESTION 21
-- Transaction with COMMIT
-- ---------------------------------------------------------

START TRANSACTION;

INSERT INTO audit_logs (user_id, action_performed)
VALUES (1, 'Created new telecom account');

COMMIT;

-- ---------------------------------------------------------
-- QUESTION 22
-- Transaction with ROLLBACK
-- ---------------------------------------------------------

START TRANSACTION;

UPDATE users
SET status = 'INACTIVE'
WHERE user_id = 2;

ROLLBACK;

SELECT *
FROM users
WHERE user_id = 2;

-- ---------------------------------------------------------
-- QUESTION 23
-- SAVEPOINT example
-- ---------------------------------------------------------

START TRANSACTION;

UPDATE users
SET status = 'INACTIVE'
WHERE user_id = 1;

SAVEPOINT sp1;

UPDATE users
SET status = 'INACTIVE'
WHERE user_id = 4;

ROLLBACK TO sp1;

COMMIT;

-- ---------------------------------------------------------
-- QUESTION 24
-- COMMIT vs ROLLBACK
-- ---------------------------------------------------------

-- COMMIT Example
START TRANSACTION;

UPDATE users
SET department = 'Management'
WHERE user_id = 5;

COMMIT;

-- ROLLBACK Example
START TRANSACTION;

UPDATE users
SET department = 'Billing'
WHERE user_id = 5;

ROLLBACK;

-- =========================================================
-- SECTION E — DCL (DATA CONTROL LANGUAGE)
-- =========================================================

-- ---------------------------------------------------------
-- QUESTION 25
-- Create billing_user
-- ---------------------------------------------------------

CREATE USER 'billing_user'@'localhost'
IDENTIFIED BY 'password123';

-- ---------------------------------------------------------
-- QUESTION 26
-- Grant SELECT and UPDATE
-- ---------------------------------------------------------

GRANT SELECT, UPDATE
ON telecom_user_mgmt.users
TO 'billing_user'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 27
-- Grant INSERT on audit_logs
-- ---------------------------------------------------------

GRANT INSERT
ON telecom_user_mgmt.audit_logs
TO 'billing_user'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 28
-- Show granted privileges
-- ---------------------------------------------------------

SHOW GRANTS FOR 'billing_user'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 29
-- Revoke UPDATE privilege
-- ---------------------------------------------------------

REVOKE UPDATE
ON telecom_user_mgmt.users
FROM 'billing_user'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 30
-- Create viewer_user with read-only access
-- ---------------------------------------------------------

CREATE USER 'viewer_user'@'localhost'
IDENTIFIED BY 'viewer123';

GRANT SELECT
ON telecom_user_mgmt.*
TO 'viewer_user'@'localhost';

-- =========================================================
-- SECTION F — PRACTICAL SCENARIO QUESTIONS
-- =========================================================

-- ---------------------------------------------------------
-- QUESTION 31
-- Only Admin users manage accounts
-- ---------------------------------------------------------

CREATE USER 'admin_user'@'localhost'
IDENTIFIED BY 'admin123';

GRANT ALL PRIVILEGES
ON telecom_user_mgmt.users
TO 'admin_user'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 32
-- Billing department privileges
-- ---------------------------------------------------------

GRANT SELECT, UPDATE
ON telecom_user_mgmt.audit_logs
TO 'billing_user'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 33
-- Support Agents read-only access
-- ---------------------------------------------------------

CREATE USER 'support_agent'@'localhost'
IDENTIFIED BY 'support123';

GRANT SELECT
ON telecom_user_mgmt.*
TO 'support_agent'@'localhost';

-- ---------------------------------------------------------
-- QUESTION 34
-- Username + Role + Permission + Module
-- ---------------------------------------------------------

SELECT
    u.username,
    r.role_name,
    p.permission_name,
    p.module_name
FROM users u
JOIN user_roles ur
ON u.user_id = ur.user_id
JOIN roles r
ON ur.role_id = r.role_id
CROSS JOIN permissions p;

-- ---------------------------------------------------------
-- QUESTION 35
-- RBAC Explanation in SQL Comment Format
-- ---------------------------------------------------------

/*

=========================================================
ROLE-BASED ACCESS CONTROL (RBAC) IN TELECOM SYSTEMS
=========================================================

1. SECURITY
RBAC improves security by restricting unauthorized
access to sensitive telecom data and operations.

2. AUDITABILITY
RBAC helps track user activities through audit logs,
making monitoring and investigation easier.

3. DATA PROTECTION
Sensitive customer and billing information is protected
from unauthorized viewing, editing, or deletion.

4. ACCESS LIMITATION
Users only receive permissions necessary for their roles.
This minimizes accidental errors and insider threats.

5. COMPLIANCE
RBAC supports regulatory compliance and organizational
security policies in telecom environments.

=========================================================

*/

-- =========================================================
-- BONUS QUERIES
-- =========================================================

SELECT * FROM users;
SELECT * FROM roles;
SELECT * FROM permissions;
SELECT * FROM user_roles;
SELECT * FROM audit_logs;

-- =========================================================
-- SHOW TABLE STRUCTURES
-- =========================================================

DESCRIBE users;
DESCRIBE roles;
DESCRIBE permissions;
DESCRIBE user_roles;
DESCRIBE audit_logs;

-- =========================================================
-- END OF TELECOM USER ROLE MANAGEMENT SYSTEM
-- =========================================================
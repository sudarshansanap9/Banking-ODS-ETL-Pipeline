# Banking ODS Customer ETL Project

## 1. Project Overview

This project implements a customer data ETL pipeline for a Banking Operational Data Store (ODS) using Oracle SQL and PL/SQL.

The system receives customer data into a staging layer, validates the records, loads valid records into the ODS, captures invalid records in an error log, and maintains ETL execution and audit information.

## 2. Objectives

* Load customer data from staging into ODS
* Validate customer records before loading
* Handle duplicate and invalid records
* Maintain ETL execution logs
* Capture processing errors
* Support reprocessing of failed records
* Implement customer auditing
* Improve query performance using indexes and materialized views
* Provide database views for monitoring and reporting

## 3. Technology Stack

* Oracle Database
* SQL
* PL/SQL
* Stored Procedures
* PL/SQL Packages
* Triggers
* Views
* Materialized Views
* Indexes
* Sequences

## 4. Architecture

```text
Source Data
    |
    v
STG_CUSTOMER
    |
    v
Customer Validation
    |
    +--------------------+
    |                    |
    v                    v
ODS_CUSTOMER       ETL_ERROR_LOG
    |
    v
ETL Monitoring
    |
    +----------------------+
    |                      |
    v                      v
ETL_RUN_LOG          ETL_RUN_DETAIL
    |
    v
Views / Materialized Views
```

## 5. ETL Flow

The customer ETL process follows these steps:

1. Customer data is loaded into `STG_CUSTOMER`.
2. Staging records are validated.
3. Valid records are loaded into `ODS_CUSTOMER`.
4. Invalid records are captured in `ETL_ERROR_LOG`.
5. ETL execution information is recorded.
6. Successful and failed processing can be monitored.
7. Customer changes are captured through the audit trigger.
8. Views and materialized views provide reporting and monitoring information.

## 6. Main Database Objects

### Tables

* `STG_CUSTOMER`
* `ODS_CUSTOMER`
* `ETL_ERROR_LOG`
* `ETL_RUN_LOG`
* `ETL_RUN_DETAIL`
* `ODS_CUSTOMER_AUDIT`

### PL/SQL

* Stored procedures
* Customer ETL package
* Exception handling
* Transaction management
* Batch/incremental processing

### Trigger

`TRG_CUSTOMER_AUDIT`

The trigger records customer INSERT, UPDATE and DELETE activity in `ODS_CUSTOMER_AUDIT`.

### Views

The project contains views for:

* Customer information
* ETL run monitoring
* Customer status summaries

### Materialized View

A customer summary materialized view is used for summarized query/reporting requirements.

## 7. Data Validation

The ETL process validates customer records before loading them into the ODS.

Validation includes:

* Required fields
* Customer information
* Mobile number
* PAN number
* Duplicate records
* Data quality rules

Invalid records are not loaded into the target table and are recorded in the error log.

## 8. Error Handling

The ETL process uses PL/SQL exception handling to manage processing failures.

Errors are captured in:

`ETL_ERROR_LOG`

This provides traceability and supports troubleshooting and reprocessing.

## 9. Transaction Management

The ETL process uses transaction control to maintain data consistency.

Successful operations are committed, while failed operations can be rolled back according to the processing logic.

## 10. Auditing

Customer changes are audited using:

`TRG_CUSTOMER_AUDIT`

The audit table stores:

* Customer ID
* Action type
* Old status
* New status
* Audit date
* Database user

Example:

```text
CUSTOMER_ID | ACTION_TYPE | OLD_STATUS | NEW_STATUS
1009        | UPDATE      | NEW        | ACTIVE
```

## 11. Performance Optimization

The project includes:

* Appropriate indexes
* Statistics gathering
* Execution plan analysis
* Query optimization
* Materialized views
* Batch processing

The project also handles duplicate-index issues such as Oracle error `ORA-01408`.

## 12. Testing

Testing covers:

* End-to-end ETL processing
* Transaction management
* Exception handling
* Error logging
* ETL reprocessing
* Customer auditing
* Positive scenarios
* Negative scenarios
* Performance testing

## 13. Project Structure

```text
BANKING_ODS_ETL/
|
+-- 01_DDL/
+-- 02_SEQUENCES/
+-- 03_DML/
+-- 04_PROCEDURES/
+-- 06_PACKAGES/
+-- 07_TRIGGERS/
+-- 08_VIEWS/
+-- 09_MATERIALIZED_VIEWS/
+-- 10_ETL/
+-- 11_INDEXES/
+-- 12_TEST_CASES/
+-- 13_DOCUMENTATION/
+-- README.md
```

## 14. Execution Order

The recommended execution order is:

```text
DDL
 |
 v
Sequences
 |
 v
DML / Test Data
 |
 v
Procedures
 |
 v
Package
 |
 v
Triggers
 |
 v
Views
 |
 v
Materialized Views
 |
 v
Indexes
 |
 v
ETL Tests
```

## 15. Project Outcome

The completed project demonstrates an end-to-end Oracle Customer ETL implementation with:

* Staging and ODS architecture
* Customer validation
* PL/SQL ETL processing
* Error handling
* Transaction management
* ETL monitoring
* Customer auditing
* Performance optimization
* Comprehensive testing
* Technical documentation

## 16. Author

**Md Sudarshan**

B.E — Computer Engineering

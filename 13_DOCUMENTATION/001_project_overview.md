# Banking ODS - Customer ETL Project

## 1. Project Overview

This project implements an Oracle-based Operational Data Store (ODS)
for customer data ingestion, validation, processing, error handling,
auditing and reporting.

The system receives customer records through a staging layer,
validates the records, loads valid records into the ODS and records
invalid records in the ETL error log.

## 2. Business Objective

The objective is to provide a reliable and auditable customer data
processing system suitable for a banking environment.

The system supports:

- Customer data ingestion
- Data validation
- Duplicate detection
- Error handling
- ETL audit tracking
- Failed-record tracking
- Reprocessing
- Reporting
- Query performance optimization

## 3. Technologies

- Oracle Database
- SQL
- PL/SQL
- Git
- GitHub

## 4. Main Database Components

- Staging tables
- ODS tables
- Sequences
- Procedures
- Functions
- Packages
- ETL run logging
- ETL error logging
- Views
- Materialized views
- Indexes
- Test scripts

## 5. Key Features

### Data Validation

Customer records are validated before being loaded into the ODS.

### Duplicate Detection

Unique constraints and validation logic prevent duplicate
customer identifiers, mobile numbers and PAN numbers.

### Error Handling

PL/SQL exception handling captures database errors using
SQLCODE and SQLERRM.

### ETL Audit

ETL_RUN_LOG and ETL_RUN_DETAIL provide batch-level and
record-level processing information.

### Error Logging

ETL_ERROR_LOG stores information about failed records and
their associated errors.

### Performance

Indexes and execution plans are used to analyze and improve
query performance.

### Reporting

Views and materialized views provide simplified access to
customer and ETL information.
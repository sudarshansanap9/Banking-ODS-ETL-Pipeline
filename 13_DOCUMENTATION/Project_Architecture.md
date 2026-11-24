-- Project_Architecture.md
# Project Architecture

## 1. Architecture Overview

The project follows a layered ETL architecture for processing customer data from the staging layer into the Operational Data Store (ODS).

```text
                    SOURCE / INPUT
                         │
                         ▼
                ┌─────────────────┐
                │  STG_CUSTOMER   │
                │ Staging Layer   │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │   VALIDATION    │
                │ Customer Rules  │
                └────────┬────────┘
                         │
                  ┌──────┴──────┐
                  │             │
                VALID         INVALID
                  │             │
                  ▼             ▼
          ┌──────────────┐  ┌────────────────┐
          │ ODS_CUSTOMER │  │ ETL_ERROR_LOG  │
          │ Target Data  │  │ Error Records  │
          └──────┬───────┘  └────────────────┘
                 │
                 ▼
        ┌────────────────────┐
        │ ETL RUN MONITORING │
        │                    │
        │ ETL_RUN_LOG        │
        │ ETL_RUN_DETAIL     │
        └──────────┬─────────┘
                   │
                   ▼
        ┌────────────────────┐
        │ Views / MV / Index │
        │ Reporting & Query  │
        └────────────────────┘



        2. Architecture Layers
Staging Layer

The staging layer receives incoming customer data before validation.

Main table:

STG_CUSTOMER

Purpose:

Temporary landing area
Initial data capture
Data validation before loading into ODS
Validation Layer

Customer records are validated using PL/SQL procedures and the Customer ETL package.

Validation includes:

Required field validation
Mobile number validation
PAN validation
Duplicate checking
Customer data quality checks
ODS Layer

Validated customer records are loaded into:

ODS_CUSTOMER

The ODS contains trusted customer information for downstream processing and reporting.

Error Handling Layer

Invalid or failed records are captured in:

ETL_ERROR_LOG

The error logging mechanism stores information required for troubleshooting and reprocessing.

ETL Monitoring Layer

ETL execution is tracked using:

ETL_RUN_LOG
ETL_RUN_DETAIL

These tables maintain information such as:

Run ID
Load ID
Start time
End time
Status
Records processed
Error information
3. PL/SQL Architecture

The main ETL processing is implemented using:

06_PACKAGES/
├── 001_customer_etl_package_spec.sql
└── 002_customer_etl_package_body.sql

The package provides centralized ETL processing and separates the package interface from its implementation.

Supporting procedures are maintained under:

04_PROCEDURES/
4. Database Objects

The project uses the following database objects:

Tables
Sequences
Procedures
Package
Views
Materialized View
Indexes
Constraints
5. Data Flow

The overall customer data flow is:

Incoming Customer Data
          │
          ▼
    STG_CUSTOMER
          │
          ▼
      Validation
          │
     ┌────┴────┐
     │         │
   Valid     Invalid
     │         │
     ▼         ▼
ODS_CUSTOMER ETL_ERROR_LOG
     │
     ▼
ETL Monitoring
     │
     ▼
Views / Materialized View
6. Transaction Management

The ETL process uses transaction management to maintain data consistency.

Successful processing is committed.

Failed processing is rolled back where required, and error information is captured for investigation.

7. Performance

Performance is supported through:

Appropriate indexes
Batch processing
Bulk processing techniques where applicable
Statistics gathering
Query optimization
Materialized views for summarized data
8. Testing Architecture

The project includes testing for:

End-to-end ETL processing
Positive scenarios
Negative scenarios
Exception handling
Error logging
Transaction management
Reprocessing
Performance

Test scripts are maintained under:

10_ETL/
12_TEST_CASES/
9. Documentation

Project documentation is maintained under:

13_DOCUMENTATION/

It includes:

Project overview
Database architecture
Business requirements
Testing summary
Performance testing
ER diagram
10. Deployment Flow

The database objects are deployed in dependency order:

DDL
 │
 ▼
Sequences
 │
 ▼
DML / Test Data
 │
 ▼
Procedures
 │
 ▼
Packages
 │
 ▼
Views
 │
 ▼
Materialized Views
 │
 ▼
Indexes
 │
 ▼
ETL Testing
11. Overall Architecture

The final architecture follows this pattern:

                 CUSTOMER SOURCE
                        │
                        ▼
                ┌───────────────┐
                │ STG_CUSTOMER  │
                └───────┬───────┘
                        │
                        ▼
              ┌──────────────────┐
              │ CUSTOMER ETL     │
              │ PACKAGE          │
              └────────┬─────────┘
                       │
                 ┌─────┴─────┐
                 │           │
               VALID       INVALID
                 │           │
                 ▼           ▼
          ┌────────────┐ ┌──────────────┐
          │ODS_CUSTOMER│ │ETL_ERROR_LOG │
          └─────┬──────┘ └──────────────┘
                │
                ▼
       ┌───────────────────┐
       │ ETL RUN MONITORING│
       │ RUN LOG / DETAIL  │
       └─────────┬─────────┘
                 │
                 ▼
       ┌───────────────────┐
       │ VIEWS / MV /      │
       │ INDEXES           │
       └───────────────────┘
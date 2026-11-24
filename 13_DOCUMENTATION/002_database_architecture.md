# Database Architecture

## High-Level Architecture

```text
Source / Incoming Customer Data
              |
              v
       STG_CUSTOMER
              |
              v
          Validation
              |
       +------+------+
       |             |
       v             v
    VALID         INVALID
       |             |
       v             v
 ODS_CUSTOMER   ETL_ERROR_LOG
       |
       v
ETL_RUN_DETAIL
       |
       v
 ETL_RUN_LOG
       |
       v
 Views / Materialized Views



 Main Layers
1. Staging Layer

STG_CUSTOMER temporarily stores incoming customer records before
validation and processing.

2. ODS Layer

ODS_CUSTOMER stores validated customer information.

3. ETL Audit Layer

ETL_RUN_LOG records batch-level information.

ETL_RUN_DETAIL records record-level processing information.

4. Error Layer

ETL_ERROR_LOG stores errors generated during processing.

5. Reporting Layer

Views and materialized views provide simplified access to
processed data and summary information.






---

# 4. `003_etl_flow.md`

```markdown
# ETL Flow

## Step 1 - Load Staging Data

Incoming customer records are inserted into STG_CUSTOMER.

## Step 2 - Validate

The ETL process validates customer information.

Examples:

- Mandatory fields
- Mobile number
- PAN number
- Duplicate records
- Business validation rules

## Step 3 - Process Valid Records

Valid records are loaded into ODS_CUSTOMER.

## Step 4 - Handle Invalid Records

Invalid records are not loaded into the ODS.

The failure is recorded in ETL_ERROR_LOG.

## Step 5 - Record ETL Details

ETL_RUN_DETAIL records the processing result for individual records.

## Step 6 - Record ETL Run

ETL_RUN_LOG records the overall batch status.

## Step 7 - Reporting

Views and materialized views provide reporting and monitoring data.

## Step 8 - Error Reprocessing

Failed records can be identified through ETL_RUN_DETAIL and
ETL_ERROR_LOG and corrected records can be reprocessed.
# Testing Summary

## Test Scenarios

### 1. Valid Customer

Expected result:

Customer successfully loaded into ODS_CUSTOMER.

### 2. Invalid Customer

Expected result:

Customer rejected and error recorded.

### 3. Duplicate PAN

Expected result:

Record rejected due to unique constraint.

### 4. Duplicate Mobile

Expected result:

Record rejected due to unique constraint.

### 5. ETL Error Handling

Expected result:

SQLCODE and SQLERRM captured and error logged.

### 6. Transaction Testing

COMMIT and ROLLBACK behavior verified.

### 7. Restart / Reprocessing

Failed records identified through ETL tracking tables.

### 8. Performance Testing

EXPLAIN PLAN used to inspect query execution.

### 9. Materialized View

Materialized view compilation and refresh verified.

## Final Result

The ETL process was tested with both positive and negative
customer scenarios and the corresponding database logging
and validation mechanisms were verified.
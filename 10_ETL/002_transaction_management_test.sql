-- Transaction Management Test

INSERT INTO ODS_CUSTOMER
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    MOBILE_NO,
    PAN_NO
)
VALUES
(
    9001,
    'Transaction',
    'Test',
    '9000000001',
    'TRNST1234A'
);

-- Check the inserted record
SELECT *
FROM ODS_CUSTOMER
WHERE CUSTOMER_ID = 9001;

-- Undo the insert
ROLLBACK;

-- Verify that the record is gone
SELECT *
FROM ODS_CUSTOMER
WHERE CUSTOMER_ID = 9001;
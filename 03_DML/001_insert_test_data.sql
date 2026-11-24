INSERT INTO STG_CUSTOMER
(
    LOAD_ID,
    FIRST_NAME,
    LAST_NAME,
    DOB,
    MOBILE_NO,
    PAN_NO,
    EMAIL,
    LOAD_STATUS,
    ERROR_MESSAGE,
    LOAD_DATE
)
VALUES
(
    1001,
    'Rahul',
    'Sharma',
    DATE '1995-01-10',
    '9999999999',
    'ABCDE1234F',
    'rahul@gmail.com',
    'NEW',
    NULL,
    SYSDATE
);

-- Record 1002
-- Record 1003
-- Record 1004

COMMIT;
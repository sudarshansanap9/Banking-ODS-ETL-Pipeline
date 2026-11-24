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
    1011,
    'Rahul',
    'Sharma',
    DATE '1996-04-10',
    '9012345678',
    'UVWXY1234Z',
    'rahul.sharma@gmail.com',
    'NEW',
    NULL,
    SYSDATE
);


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
    1012,
    'Invalid',
    'Customer',
    DATE '1995-08-20',
    '12345',
    'ABCDE6789F',
    'invalid.customer@gmail.com',
    'NEW',
    NULL,
    SYSDATE
);

COMMIT;
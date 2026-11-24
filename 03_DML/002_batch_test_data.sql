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
    1005,
    'Arjun',
    'Kumar',
    DATE '1997-05-15',
    '9876543210',
    'LMNOP1234Q',
    'arjun@gmail.com',
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
    1006,
    'Neha',
    'Singh',
    DATE '1998-08-20',
    '9876501234',
    'RSTUV5678W',
    'neha@gmail.com',
    'NEW',
    NULL,
    SYSDATE
);

COMMIT;
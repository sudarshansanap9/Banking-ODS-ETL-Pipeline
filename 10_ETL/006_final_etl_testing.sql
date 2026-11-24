INSERT INTO STG_CUSTOMER
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    MOBILE_NO,
    PAN_NO,
    RECORD_STATUS
)
VALUES
(
    2001,
    'Amit',
    'Sharma',
    '9876543201',
    'AMITS1234A',
    'NEW'
);

COMMIT;

-- Valid Customer


INSERT INTO STG_CUSTOMER
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    MOBILE_NO,
    PAN_NO,
    RECORD_STATUS
)
VALUES
(
    2001,
    'Amit',
    'Sharma',
    '9876543201',
    'AMITS1234A',
    'NEW'
);

COMMIT;


-- Invalid Customer

INSERT INTO STG_CUSTOMER
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    MOBILE_NO,
    PAN_NO,
    RECORD_STATUS
)
VALUES
(
    2002,
    'Invalid',
    'Customer',
    '12345',
    'ABCDE6789F',
    'NEW'
);

COMMIT;



-- Duplicate PAN

INSERT INTO STG_CUSTOMER
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    MOBILE_NO,
    PAN_NO,
    RECORD_STATUS
)
VALUES
(
    2003,
    'Duplicate',
    'PAN',
    '9876543203',
    'AMITS1234A',
    'NEW'
);

COMMIT;





-- Duplicate Mobile

INSERT INTO STG_CUSTOMER
(
    CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME,
    MOBILE_NO,
    PAN_NO,
    RECORD_STATUS
)
VALUES
(
    2004,
    'Duplicate',
    'Mobile',
    '9876543201',
    'DUPLM1234B',
    'NEW'
);

COMMIT;
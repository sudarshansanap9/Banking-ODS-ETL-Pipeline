CREATE OR REPLACE PROCEDURE LOAD_STG_CUSTOMER_VALIDATION
IS

CURSOR C_CUSTOMER IS
SELECT *
FROM STG_CUSTOMER
WHERE LOAD_STATUS='NEW';

V_COUNT NUMBER;

BEGIN

FOR REC IN C_CUSTOMER
LOOP

    -------------------------------------------------
    -- First Name Validation
    -------------------------------------------------

    IF REC.FIRST_NAME IS NULL THEN

        UPDATE STG_CUSTOMER
        SET LOAD_STATUS='FAILED',
            ERROR_MESSAGE='FIRST_NAME IS NULL'
        WHERE LOAD_ID=REC.LOAD_ID;

        CONTINUE;

    END IF;

    -------------------------------------------------
    -- Mobile Validation
    -------------------------------------------------

    IF REC.MOBILE_NO IS NULL THEN

        UPDATE STG_CUSTOMER
        SET LOAD_STATUS='FAILED',
            ERROR_MESSAGE='MOBILE NUMBER MISSING'
        WHERE LOAD_ID=REC.LOAD_ID;

        CONTINUE;

    END IF;

    -------------------------------------------------
    -- PAN Validation
    -------------------------------------------------

    IF REC.PAN_NO IS NULL THEN

        UPDATE STG_CUSTOMER
        SET LOAD_STATUS='FAILED',
            ERROR_MESSAGE='PAN NUMBER MISSING'
        WHERE LOAD_ID=REC.LOAD_ID;

        CONTINUE;

    END IF;

    -------------------------------------------------
    -- Duplicate PAN Check
    -------------------------------------------------

    SELECT COUNT(*)
    INTO V_COUNT
    FROM ODS_CUSTOMER
    WHERE PAN_NO=REC.PAN_NO;

    IF V_COUNT>0 THEN

        UPDATE STG_CUSTOMER
        SET LOAD_STATUS='FAILED',
            ERROR_MESSAGE='DUPLICATE PAN'
        WHERE LOAD_ID=REC.LOAD_ID;

        CONTINUE;

    END IF;

    -------------------------------------------------
    -- Insert into ODS
    -------------------------------------------------

    INSERT INTO ODS_CUSTOMER
    (
        CUSTOMER_ID,
        FIRST_NAME,
        LAST_NAME,
        DOB,
        MOBILE_NO,
        PAN_NO,
        EMAIL
    )
    VALUES
    (
        SEQ_CUSTOMER.NEXTVAL,
        REC.FIRST_NAME,
        REC.LAST_NAME,
        REC.DOB,
        REC.MOBILE_NO,
        REC.PAN_NO,
        REC.EMAIL
    );

    UPDATE STG_CUSTOMER
    SET LOAD_STATUS='SUCCESS',
        ERROR_MESSAGE=NULL
    WHERE LOAD_ID=REC.LOAD_ID;

END LOOP;

COMMIT;

END;
/
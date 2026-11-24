CREATE OR REPLACE PROCEDURE PRC_CUSTOMER_ETL
AS
BEGIN

    --------------------------------------------------
    -- STEP 1: VALIDATE NEW RECORDS
    --------------------------------------------------

    UPDATE STG_CUSTOMER
    SET LOAD_STATUS = 'VALID',
        ERROR_MESSAGE = NULL
    WHERE LOAD_STATUS = 'NEW'
      AND FIRST_NAME IS NOT NULL
      AND DOB IS NOT NULL
      AND MOBILE_NO IS NOT NULL
      AND REGEXP_LIKE(MOBILE_NO, '^[0-9]{10}$')
      AND PAN_NO IS NOT NULL
      AND REGEXP_LIKE(
          UPPER(PAN_NO),
          '^[A-Z]{5}[0-9]{4}[A-Z]$'
      )
      AND EMAIL IS NOT NULL
      AND REGEXP_LIKE(
          EMAIL,
          '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
      )
      AND DOB <= TRUNC(SYSDATE);


    --------------------------------------------------
    -- STEP 2: MARK INVALID RECORDS
    --------------------------------------------------

    UPDATE STG_CUSTOMER
    SET LOAD_STATUS = 'INVALID',
        ERROR_MESSAGE = 'Customer validation failed'
    WHERE LOAD_STATUS = 'NEW';


    --------------------------------------------------
    -- STEP 3: LOAD VALID RECORDS INTO ODS
    --------------------------------------------------

    MERGE INTO ODS_CUSTOMER tgt
    USING
    (
        SELECT
            LOAD_ID,
            FIRST_NAME,
            LAST_NAME,
            DOB,
            MOBILE_NO,
            PAN_NO,
            EMAIL
        FROM STG_CUSTOMER
        WHERE LOAD_STATUS = 'VALID'
    ) src
    ON (tgt.PAN_NO = src.PAN_NO)

    WHEN MATCHED THEN
        UPDATE SET
            tgt.FIRST_NAME   = src.FIRST_NAME,
            tgt.LAST_NAME    = src.LAST_NAME,
            tgt.DOB          = src.DOB,
            tgt.MOBILE_NO    = src.MOBILE_NO,
            tgt.EMAIL        = src.EMAIL,
            tgt.UPDATED_DATE = SYSDATE,
            tgt.STATUS       = 'A'

    WHEN NOT MATCHED THEN
        INSERT
        (
            CUSTOMER_ID,
            FIRST_NAME,
            LAST_NAME,
            DOB,
            MOBILE_NO,
            PAN_NO,
            EMAIL,
            CREATED_DATE,
            UPDATED_DATE,
            STATUS
        )
        VALUES
        (
            SEQ_CUSTOMER.NEXTVAL,
            src.FIRST_NAME,
            src.LAST_NAME,
            src.DOB,
            src.MOBILE_NO,
            src.PAN_NO,
            src.EMAIL,
            SYSDATE,
            SYSDATE,
            'A'
        );


    --------------------------------------------------
    -- STEP 4: LOG INVALID RECORDS
    --------------------------------------------------

    INSERT INTO ETL_ERROR_LOG
    (
        ERROR_ID,
        LOAD_ID,
        ERROR_DATE,
        PROCEDURE_NAME,
        ERROR_MESSAGE,
        ERROR_CODE,
        RECORD_DATA
    )
    SELECT
        SEQ_ERROR_LOG.NEXTVAL,
        LOAD_ID,
        SYSDATE,
        'PRC_CUSTOMER_ETL',
        ERROR_MESSAGE,
        -20001,
        'STG_CUSTOMER LOAD_ID=' || LOAD_ID
    FROM STG_CUSTOMER
    WHERE LOAD_STATUS = 'INVALID';


    --------------------------------------------------
    -- STEP 5: MARK VALID RECORDS AS PROCESSED
    --------------------------------------------------

    UPDATE STG_CUSTOMER
    SET LOAD_STATUS = 'PROCESSED'
    WHERE LOAD_STATUS = 'VALID';


    COMMIT;

END PRC_CUSTOMER_ETL;
/
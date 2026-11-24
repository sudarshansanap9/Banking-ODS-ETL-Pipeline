CREATE OR REPLACE PACKAGE BODY PKG_CUSTOMER_ETL
AS

    PROCEDURE VALIDATE_CUSTOMERS
    (
        P_RUN_ID NUMBER
    )
    AS
    BEGIN

        UPDATE STG_CUSTOMER s
        SET LOAD_STATUS = 'VALID',
            ERROR_MESSAGE = NULL
        WHERE s.LOAD_STATUS = 'NEW'
          AND EXISTS
          (
              SELECT 1
              FROM ETL_RUN_DETAIL d
              WHERE d.RUN_ID = P_RUN_ID
                AND d.LOAD_ID = s.LOAD_ID
          )
          AND s.FIRST_NAME IS NOT NULL
          AND s.DOB IS NOT NULL
          AND s.MOBILE_NO IS NOT NULL
          AND REGEXP_LIKE(s.MOBILE_NO, '^[0-9]{10}$')
          AND s.PAN_NO IS NOT NULL
          AND REGEXP_LIKE(UPPER(s.PAN_NO), '^[A-Z]{5}[0-9]{4}[A-Z]$')
          AND s.EMAIL IS NOT NULL
          AND REGEXP_LIKE(
              s.EMAIL,
              '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
          )
          AND s.DOB <= TRUNC(SYSDATE);

        UPDATE STG_CUSTOMER s
        SET LOAD_STATUS = 'INVALID',
            ERROR_MESSAGE = 'Customer validation failed'
        WHERE s.LOAD_STATUS = 'NEW'
          AND EXISTS
          (
              SELECT 1
              FROM ETL_RUN_DETAIL d
              WHERE d.RUN_ID = P_RUN_ID
                AND d.LOAD_ID = s.LOAD_ID
          );

    END VALIDATE_CUSTOMERS;


    PROCEDURE LOAD_CUSTOMERS
    (
        P_RUN_ID NUMBER
    )
    AS
    BEGIN

        MERGE INTO ODS_CUSTOMER tgt
        USING
        (
            SELECT
                s.LOAD_ID,
                s.FIRST_NAME,
                s.LAST_NAME,
                s.DOB,
                s.MOBILE_NO,
                s.PAN_NO,
                s.EMAIL
            FROM STG_CUSTOMER s
            JOIN ETL_RUN_DETAIL d
              ON d.LOAD_ID = s.LOAD_ID
             AND d.RUN_ID = P_RUN_ID
            WHERE s.LOAD_STATUS = 'VALID'
        ) src
        ON (tgt.PAN_NO = src.PAN_NO)

        WHEN MATCHED THEN
            UPDATE SET
                tgt.FIRST_NAME = src.FIRST_NAME,
                tgt.LAST_NAME = src.LAST_NAME,
                tgt.DOB = src.DOB,
                tgt.MOBILE_NO = src.MOBILE_NO,
                tgt.EMAIL = src.EMAIL,
                tgt.UPDATED_DATE = SYSDATE,
                tgt.STATUS = 'A'

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

    END LOAD_CUSTOMERS;


    PROCEDURE LOG_ERRORS
    (
        P_RUN_ID NUMBER
    )
    AS
    BEGIN

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
            s.LOAD_ID,
            SYSDATE,
            'PKG_CUSTOMER_ETL',
            s.ERROR_MESSAGE,
            -20001,
            'STG_CUSTOMER LOAD_ID=' || s.LOAD_ID
        FROM STG_CUSTOMER s
        JOIN ETL_RUN_DETAIL d
          ON d.LOAD_ID = s.LOAD_ID
         AND d.RUN_ID = P_RUN_ID
        WHERE s.LOAD_STATUS = 'INVALID';

    END LOG_ERRORS;


    PROCEDURE RUN_CUSTOMER_ETL
    AS
        V_RUN_ID NUMBER;
        V_START_TIME DATE;
        V_END_TIME DATE;
        V_RECORDS_PROCESSED NUMBER;
        V_RECORDS_FAILED NUMBER;
        V_ERROR_MESSAGE VARCHAR2(500);

    BEGIN

        V_RUN_ID := SEQ_ETL_RUN.NEXTVAL;
        V_START_TIME := SYSDATE;

        INSERT INTO ETL_RUN_LOG
        (
            RUN_ID,
            START_TIME,
            RUN_STATUS
        )
        VALUES
        (
            V_RUN_ID,
            V_START_TIME,
            'RUNNING'
        );

        INSERT INTO ETL_RUN_DETAIL
        (
            RUN_ID,
            LOAD_ID,
            RECORD_STATUS
        )
        SELECT
            V_RUN_ID,
            LOAD_ID,
            'NEW'
        FROM STG_CUSTOMER
        WHERE LOAD_STATUS = 'NEW';

        VALIDATE_CUSTOMERS(V_RUN_ID);

        LOAD_CUSTOMERS(V_RUN_ID);

        LOG_ERRORS(V_RUN_ID);

        SELECT COUNT(*)
        INTO V_RECORDS_PROCESSED
        FROM STG_CUSTOMER s
        JOIN ETL_RUN_DETAIL d
          ON d.LOAD_ID = s.LOAD_ID
         AND d.RUN_ID = V_RUN_ID
        WHERE s.LOAD_STATUS = 'VALID';

        SELECT COUNT(*)
        INTO V_RECORDS_FAILED
        FROM STG_CUSTOMER s
        JOIN ETL_RUN_DETAIL d
          ON d.LOAD_ID = s.LOAD_ID
         AND d.RUN_ID = V_RUN_ID
        WHERE s.LOAD_STATUS = 'INVALID';

        UPDATE STG_CUSTOMER s
        SET LOAD_STATUS = 'PROCESSED'
        WHERE s.LOAD_STATUS = 'VALID'
          AND EXISTS
          (
              SELECT 1
              FROM ETL_RUN_DETAIL d
              WHERE d.RUN_ID = V_RUN_ID
                AND d.LOAD_ID = s.LOAD_ID
          );

        UPDATE ETL_RUN_DETAIL d
        SET RECORD_STATUS =
        (
            SELECT s.LOAD_STATUS
            FROM STG_CUSTOMER s
            WHERE s.LOAD_ID = d.LOAD_ID
        )
        WHERE d.RUN_ID = V_RUN_ID;

        V_END_TIME := SYSDATE;

        UPDATE ETL_RUN_LOG
        SET END_TIME = V_END_TIME,
            RECORDS_PROCESSED = V_RECORDS_PROCESSED,
            RECORDS_FAILED = V_RECORDS_FAILED,
            RUN_STATUS = 'SUCCESS'
        WHERE RUN_ID = V_RUN_ID;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN

            V_END_TIME := SYSDATE;
            V_ERROR_MESSAGE := SUBSTR(SQLERRM, 1, 500);

            UPDATE ETL_RUN_LOG
            SET END_TIME = V_END_TIME,
                RUN_STATUS = 'FAILED',
                ERROR_MESSAGE = V_ERROR_MESSAGE
            WHERE RUN_ID = V_RUN_ID;

            COMMIT;

            RAISE;

    END RUN_CUSTOMER_ETL;

END PKG_CUSTOMER_ETL;
/
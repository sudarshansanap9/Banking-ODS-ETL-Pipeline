SET SERVEROUTPUT ON;

DECLARE
    V_ERROR_CODE       NUMBER;
    V_ERROR_MESSAGE    VARCHAR2(4000);
    V_LOAD_ID          NUMBER := 9999;

BEGIN

    BEGIN

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
            9003,
            'Error',
            'Logging',
            '9000000003',
            'ABCDE1234F'
        );

    EXCEPTION

        WHEN DUP_VAL_ON_INDEX THEN

            V_ERROR_CODE := SQLCODE;
            V_ERROR_MESSAGE := SQLERRM;

            INSERT INTO ETL_ERROR_LOG
            (
                LOAD_ID,
                ERROR_CODE,
                ERROR_MESSAGE
            )
            VALUES
            (
                V_LOAD_ID,
                V_ERROR_CODE,
                V_ERROR_MESSAGE
            );

            DBMS_OUTPUT.PUT_LINE(
                'Error logged successfully'
            );

    END;

END;
/
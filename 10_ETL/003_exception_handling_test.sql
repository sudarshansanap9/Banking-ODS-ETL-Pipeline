SET SERVEROUTPUT ON;

DECLARE
    V_ERROR_CODE    NUMBER;
    V_ERROR_MESSAGE VARCHAR2(4000);

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
        9002,
        'Duplicate',
        'Test',
        '9000000002',
        'ABCDE1234F'
    );

EXCEPTION

    WHEN DUP_VAL_ON_INDEX THEN

        V_ERROR_CODE := SQLCODE;
        V_ERROR_MESSAGE := SQLERRM;

        DBMS_OUTPUT.PUT_LINE(
            'Error Code: ' || V_ERROR_CODE
        );

        DBMS_OUTPUT.PUT_LINE(
            'Error Message: ' || V_ERROR_MESSAGE
        );

    WHEN OTHERS THEN

        V_ERROR_CODE := SQLCODE;
        V_ERROR_MESSAGE := SQLERRM;

        DBMS_OUTPUT.PUT_LINE(
            'Unexpected Error Code: ' || V_ERROR_CODE
        );

        DBMS_OUTPUT.PUT_LINE(
            'Unexpected Error Message: ' || V_ERROR_MESSAGE
        );

END;
/
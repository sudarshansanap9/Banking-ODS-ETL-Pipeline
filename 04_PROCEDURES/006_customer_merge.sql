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

COMMIT;
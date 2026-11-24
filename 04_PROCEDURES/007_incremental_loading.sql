/*
    ODS PROJECT
    Incremental Loading

    Purpose:
    Mark successfully processed staging records
    so they are not processed repeatedly.
*/

UPDATE STG_CUSTOMER
SET LOAD_STATUS = 'PROCESSED'
WHERE LOAD_STATUS = 'VALID';

COMMIT;
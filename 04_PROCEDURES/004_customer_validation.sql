-- Mark invalid records



UPDATE STG_CUSTOMER
SET LOAD_STATUS = 'INVALID',
    ERROR_MESSAGE =
        CASE
            WHEN FIRST_NAME IS NULL THEN 'FIRST_NAME is NULL'
            WHEN DOB IS NULL THEN 'DOB is NULL'
            WHEN MOBILE_NO IS NULL
                 OR NOT REGEXP_LIKE(MOBILE_NO, '^[0-9]{10}$')
                THEN 'Invalid MOBILE_NO'
            WHEN PAN_NO IS NULL
                 OR NOT REGEXP_LIKE(
                     UPPER(PAN_NO),
                     '^[A-Z]{5}[0-9]{4}[A-Z]$'
                 )
                THEN 'Invalid PAN_NO'
            WHEN EMAIL IS NULL
                 OR NOT REGEXP_LIKE(
                     EMAIL,
                     '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
                 )
                THEN 'Invalid EMAIL'
            WHEN DOB > TRUNC(SYSDATE)
                THEN 'DOB cannot be future date'
            ELSE NULL
        END
WHERE FIRST_NAME IS NULL
   OR DOB IS NULL
   OR MOBILE_NO IS NULL
   OR NOT REGEXP_LIKE(MOBILE_NO, '^[0-9]{10}$')
   OR PAN_NO IS NULL
   OR NOT REGEXP_LIKE(
       UPPER(PAN_NO),
       '^[A-Z]{5}[0-9]{4}[A-Z]$'
   )
   OR EMAIL IS NULL
   OR NOT REGEXP_LIKE(
       EMAIL,
       '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
   )
   OR DOB > TRUNC(SYSDATE);





   --Mark remaining NEW records as valid


   UPDATE STG_CUSTOMER
SET LOAD_STATUS = 'VALID',
    ERROR_MESSAGE = NULL
WHERE LOAD_STATUS = 'NEW';

COMMIT;



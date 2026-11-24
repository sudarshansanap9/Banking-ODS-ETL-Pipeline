CREATE OR REPLACE PACKAGE BODY PKG_CUSTOMER_ETL
AS

---------------------------------------------------

PROCEDURE LOAD_CUSTOMER
IS
BEGIN

DBMS_OUTPUT.PUT_LINE
(
'Loading Customer...'
);

END;

---------------------------------------------------

PROCEDURE VALIDATE_CUSTOMER
IS
BEGIN

DBMS_OUTPUT.PUT_LINE
(
'Validating Customer...'
);

END;

---------------------------------------------------

PROCEDURE UPDATE_AUDIT
(
P_TOTAL NUMBER,
P_SUCCESS NUMBER,
P_FAILED NUMBER
)
IS
BEGIN

DBMS_OUTPUT.PUT_LINE
(
'Updating Audit...'
);

END;

---------------------------------------------------

END PKG_CUSTOMER_ETL;
/








BEGIN

PKG_CUSTOMER_ETL.LOAD_CUSTOMER;

END;
/





PROCEDURE LOAD_CUSTOMER
IS
BEGIN

VALIDATE_CUSTOMER;

END;
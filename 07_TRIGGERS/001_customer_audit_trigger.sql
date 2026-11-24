CREATE OR REPLACE TRIGGER TRG_CUSTOMER_AUDIT
AFTER INSERT OR UPDATE OR DELETE
ON ODS_CUSTOMER
FOR EACH ROW
BEGIN

    IF INSERTING THEN

        INSERT INTO ODS_CUSTOMER_AUDIT (
            AUDIT_ID,
            CUSTOMER_ID,
            ACTION_TYPE,
            OLD_STATUS,
            NEW_STATUS,
            AUDIT_DATE,
            AUDIT_USER
        )
        VALUES (
            SEQ_CUSTOMER_AUDIT.NEXTVAL,
            :NEW.CUSTOMER_ID,
            'INSERT',
            NULL,
            :NEW.STATUS,
            SYSDATE,
            USER
        );

    ELSIF UPDATING THEN

        INSERT INTO ODS_CUSTOMER_AUDIT (
            AUDIT_ID,
            CUSTOMER_ID,
            ACTION_TYPE,
            OLD_STATUS,
            NEW_STATUS,
            AUDIT_DATE,
            AUDIT_USER
        )
        VALUES (
            SEQ_CUSTOMER_AUDIT.NEXTVAL,
            :NEW.CUSTOMER_ID,
            'UPDATE',
            :OLD.STATUS,
            :NEW.STATUS,
            SYSDATE,
            USER
        );

    ELSIF DELETING THEN

        INSERT INTO ODS_CUSTOMER_AUDIT (
            AUDIT_ID,
            CUSTOMER_ID,
            ACTION_TYPE,
            OLD_STATUS,
            NEW_STATUS,
            AUDIT_DATE,
            AUDIT_USER
        )
        VALUES (
            SEQ_CUSTOMER_AUDIT.NEXTVAL,
            :OLD.CUSTOMER_ID,
            'DELETE',
            :OLD.STATUS,
            NULL,
            SYSDATE,
            USER
        );

    END IF;

END;
/
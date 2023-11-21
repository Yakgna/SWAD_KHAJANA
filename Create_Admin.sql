--Execution Order:1
--User: Database Admin

/*
CREATE SwadKhajana_admin USER
*/
CLEAR SCREEN;
set SERVEROUTPUT on
DECLARE
    V_serial INTEGER;
    V_sid INTEGER;
    V_active_sess INTEGER;
BEGIN
    SELECT COUNT(*) INTO V_active_sess FROM V$SESSION 
    WHERE USERNAME IN ('SWADKHAJANA_ADMIN', 
                                'RESTAURANT_SK',
                                'CUSTOMER_SK',
                                'DELIVERY_EXEC_SK');
    IF (V_active_sess>=1) THEN
        FOR I IN (
            SELECT sid AS V_sid,serial# AS V_serial, username as usern FROM V$SESSION 
            WHERE USERNAME IN ('SWADKHAJANA_ADMIN', 
                                'RESTAURANT_SK',
                                'CUSTOMER_SK',
                                'DELIVERY_EXEC_SK')
        ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ' || CHR(39) || I.V_sid || ',' || I.V_serial || CHR(39) || ' IMMEDIATE';
            DBMS_OUTPUT.PUT_LINE('Connections to '||I.usern||' terminated');
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END;
        END LOOP;
    END IF;
    DBMS_LOCK.SLEEP(5);
    EXECUTE IMMEDIATE 'DROP USER SWADKHAJANA_ADMIN CASCADE';
    DBMS_OUTPUT.PUT_LINE('USER SwadKhajana_admin DROPPED');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1918 THEN
            DBMS_OUTPUT.PUT_LINE('User does not exist.');
        ELSE
         -- Handle other exceptions
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END IF;
END;
/

CREATE USER SwadKhajana_admin IDENTIFIED BY SwadhKazhana123;

ALTER USER SwadKhajana_admin QUOTA UNLIMITED ON data;

GRANT connect, resource TO SwadKhajana_admin WITH ADMIN OPTION;

GRANT
    CREATE VIEW,
    CREATE PROCEDURE,
    CREATE SEQUENCE,
    CREATE USER,
    DROP USER,
    ALTER USER
TO SwadKhajana_admin WITH ADMIN OPTION;
--Execution Order:1
--User: Database Admin

/*
CREATE SwadKhajana_admin USER
*/
set SERVEROUTPUT on

BEGIN
    EXECUTE IMMEDIATE 'DROP USER SwadKhajana_admin CASCADE';
    dbms_output.put_line('USER SwadKhajana_admin DROPPED');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('USER SwadKhajana_admin DOES NOT EXIST');
END;
/

CREATE USER swadkhajana_admin IDENTIFIED BY swadhkazhana123;

ALTER USER swadkhajana_admin
    QUOTA UNLIMITED ON data;

GRANT connect, resource TO swadkhajana_admin WITH ADMIN OPTION;

GRANT
    CREATE VIEW,
    CREATE PROCEDURE,
    CREATE SEQUENCE,
    CREATE USER,
    DROP USER,
    ALTER USER
TO swadkhajana_admin WITH ADMIN OPTION;
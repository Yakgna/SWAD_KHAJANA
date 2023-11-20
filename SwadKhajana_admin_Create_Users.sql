--Execution Order:5
--User: SwadKhajana_admin

/*
CREATE RESTAURANT USER
*/
set SERVEROUTPUT on

BEGIN
    EXECUTE IMMEDIATE 'DROP USER RESTAURANT_SK CASCADE';
    dbms_output.put_line('USER RESTAURANT_SK DROPPED');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('USER RESTAURANT_SK DOES NOT EXIST');
END;
/

CREATE USER restaurant_sk IDENTIFIED BY skrestaurant123;

ALTER USER restaurant_sk
    QUOTA UNLIMITED ON data;

GRANT connect, resource TO restaurant_sk WITH ADMIN OPTION; 


/*
CREATE CUSTOMER USER
*/
BEGIN
    EXECUTE IMMEDIATE 'DROP USER CUSTOMER_SK CASCADE';
    dbms_output.put_line('USER CUSTOMER_SK DROPPED');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('USER CUSTOMER_SK DOES NOT EXIST');
END;
/

CREATE USER customer_sk IDENTIFIED BY skcustomer123;

ALTER USER customer_sk
    QUOTA UNLIMITED ON data;

GRANT connect, resource TO customer_sk;


/*
CREATE DELIVERY EXECUTIVE USER
*/
BEGIN
    EXECUTE IMMEDIATE 'DROP USER DELIVERY_EXEC_SK CASCADE';
    dbms_output.put_line('USER DELIVERY_EXEC_SK DROPPED');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('USER DELIVERY_EXEC_SK DOES NOT EXIST');
END;
/

CREATE USER delivery_exec_sk IDENTIFIED BY skdeliveryexec123;

ALTER USER delivery_exec_sk
    QUOTA UNLIMITED ON data;

GRANT connect, resource TO delivery_exec_sk;
CREATE OR REPLACE TRIGGER validate_phone_number_cust
BEFORE INSERT OR UPDATE ON customer_details
FOR EACH ROW
DECLARE
  invalid_phone EXCEPTION;
BEGIN
  IF NOT REGEXP_LIKE(:new.phone_number, '^[0-9]{10}$') THEN
    RAISE invalid_phone;
  END IF;
EXCEPTION
  WHEN invalid_phone THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid phone number. Phone number must be a 10-digit number.');
END;
/

CREATE OR REPLACE TRIGGER validate_phone_number_del_exec
BEFORE INSERT OR UPDATE ON delivery_executive
FOR EACH ROW
DECLARE
  invalid_phone EXCEPTION;
BEGIN
  IF NOT REGEXP_LIKE(:new.phone_number, '^[0-9]{10}$') THEN
    RAISE invalid_phone;
  END IF;
EXCEPTION
  WHEN invalid_phone THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid phone number. Phone number must be a 10-digit number.');
END;
/

CREATE OR REPLACE TRIGGER check_customer_email
BEFORE INSERT OR UPDATE ON customer_details
FOR EACH ROW
DECLARE
  email_regex VARCHAR2(100) := '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
BEGIN
  IF :NEW.email_id IS NOT NULL AND NOT REGEXP_LIKE(:NEW.email_id, email_regex) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Invalid email format');
  END IF;
END;
/

CREATE OR REPLACE TRIGGER check_closing_time
BEFORE INSERT ON order_details
FOR EACH ROW
DECLARE 
    restaurant_id_temp VARCHAR(15);
    closing_time_str VARCHAR2(5);  -- HH24:MI format
    closing_hour NUMBER;
    closing_minute NUMBER;
BEGIN
    -- Get the restaurant_id from branch_address_id
    SELECT restaurant_id INTO restaurant_id_temp FROM branch_address WHERE branch_address_id = :NEW.branch_address_id;

    -- Get closing time as string in HH24:MI format
    SELECT TO_CHAR(closing_time, 'HH24:MI') INTO closing_time_str FROM restaurant WHERE restaurant_id = restaurant_id_temp;

    -- Extract hour and minute from the closing_time_str
    closing_hour := TO_NUMBER(SUBSTR(closing_time_str, 1, 2));
    closing_minute := TO_NUMBER(SUBSTR(closing_time_str, 4, 2));

    -- Check if the current time is past the closing time
    IF TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24')) > closing_hour OR
       (TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24')) = closing_hour AND TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'MI')) > closing_minute) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Order cannot be created past restaurant closing time');
    END IF;
END;
/

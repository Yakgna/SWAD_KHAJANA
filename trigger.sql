--Check if customer phone number is valid
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

--Check if executive phone number is valid
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

--Check if the email is valid
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

--Check retaurant closing time before accepting order
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

--Check if the items belong to that restaurant
CREATE OR REPLACE TRIGGER check_ordered_items
BEFORE INSERT ON ordered_items
FOR EACH ROW
DECLARE
    v_restaurant_id VARCHAR2(15);
    v_item_count NUMBER;
BEGIN
    -- Retrieve the restaurant ID for the given order
    SELECT branch_address.restaurant_id
    INTO v_restaurant_id
    FROM order_details
    JOIN branch_address ON order_details.branch_address_id = branch_address.branch_address_id
    WHERE order_details.order_id = :NEW.order_id;

    -- Check if the item belongs to the same restaurant
    IF :NEW.item_id IS NOT NULL THEN
        -- Count the items with the specified item_id and restaurant_id
        SELECT COUNT(*)
        INTO v_item_count
        FROM items
        WHERE item_id = :NEW.item_id AND restaurant_id = v_restaurant_id;

        IF v_item_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Item does not belong to the same restaurant as the order.');
        END IF;
    END IF;
END;
/
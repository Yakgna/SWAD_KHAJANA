CLEAR SCREEN;
SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE customer_pkg AS   
    PROCEDURE Upsert_customer(
        fname IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.FIRST_NAME%TYPE, 
        lname IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.LAST_NAME%TYPE,
        ph_num IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.PHONE_NUMBER%TYPE,
        e_id IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.EMAIL_ID%TYPE);
    
    PROCEDURE Upsert_delivery_address(
        p_address_id IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.DELIVERY_ADDRESS_ID%TYPE,
        p_cust_id IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.CUSTOMER_ID%TYPE,
        p_line_1 IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.ADDRESS_LINE_1%TYPE,
        p_line_2 IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.ADDRESS_LINE_2%TYPE,
        p_city IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.CITY%TYPE,
        p_state IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.STATE%TYPE,
        p_pincode IN SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.PINCODE%TYPE
    );
  
    PROCEDURE Upsert_billing_address(
        p_address_id IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.BILLING_ADDRESS_ID%TYPE,
        p_cust_id IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.CUSTOMER_ID%TYPE,
        p_line_1 IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.ADDRESS_LINE_1%TYPE,
        p_line_2 IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.ADDRESS_LINE_2%TYPE,
        p_city IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.CITY%TYPE,
        p_state IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.STATE%TYPE,
        p_pincode IN SWADKHAJANA_ADMIN.BILLING_ADDRESS.PINCODE%TYPE
    );
    
    PROCEDURE place_order(
        p_order_type_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.ORDER_TYPE_ID%TYPE,
        p_delivery_address_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.DELIVERY_ADDRESS_ID%TYPE,
        p_billing_address_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.BILLING_ADDRESS_ID%TYPE,
        p_branch_address_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.BRANCH_ADDRESS_ID%TYPE,
        p_restaurant_promo_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.RESTAURANT_PROMO_ID%TYPE,
        p_payment_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.PAYMENT_ID%TYPE,
        p_order_date IN SWADKHAJANA_ADMIN.ORDER_DETAILS.ORDER_DATE%TYPE,
        p_executive_id IN SWADKHAJANA_ADMIN.ORDER_DETAILS.EXECUTIVE_ID%TYPE,
        p_tax IN SWADKHAJANA_ADMIN.ORDER_DETAILS.TAX%TYPE
    );

    PROCEDURE add_ordered_items(
    p_item_id  IN SWADKHAJANA_ADMIN.ORDERED_ITEMS.ITEM_ID%TYPE,
    p_quantity IN SWADKHAJANA_ADMIN.ORDERED_ITEMS.QUANTITY%TYPE
    );
END customer_pkg;
/

CREATE OR REPLACE PACKAGE BODY customer_pkg AS

PROCEDURE Upsert_customer(
    fname IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.FIRST_NAME%TYPE,
    lname IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.LAST_NAME%TYPE,
    ph_num IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.PHONE_NUMBER%TYPE,
    e_id IN SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.EMAIL_ID%TYPE)
IS
BEGIN
    -- Check if the customer already exists based on email_id
    DECLARE
        v_email_id SWADKHAJANA_ADMIN.CUSTOMER_DETAILS.EMAIL_ID%TYPE;
    BEGIN
        SELECT EMAIL_ID INTO v_email_id 
        FROM SWADKHAJANA_ADMIN.CUSTOMER_DETAILS WHERE EMAIL_ID = e_id;

        -- Update the existing record
        UPDATE SWADKHAJANA_ADMIN.CUSTOMER_DETAILS
        SET FIRST_NAME = fname,
            LAST_NAME = lname,
            PHONE_NUMBER = ph_num
        WHERE EMAIL_ID = e_id;

        DBMS_OUTPUT.PUT_LINE('Customer details updated');
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            BEGIN
                -- Insert a new record if the customer doesn't exist
                INSERT INTO SWADKHAJANA_ADMIN.CUSTOMER_DETAILS (
                    CUSTOMER_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER, EMAIL_ID
                ) VALUES (
                    SWADKHAJANA_ADMIN.CUSTOMER_DETAILS_SEQ.NEXTVAL, fname, lname, ph_num, e_id
                );

                DBMS_OUTPUT.PUT_LINE('Customer added');
            EXCEPTION 
                WHEN DUP_VAL_ON_INDEX THEN
                    DBMS_OUTPUT.PUT_LINE('Phone number already tagged to a different Email address');
            END;
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Phone number already tagged to a different Email address');
    END;
    COMMIT; -- Commit the changes
EXCEPTION
    WHEN OTHERS THEN
        -- Handle other exceptions or log errors as needed
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK; -- Rollback changes if an error occurs
END Upsert_customer;

PROCEDURE Upsert_delivery_address(
    p_address_id SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.DELIVERY_ADDRESS_ID%TYPE,
    p_cust_id SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.CUSTOMER_ID%TYPE,
    p_line_1 SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.ADDRESS_LINE_1%TYPE,
    p_line_2 SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.ADDRESS_LINE_2%TYPE,
    p_city SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.CITY%TYPE,
    p_state SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.STATE%TYPE,
    p_pincode SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.PINCODE%TYPE
)
IS
BEGIN
    -- Check if the customer already exists based on email_id
    DECLARE
    v_address_id SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.Delivery_Address_Id%TYPE;
    v_customer_id SWADKHAJANA_ADMIN.DELIVERY_ADDRESS.CUSTOMER_ID%TYPE;
    BEGIN
        SELECT delivery_address_id INTO v_address_id 
        FROM SWADKHAJANA_ADMIN.DELIVERY_ADDRESS WHERE delivery_address_id = p_address_id;
        
        -- Update the existing record
        UPDATE SWADKHAJANA_ADMIN.DELIVERY_ADDRESS
        SET ADDRESS_LINE_1 = p_line_1,
            ADDRESS_LINE_2 = p_line_2,
            CITY = p_city,
            STATE = p_state,
            PINCODE = p_pincode
        WHERE DELIVERY_ADDRESS_ID = p_address_id;

        DBMS_OUTPUT.PUT_LINE('Address updated');
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            -- Insert a new record if the address id is new
            INSERT INTO SWADKHAJANA_ADMIN.DELIVERY_ADDRESS VALUES 
                 (p_address_id, p_cust_id, p_line_1, p_line_2,
                    p_city, p_state, p_pincode);
            DBMS_OUTPUT.PUT_LINE('Address added');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;   
    COMMIT; -- Commit the changes
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            DBMS_OUTPUT.PUT_LINE('Invalid customer ID');
        ELSE
            -- Handle other exceptions or log errors as needed
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        END IF;
        ROLLBACK; -- Rollback changes if an error occurs
END Upsert_delivery_address;

PROCEDURE Upsert_billing_address(
    p_address_id SWADKHAJANA_ADMIN.BILLING_ADDRESS.BILLING_ADDRESS_ID%TYPE,
    p_cust_id SWADKHAJANA_ADMIN.BILLING_ADDRESS.CUSTOMER_ID%TYPE,
    p_line_1 SWADKHAJANA_ADMIN.BILLING_ADDRESS.ADDRESS_LINE_1%TYPE,
    p_line_2 SWADKHAJANA_ADMIN.BILLING_ADDRESS.ADDRESS_LINE_2%TYPE,
    p_city SWADKHAJANA_ADMIN.BILLING_ADDRESS.CITY%TYPE,
    p_state SWADKHAJANA_ADMIN.BILLING_ADDRESS.STATE%TYPE,
    p_pincode SWADKHAJANA_ADMIN.BILLING_ADDRESS.PINCODE%TYPE
)
IS
BEGIN
    -- Check if the customer already exists based on email_id
    DECLARE
    v_address_id SWADKHAJANA_ADMIN.BILLING_ADDRESS.BILLING_ADDRESS_ID%TYPE;
    BEGIN
        SELECT billing_address_id INTO v_address_id 
        FROM SWADKHAJANA_ADMIN.BILLING_ADDRESS WHERE billing_address_id = p_address_id;
        
        -- Update the existing record
        UPDATE SWADKHAJANA_ADMIN.BILLING_ADDRESS
        SET ADDRESS_LINE_1 = p_line_1,
            ADDRESS_LINE_2 = p_line_2,
            CITY = p_city,
            STATE = p_state,
            PINCODE = p_pincode
        WHERE BILLING_ADDRESS_ID = p_address_id;

        DBMS_OUTPUT.PUT_LINE('Address updated');
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
                -- Insert a new record if the address id is new
                INSERT INTO SWADKHAJANA_ADMIN.BILLING_ADDRESS VALUES 
                (p_address_id, p_cust_id, p_line_1, p_line_2,
                    p_city, p_state, p_pincode);
                DBMS_OUTPUT.PUT_LINE('Address added');
    END;   
    COMMIT; -- Commit the changes
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            DBMS_OUTPUT.PUT_LINE('Invalid customer ID');
        ELSE
            DBMS_OUTPUT.PUT_LINE('An error occurred: '|| SQLERRM);
        END IF;
        ROLLBACK; -- Rollback changes if an error occurs
END Upsert_billing_address;
PROCEDURE place_order(
    p_order_type_id SWADKHAJANA_ADMIN.ORDER_DETAILS.ORDER_TYPE_ID%TYPE,
    p_delivery_address_id SWADKHAJANA_ADMIN.ORDER_DETAILS.DELIVERY_ADDRESS_ID%TYPE,
    p_billing_address_id SWADKHAJANA_ADMIN.ORDER_DETAILS.BILLING_ADDRESS_ID%TYPE,
    p_branch_address_id SWADKHAJANA_ADMIN.ORDER_DETAILS.BRANCH_ADDRESS_ID%TYPE,
    p_restaurant_promo_id SWADKHAJANA_ADMIN.ORDER_DETAILS.RESTAURANT_PROMO_ID%TYPE,
    p_payment_id SWADKHAJANA_ADMIN.ORDER_DETAILS.PAYMENT_ID%TYPE,
    p_order_date SWADKHAJANA_ADMIN.ORDER_DETAILS.ORDER_DATE%TYPE,
    p_executive_id SWADKHAJANA_ADMIN.ORDER_DETAILS.EXECUTIVE_ID%TYPE,
    p_tax SWADKHAJANA_ADMIN.ORDER_DETAILS.TAX%TYPE
)
IS
BEGIN
    -- Insert a new record if the order doesn't exist
INSERT INTO SWADKHAJANA_ADMIN.ORDER_DETAILS VALUES (
                                                           'OD'||SWADKHAJANA_ADMIN.ORDER_DETAILS_SEQ.NEXTVAL,
                                                           p_order_type_id,
                                                           p_branch_address_id,
                                                           'OS1',
                                                           p_executive_id,
                                                           p_delivery_address_id,
                                                           p_billing_address_id,
                                                           p_restaurant_promo_id,
                                                           p_payment_id,
                                                           p_order_date,
                                                           p_tax
                                                   );
DBMS_OUTPUT.PUT_LINE('Order added');
COMMIT; -- Commit the changes
EXCEPTION
    WHEN OTHERS THEN
        -- Handle other exceptions or log errors as needed
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
ROLLBACK; -- Rollback changes if an error occurs
END place_order;

PROCEDURE add_ordered_items(
    p_item_id  SWADKHAJANA_ADMIN.ORDERED_ITEMS.ITEM_ID%TYPE,
    p_quantity SWADKHAJANA_ADMIN.ORDERED_ITEMS.QUANTITY%TYPE
)
IS
BEGIN
    -- Insert a new record if the order doesn't exist
    INSERT INTO SWADKHAJANA_ADMIN.ORDERED_ITEMS VALUES (p_item_id, 'OD'||SWADKHAJANA_ADMIN.ORDER_DETAILS_SEQ.CURRVAL, 2);
    COMMIT; -- Commit the changes
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        UPDATE SWADKHAJANA_ADMIN.ORDERED_ITEMS SET QUANTITY=p_quantity WHERE ITEM_ID=p_item_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Updated item quantity');
    WHEN OTHERS THEN
        -- Handle other exceptions or log errors as needed
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK; -- Rollback changes if an error occurs
END add_ordered_items;
END customer_pkg;
/

EXEC customer_pkg.Upsert_customer('Eva', 'Miller', 3339997777, 'davi.jones@gmail.com');
EXEC customer_pkg.Upsert_customer('John', 'Doe', 1234567890, 'john.doe@gmail.com');
EXEC customer_pkg.Upsert_customer('Jane', 'Doe', 2345678901, 'jane.doe@gmail.com');
EXEC customer_pkg.Upsert_customer('Alice', 'Smith', 3456789012, 'alice.smith@gmail.com');
EXEC customer_pkg.Upsert_customer('Bob', 'Smith', 4567890123, 'bob.smith@gmail.com');
EXEC customer_pkg.Upsert_customer('David', 'Jones', 6789012345, 'david.jones@gmail.com');

-- Adding delivery addresses for Massachusetts and New York
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.NEXTVAL, 1, '123 Main St', 'Apt 1', 'Boston', 'Massachusetts', '02108');
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.NEXTVAL, 2, '456 Elm St', 'Apt 2', 'New York City', 'New York', '10001');
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.NEXTVAL, 3, '789 Oak St', 'Apt 3', 'Cambridge', 'Massachusetts', '02139');
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.NEXTVAL, 4, '135 Pine St', 'Apt 4', 'Albany', 'New York', '12203');
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.NEXTVAL, 5, '246 Maple St', 'Apt 5', 'Worcester', 'Massachusetts', '01608');
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.NEXTVAL, 6, '369 Birch St', 'Apt 6', 'Syracuse', 'New York', '13202');
EXEC customer_pkg.Upsert_delivery_address('DA'||SWADKHAJANA_ADMIN.DELIVERY_ADDRESS_SEQ.CURRVAL, 7, '369 Birch St', 'Apt 6', 'Syracuse', 'New York', '13202');


-- Adding billing addresses for Massachusetts and New York
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 1, '123 Main St', 'Apt 1', 'Boston', 'Massachusetts', '02108');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 2, '456 Elm St', 'Apt 2', 'New York City', 'New York', '10001');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 3, '789 Oak St', 'Apt 3', 'Cambridge', 'Massachusetts', '02139');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 4, '135 Pine St', 'Apt 4', 'Albany', 'New York', '12203');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 5, '246 Maple St', 'Apt 5', 'Worcester', 'Massachusetts', '01608');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 6, '963 Birch St', 'Unit 6', 'Syracuse', 'New York', '13202');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.CURRVAL, 7, '963 Birch St', 'Unit 6', 'Syracuse', 'New York', '13202');

--Place order 1
EXEC customer_pkg.place_order('O1', 'DA1', 'BA1', 'RBA1',  'RP1', 'P1', SYSDATE, 'DE1', 18);
EXEC customer_pkg.add_ordered_items('I1',2);
EXEC customer_pkg.add_ordered_items('I2',4);
EXEC customer_pkg.add_ordered_items('I3',1);

--Place order 2
EXEC customer_pkg.place_order('O2', 'DA2', 'BA2', 'RBA3',  NULL, 'P2', SYSDATE, 'DE2', 18);
EXEC customer_pkg.add_ordered_items('I1',2);
EXEC customer_pkg.add_ordered_items('I2',4);
EXEC customer_pkg.add_ordered_items('I3',1);

--Place order 3
EXEC customer_pkg.place_order('O3', 'DA5', 'BA5', 'RBA6',  'RP3', 'P3', SYSDATE, 'DE3', 18);
EXEC customer_pkg.add_ordered_items('I1',2);
EXEC customer_pkg.add_ordered_items('I2',4);
EXEC customer_pkg.add_ordered_items('I3',1);

--Place order 4
EXEC customer_pkg.place_order('O4', 'DA7', 'BA7', 'RBA4',  'RP5', 'P4', SYSDATE, 'DE4', 18);
EXEC customer_pkg.add_ordered_items('I1',2);
EXEC customer_pkg.add_ordered_items('I2',4);
EXEC customer_pkg.add_ordered_items('I3',1);

/*
Grant permission to CUSTOMER_SK user
*/
GRANT EXECUTE ON CUSTOMER_PKG TO CUSTOMER_SK;
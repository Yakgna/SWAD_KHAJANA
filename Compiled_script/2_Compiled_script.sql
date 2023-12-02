SET SERVEROUTPUT ON
CLEAR SCREEN;
BEGIN
    FOR j IN (
        SELECT
            constraint_name cname,
            table_name      tname
        FROM
            user_constraints
        WHERE
                constraint_type = 'R'
            AND table_name IN ( 'CUSTOMER_DETAILS', 'DELIVERY_ADDRESS', 'BILLING_ADDRESS', 'PAYMENT', 'ORDER_STATUS',
                                'RESTAURANT', 'ITEMS', 'BRANCH_ADDRESS', 'ORDER_TYPE', 'DELIVERY_EXECUTIVE',
                                'PROMO_CODES', 'RESTAURANT_PROMO', 'ORDER_DETAILS', 'ORDERED_ITEMS' )
    ) LOOP
        EXECUTE IMMEDIATE 'ALTER TABLE '
                          || j.tname
                          || ' DROP CONSTRAINT "'
                          || j.cname
                          || '"';
    END LOOP;

    FOR i IN (
        SELECT
            table_name tname
        FROM
            user_tables
        WHERE
            table_name IN ( 'CUSTOMER_DETAILS', 'DELIVERY_ADDRESS', 'BILLING_ADDRESS', 'PAYMENT', 'ORDER_STATUS',
                            'RESTAURANT', 'ITEMS', 'BRANCH_ADDRESS', 'ORDER_TYPE', 'DELIVERY_EXECUTIVE',
                            'PROMO_CODES', 'RESTAURANT_PROMO', 'ORDER_DETAILS', 'ORDERED_ITEMS' )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || i.tname;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
END;
/




CREATE TABLE customer_details (
    customer_id  NUMBER,
    first_name   VARCHAR(15) NOT NULL,
    last_name    VARCHAR(15) NOT NULL,
    phone_number NUMBER(10) UNIQUE NOT NULL,
    email_id     VARCHAR(25) UNIQUE NOT NULL,
    PRIMARY KEY ( customer_id )
);

CREATE TABLE delivery_address (
    delivery_address_id VARCHAR(15),
    customer_id         NUMBER NOT NULL,
    address_line_1      VARCHAR(50) NOT NULL,
    address_line_2      VARCHAR(50),
    city                VARCHAR(15) NOT NULL,
    state               VARCHAR(15) NOT NULL,
    pincode             VARCHAR(10) NOT NULL,
    PRIMARY KEY ( delivery_address_id ),
    CONSTRAINT "FK_Delivery_address.customer_id" FOREIGN KEY ( customer_id )
        REFERENCES customer_details ( customer_id )
);

CREATE TABLE billing_address (
    billing_address_id VARCHAR(15),
    customer_id        NUMBER NOT NULL,
    address_line_1     VARCHAR(25) NOT NULL,
    address_line_2     VARCHAR(25),
    city               VARCHAR(15) NOT NULL,
    state              VARCHAR(15) NOT NULL,
    pincode            VARCHAR(15) NOT NULL,
    PRIMARY KEY ( billing_address_id ),
    CONSTRAINT "FK_Billing_address.customer_id" FOREIGN KEY ( customer_id )
        REFERENCES customer_details ( customer_id )
);

CREATE TABLE payment (
    payment_id   VARCHAR(3),
    payment_type VARCHAR(15) UNIQUE NOT NULL,
    PRIMARY KEY ( payment_id )
);

CREATE TABLE order_status (
    order_status_id   VARCHAR(3),
    order_status_desc VARCHAR(15) UNIQUE NOT NULL,
    PRIMARY KEY ( order_status_id )
);

CREATE TABLE restaurant (
    restaurant_id   VARCHAR(15),
    restaurant_name VARCHAR(50) UNIQUE NOT NULL,
    opening_time    DATE NOT NULL,
    closing_time    DATE NOT NULL,
    PRIMARY KEY ( restaurant_id )
);

CREATE TABLE items (
    item_id       VARCHAR(15),
    restaurant_id VARCHAR(15) NOT NULL,
    item_name     VARCHAR(25) NOT NULL,
    item_price    NUMBER NOT NULL,
    PRIMARY KEY ( item_id ),
    CONSTRAINT "FK_Items.restaurant_id" FOREIGN KEY ( restaurant_id )
        REFERENCES restaurant ( restaurant_id )
);

CREATE TABLE branch_address (
    branch_address_id VARCHAR(15),
    restaurant_id     VARCHAR(15) NOT NULL,
    phone_number      NUMBER(10) NOT NULL,
    address_line_1    VARCHAR(25) NOT NULL,
    address_line_2    VARCHAR(25),
    city              VARCHAR(15) NOT NULL,
    state             VARCHAR(15) NOT NULL,
    pincode           VARCHAR(10) NOT NULL,
    PRIMARY KEY ( branch_address_id ),
    CONSTRAINT "FK_Branch_address.restaurant_id" FOREIGN KEY ( restaurant_id )
        REFERENCES restaurant ( restaurant_id ),
    CONSTRAINT unique_address UNIQUE (address_line_1, address_line_2, city, state, pincode)
);

CREATE TABLE order_type (
    order_type_id   VARCHAR(2),
    order_type_name VARCHAR(15) UNIQUE NOT NULL,
    PRIMARY KEY ( order_type_id )
);

CREATE TABLE delivery_executive (
    executive_id VARCHAR(15),
    first_name   VARCHAR(25) NOT NULL,
    last_name    VARCHAR(25) NOT NULL,
    dob          DATE NOT NULL,
    phone_number NUMBER UNIQUE NOT NULL,
    PRIMARY KEY ( executive_id )
);

CREATE TABLE promo_codes (
    promo_id         VARCHAR(10),
    offer_percentage NUMBER,
    PRIMARY KEY ( promo_id )
);

CREATE TABLE restaurant_promo (
    restaurant_promo_id VARCHAR(10),
    promo_id            VARCHAR(10) NOT NULL,
    restaurant_id       VARCHAR(15) NOT NULL,
    PRIMARY KEY ( restaurant_promo_id ),
    CONSTRAINT "FK_Restaurant_Promo.promo_id" FOREIGN KEY ( promo_id )
        REFERENCES promo_codes ( promo_id ),
    CONSTRAINT "FK_Restaurant_Promo.restaurant_id" FOREIGN KEY ( restaurant_id )
        REFERENCES restaurant ( restaurant_id )
);

CREATE TABLE order_details (
    order_id            VARCHAR(15),
    order_type_id       VARCHAR(2) NOT NULL,
    branch_address_id   VARCHAR(15) NOT NULL,
    order_status_id     VARCHAR(3) NOT NULL,
    executive_id        VARCHAR(15),
    delivery_address_id VARCHAR(15) NOT NULL,
    billing_address_id  VARCHAR(15) NOT NULL,
    restaurant_promo_id VARCHAR(10),
    payment_id          VARCHAR(3) NOT NULL,
    order_date          DATE NOT NULL,
    tax                 NUMBER NOT NULL,
    PRIMARY KEY ( order_id ),
    CONSTRAINT "FK_Order_details.payment_id" FOREIGN KEY ( payment_id )
        REFERENCES payment ( payment_id ),
    CONSTRAINT "FK_Order_details.order_status_id" FOREIGN KEY ( order_status_id )
        REFERENCES order_status ( order_status_id ),
    CONSTRAINT "FK_Order_details.branch_address_id" FOREIGN KEY ( branch_address_id )
        REFERENCES branch_address ( branch_address_id ),
    CONSTRAINT "FK_Order_details.billing_address_id" FOREIGN KEY ( billing_address_id )
        REFERENCES billing_address ( billing_address_id ),
    CONSTRAINT "FK_Order_details.order_type_id" FOREIGN KEY ( order_type_id )
        REFERENCES order_type ( order_type_id ),
    CONSTRAINT "FK_Order_details.delivery_address_id" FOREIGN KEY ( delivery_address_id )
        REFERENCES delivery_address ( delivery_address_id ),
    CONSTRAINT "FK_Order_details.executive_id" FOREIGN KEY ( executive_id )
        REFERENCES delivery_executive ( executive_id ),
    CONSTRAINT "FK_Order_details.restaurant_promo_id" FOREIGN KEY ( restaurant_promo_id )
        REFERENCES restaurant_promo ( restaurant_promo_id )
);

CREATE TABLE ordered_items (
    item_id  VARCHAR(10),
    order_id VARCHAR(25),
    quantity NUMBER NOT NULL,
    PRIMARY KEY ( item_id,
                  order_id ),
    CONSTRAINT "FK_Ordered_items.item_id" FOREIGN KEY ( item_id )
        REFERENCES items ( item_id ),
    CONSTRAINT "FK_Ordered_items.order_id" FOREIGN KEY ( order_id )
        REFERENCES order_details ( order_id )
);

/*
------------------------------------------------------------------------------------
-------------------------------- Create Sequences ----------------------------------
------------------------------------------------------------------------------------
*/

BEGIN
    FOR i IN (
        SELECT
            SEQUENCE_NAME tname
        FROM
            USER_SEQUENCES
        WHERE
            SEQUENCE_NAME IN ( 'BILLING_ADDRESS_SEQ',
                            'BRANCH_ADDRESS_SEQ',
                            'CUSTOMER_DETAILS_SEQ',
                            'DELIVERY_ADDRESS_SEQ',
                            'DELIVERY_EXECUTIVE_SEQ',
                            'ITEMS_SEQ',
                            'ORDER_DETAILS_SEQ',
                            'ORDER_ITEMS_SEQ',
                            'ORDER_STATUS_SEQ',
                            'ORDER_TYPE_SEQ',
                            'PAYMENT_SEQ',
                            'PROMO_CODES_SEQ',
                            'RESTAURANT_PROMO_SEQ',
                            'RESTAURANT_SEQ' )
    ) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || i.tname;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm);
END;
/

CREATE SEQUENCE delivery_address_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE billing_address_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE payment_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_status_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE restaurant_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE items_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE branch_address_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_type_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE delivery_executive_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE promo_codes_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE restaurant_promo_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_details_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE order_items_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE customer_details_seq START WITH 1 INCREMENT BY 1;

 
/*
------------------------------------------------------------------------------------
---------------------------------- Insert data -------------------------------------
------------------------------------------------------------------------------------
*/
----Payment
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Credit Card');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Debit Card');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Cash');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Check');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Online Transfer');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Mobile Payment');

----Order_status
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Placed');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Received');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Processing');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Ready');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Dispatched');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Delivered');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Cancelled');

---- Order_type
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Pickup');
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Delivery');
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Drive-Thru');
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Inter-state');

/*
CREATE RESTAURANT USER
*/

BEGIN
    EXECUTE IMMEDIATE 'DROP USER RESTAURANT_SK CASCADE';
    dbms_output.put_line('USER RESTAURANT_SK DROPPED');
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('USER RESTAURANT_SK DOES NOT EXIST');
END;
/

CREATE USER RESTAURANT_SK IDENTIFIED BY SKRestaurant123;

ALTER USER RESTAURANT_SK
    QUOTA UNLIMITED ON data;

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

CREATE USER CUSTOMER_SK IDENTIFIED BY SKCustomer123;

ALTER USER CUSTOMER_SK
    QUOTA UNLIMITED ON data;


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

CREATE USER DELIVERY_EXEC_SK IDENTIFIED BY SKDeliveryexec123;

ALTER USER DELIVERY_EXEC_SK
    QUOTA UNLIMITED ON data;

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


CREATE OR REPLACE PROCEDURE upsert_delivery_executive(
    p_executive_id SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.executive_id%TYPE,
    p_first_name   SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.first_name%TYPE,
    p_last_name    SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.last_name%TYPE,
    p_dob          SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.dob%TYPE,
    p_phone_number SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.phone_number%TYPE
) 
AS
BEGIN
    IF p_executive_id IS NULL THEN
        INSERT INTO SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE VALUES 
            ('DE'||SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE_SEQ.NEXTVAL, p_first_name, p_last_name, p_dob, p_phone_number);
        DBMS_OUTPUT.PUT_LINE('New Delivery Executive details added');
    ELSE
        UPDATE SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE
        SET
            first_name = p_first_name,
            last_name = p_last_name,
            dob = p_dob,
            phone_number = p_phone_number
        WHERE executive_id = p_executive_id;
    DBMS_OUTPUT.PUT_LINE('Details updated for executive '||p_executive_id);
    END IF;
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
       DBMS_OUTPUT.PUT_LINE('Phone number already tagged to a different executive'); 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
        ROLLBACK;
END upsert_delivery_executive;
/

CREATE OR REPLACE PROCEDURE update_order_status(
    p_order_id SWADKHAJANA_ADMIN.ORDER_DETAILS.ORDER_ID%TYPE,
    p_order_status_id SWADKHAJANA_ADMIN.ORDER_DETAILS.ORDER_status_ID%TYPE
    )
    IS
    BEGIN
        UPDATE SWADKHAJANA_ADMIN.ORDER_DETAILS 
        SET order_status_id=p_order_status_id
        WHERE order_id=p_order_id;
        COMMIT; -- Commit the changes
    EXCEPTION
        WHEN OTHERS THEN
            -- Handle other exceptions or log errors as needed
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK; -- Rollback changes if an error occurs
END update_order_status;
/


CREATE OR REPLACE PACKAGE RESTAURANT_PACKAGE AS 
    -- Declaring the procedures
    PROCEDURE UPSERT_ITEM(
        p_item_id IN SWADKHAJANA_ADMIN.ITEMS.ITEM_ID%TYPE,
        p_restaurant_id IN SWADKHAJANA_ADMIN.ITEMS.RESTAURANT_ID%TYPE,
        p_item_name IN SWADKHAJANA_ADMIN.ITEMS.ITEM_NAME%TYPE,
        p_item_price IN SWADKHAJANA_ADMIN.ITEMS.ITEM_PRICE%TYPE
    );

    PROCEDURE UPSERT_PROMO_CODE(
        p_promo_id IN SWADKHAJANA_ADMIN.PROMO_CODES.PROMO_ID%TYPE,
        p_offer_percentage IN SWADKHAJANA_ADMIN.PROMO_CODES.OFFER_PERCENTAGE%TYPE
    );

    PROCEDURE UPSERT_RESTAURANT_PROMO(
        p_restaurant_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE,
        p_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.PROMO_ID%TYPE,
        p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_ID%TYPE
    );

    PROCEDURE UPSERT_BRANCH_ADDRESS(
        p_branch_address_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.BRANCH_ADDRESS_ID%TYPE, 
        p_restaurant_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.RESTAURANT_ID%TYPE, 
        p_phone_number IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PHONE_NUMBER%TYPE, 
        p_address_line1 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_1%TYPE, 
        p_address_line2 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_2%TYPE, 
        p_city IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.CITY%TYPE, 
        p_state IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.STATE%TYPE, 
        p_pincode IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PINCODE%TYPE
    );

    PROCEDURE UPSERT_RESTAURANT(
        p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_ID%TYPE,
        p_restaurant_name IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_NAME%TYPE,
        p_opening_time IN SWADKHAJANA_ADMIN.RESTAURANT.OPENING_TIME%TYPE,
        p_closing_time IN SWADKHAJANA_ADMIN.RESTAURANT.CLOSING_TIME%TYPE
    );

END RESTAURANT_PACKAGE;
/

CREATE OR REPLACE PACKAGE BODY RESTAURANT_PACKAGE AS
    -- Implementation for UPSERT_ITEM
    PROCEDURE UPSERT_ITEM(
            p_item_id IN SWADKHAJANA_ADMIN.ITEMS.ITEM_ID%TYPE, 
            p_restaurant_id IN SWADKHAJANA_ADMIN.ITEMS.RESTAURANT_ID%TYPE, 
            p_item_name IN SWADKHAJANA_ADMIN.ITEMS.ITEM_NAME%TYPE, 
            p_item_price IN SWADKHAJANA_ADMIN.ITEMS.ITEM_PRICE%TYPE) 
    IS
    BEGIN
        IF p_item_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.items (item_id, restaurant_id, item_name, item_price)
            VALUES ('I'||SWADKHAJANA_ADMIN.ITEMS_SEQ.NEXTVAL, p_restaurant_id, p_item_name, p_item_price);
        ELSE 
            UPDATE SWADKHAJANA_ADMIN.items
                SET restaurant_id = p_restaurant_id,
                    item_name = p_item_name,
                    item_price = p_item_price
            WHERE item_id = p_item_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_ITEM;

    -- Implementation for UPSERT_PROMO_CODE
    PROCEDURE UPSERT_PROMO_CODE(
            p_promo_id IN SWADKHAJANA_ADMIN.PROMO_CODES.PROMO_ID%TYPE, 
            p_offer_percentage IN SWADKHAJANA_ADMIN.PROMO_CODES.OFFER_PERCENTAGE%TYPE) 
    IS
    BEGIN
        IF p_promo_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.promo_codes (promo_id, offer_percentage)
            VALUES ('PR'||SWADKHAJANA_ADMIN.PROMO_CODES_SEQ.NEXTVAL, p_offer_percentage);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.promo_codes
            SET offer_percentage = p_offer_percentage
            WHERE promo_id = p_promo_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_PROMO_CODE;

    -- Implementation for UPSERT_RESTAURANT_PROMO
    PROCEDURE UPSERT_RESTAURANT_PROMO(
            p_restaurant_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE, 
            p_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.PROMO_ID%TYPE, 
            p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_ID%TYPE) 
    IS
    BEGIN
        IF p_restaurant_promo_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.restaurant_promo (restaurant_promo_id, promo_id, restaurant_id)
            VALUES ('RP'||SWADKHAJANA_ADMIN.RESTAURANT_PROMO_SEQ.NEXTVAL, p_promo_id, p_restaurant_id);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.restaurant_promo
                SET promo_id = p_promo_id,
                restaurant_id = p_restaurant_id
            WHERE restaurant_promo_id = p_restaurant_promo_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_RESTAURANT_PROMO;

    -- Implementation for INSERT_BRANCH_ADDRESS_PROC
    PROCEDURE UPSERT_BRANCH_ADDRESS(
            p_branch_address_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.BRANCH_ADDRESS_ID%TYPE, 
            p_restaurant_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.RESTAURANT_ID%TYPE, 
            p_phone_number IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PHONE_NUMBER%TYPE, 
            p_address_line1 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_1%TYPE, 
            p_address_line2 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_2%TYPE, 
            p_city IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.CITY%TYPE, 
            p_state IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.STATE%TYPE, 
            p_pincode IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PINCODE%TYPE) 
    IS
    BEGIN
        IF p_branch_address_id IS NULL THEN 
            INSERT INTO SWADKHAJANA_ADMIN.branch_address (branch_address_id, restaurant_id, phone_number, address_line_1, address_line_2, city, state, pincode)
            VALUES ('RBA'||SWADKHAJANA_ADMIN.BRANCH_ADDRESS_SEQ.NEXTVAL, p_restaurant_id, p_phone_number, p_address_line1, p_address_line2, p_city, p_state, p_pincode);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.branch_address SET
                restaurant_id = p_restaurant_id,
                phone_number = p_phone_number,
                address_line_1 = p_address_line1, 
                address_line_2 = p_address_line2, 
                city = p_city, 
                state = p_state, 
                pincode = p_pincode
            WHERE branch_address_id = p_branch_address_id; 
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Address already exists');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_BRANCH_ADDRESS;

    -- Implementation for upsert_restaurant
    PROCEDURE UPSERT_RESTAURANT(
        p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_ID%TYPE, 
        p_restaurant_name IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_NAME%TYPE, 
        p_opening_time IN SWADKHAJANA_ADMIN.RESTAURANT.OPENING_TIME%TYPE, 
        p_closing_time IN SWADKHAJANA_ADMIN.RESTAURANT.CLOSING_TIME%TYPE) 
    IS
    v_seq_count INTEGER;
    v_id INTEGER:=SWADKHAJANA_ADMIN.RESTAURANT_SEQ.NEXTVAL;
    BEGIN
        IF p_restaurant_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.restaurant (restaurant_id, restaurant_name, opening_time, closing_time)
            VALUES ('R'||v_id, p_restaurant_name, p_opening_time, p_closing_time);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.restaurant
            SET restaurant_name = p_restaurant_name,
                opening_time = p_opening_time,
                closing_time = p_closing_time
            WHERE restaurant_id = p_restaurant_id;    
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Restaurant name already exists');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_RESTAURANT;
END RESTAURANT_PACKAGE;
/


CREATE OR REPLACE FUNCTION SWADKHAJANA_ADMIN.FNCALCULATEORDERTOTALAMOUNT (
    f_orderId IN NUMBER,
    f_offer_id NUMBER,
    f_tax NUMBER
)
RETURN NUMBER
IS
    orderTotalAmount DECIMAL(10,2);
    max_disc DECIMAL(10,2);
BEGIN
    -- Calculate order total amount
    SELECT COALESCE(SUM(i.ITEM_PRICE * oi.QUANTITY), 0) INTO orderTotalAmount
    FROM SWADKHAJANA_ADMIN.ORDERED_ITEMS oi
    JOIN SWADKHAJANA_ADMIN.ITEMS i ON oi.ITEM_ID = i.ITEM_ID
    WHERE oi.ORDER_ID = f_orderId;
    
    -- Get maximum discount for the coupon
    SELECT COALESCE(c.OFFER_PERCENTAGE, 0) INTO max_disc
    FROM SWADKHAJANA_ADMIN.PROMO_CODES c
    JOIN SWADKHAJANA_ADMIN.RESTAURANT_PROMO rcr ON c.PROMO_ID = rcr.PROMO_ID
    WHERE rcr.RESTAURANT_PROMO_ID = f_offer_id;

    -- Ensure max_disc does not exceed orderTotalAmount
    max_disc := LEAST(max_disc, orderTotalAmount);

    orderTotalAmount := GREATEST(orderTotalAmount - max_disc, 0) + f_tax + f_delivery_charge;

    RETURN orderTotalAmount;
END;
/



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
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE=-20001 THEN
            DBMS_OUTPUT.PUT_LINE('Item does not belong to the same restaurant as the order.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
        END IF;
END;
/

-------------------------------------
--Add data using Restaurant Package
-------------------------------------

--Add restaurant details
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Burger Hub', TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Seafood Delight', TO_DATE('11:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Mountain View Cafe', TO_DATE('07:30:00', 'HH24:MI:SS'), TO_DATE('20:00:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Urban Eats', TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('23:30:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Garden Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Urban Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Countryside Grill', TO_DATE('12:00:00', 'HH24:MI:SS'), TO_DATE('22:30:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Sushi Haven', TO_DATE('11:30:00', 'HH24:MI:SS'), TO_DATE('23:00:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Pasta Paradise', TO_DATE('12:30:00', 'HH24:MI:SS'), TO_DATE('21:00:00', 'HH24:MI:SS'));
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Mediterranean Delights', TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:30:00', 'HH24:MI:SS'));

--Add Branch Address 
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R1', 9876543210, '123 Burger St', 'Suite 101', 'Boston', 'Massachusetts', '78901');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R6', 8765432190, '456 Seafood Rd', 'Suite 102', 'New York City', 'New York', '89012');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R3', 7654321980, '789 Cafe Blvd', 'Suite 103', 'Cambridge', 'Massachusetts', '90123');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R3', 6543219870, '135 Urban Way', 'Suite 104', 'Albany', 'New York', '01234');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R4', 5432198760, '246 Bistro Ln', 'Suite 105', 'Worcester', 'Massachusetts', '12345');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R5', 4321987650, '369 Diner Ave', 'Suite 106', 'Buffalo', 'New York', '23456');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R6', 3210987654, '789 Sushi Plaza', 'Suite 107', 'Springfield', 'Massachusetts', '34567');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R7', 2109876543, '123 Pasta Lane', 'Suite 108', 'Syracuse', 'New York', '45678');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R8', 1098765432, '456 BBQ Street', 'Suite 109', 'Lowell', 'Massachusetts', '56789');
EXEC RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R9', 0987654321, '789 Tacos Road', 'Suite 110', 'Rochester', 'New York', '67890');
 
--Add Items
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Chicken Sandwich', 6.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Caesar Salad', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'French Fries', 3.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Chocolate Shake', 4.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'BBQ Bacon Burger', 9.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Garlic Parmesan Wings', 7.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Vegetarian Wrap', 8.49);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Classic Onion Rings', 5.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Vanilla Ice Cream Shake', 5.49);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Grilled Veggie Skewers', 9.49);
   
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Margherita Pizza', 10.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Pasta Alfredo', 7.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Garlic Bread', 4.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Tiramisu', 6.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Chicken Caesar Salad', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Shrimp Scampi', 12.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Caprese Sandwich', 6.75);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Steak Frites', 14.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Lobster Bisque', 9.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Chocolate Fondant', 8.99);
 		  
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'BBQ Ribs', 15.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Shrimp Scampi', 11.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Mashed Potatoes', 3.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Cheesecake', 5.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Grilled Salmon', 18.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Caesar Salad', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Garlic Breadsticks', 4.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Vegetarian Pizza', 14.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Chicken Alfredo Pasta', 12.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Tiramisu', 6.99);
  
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Steak Fajitas', 13.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Chicken Quesadilla', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Guacamole', 2.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Salsa and Chips', 3.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Steak Fajitas', 13.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Chicken Quesadilla', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Guacamole', 2.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Salsa and Chips', 3.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Mexican Rice', 4.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Churros', 5.50);
  	  
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Espresso', 2.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Chocolate Croissant', 3.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Fruit Salad', 4.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Iced Latte', 5.99); 
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Espresso', 2.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Chocolate Croissant', 3.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Fruit Salad', 4.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Iced Latte', 5.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Blueberry Muffin', 3.75);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Avocado Toast', 6.50);

EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Chicken Tandoori', 14.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Butter Chicken', 12.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Vegetable Biryani', 10.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Garlic Naan', 3.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Mango Lassi', 4.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Palak Paneer', 11.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Kheema Pav', 9.75);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Dal Makhani', 8.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Chicken Curry', 13.25);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Gulab Jamun', 5.99);
  
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Spaghetti Bolognese', 13.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Margherita Pasta', 11.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Chicken Alfredo', 15.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Garlic Bread', 4.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Tiramisu', 6.75);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Caesar Salad', 8.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Bruschetta', 5.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Caprese Pizza', 12.25);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Pesto Penne', 10.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Lemon Sorbet', 4.50);
  
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Classic Sushi Roll', 9.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Sashimi Platter', 14.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Teriyaki Chicken Bowl', 12.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Miso Soup', 3.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Edamame', 5.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Dragon Roll', 16.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Tempura Udon', 11.75);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Green Tea Ice Cream', 6.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Rainbow Poke Bowl', 13.25);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Sushi Burrito', 8.99);

EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Classic Burger', 9.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Crispy Chicken Sandwich', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Vegetarian Wrap', 7.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Sweet Potato Fries', 4.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Chocolate Shake', 5.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Caprese Salad', 6.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Margherita Pizza', 11.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Chicken Caesar Wrap', 9.25);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Garlic Parmesan Wings', 12.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Oreo Cheesecake', 7.99);

EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Classic Caesar Wrap', 8.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Caprese Panini', 10.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Quinoa Salad', 7.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Sweet Potato Fries', 4.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Pumpkin Spice Latte', 5.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Vegetarian Pizza', 11.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Mushroom Risotto', 12.99);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Avocado Toast', 9.25);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Berry Smoothie Bowl', 6.50);
EXEC RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Chocolate Avocado Mousse', 7.99);
  
--Add promo codes
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 10);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 15);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 20);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 5);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 25);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 30);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 8);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 18);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 12);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 22);
EXEC RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 15);

--Add restaurant promo
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR1', 'R1');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR2', 'R2');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR3', 'R3');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR4', 'R4');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR5', 'R5');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR6', 'R6');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR7', 'R7');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR8', 'R8');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR9', 'R9');
EXEC RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR10', 'R10');

--Add Delivery executive details
EXEC upsert_delivery_executive(NULL, 'Emma', 'Brown', TO_DATE('1990-01-15', 'YYYY-MM-DD'), 1122334455);
EXEC upsert_delivery_executive(NULL, 'Liam', 'Johnson', TO_DATE('1988-05-22', 'YYYY-MM-DD'), 2233445566);
EXEC upsert_delivery_executive(NULL, 'Olivia', 'Williams', TO_DATE('1992-07-30', 'YYYY-MM-DD'), 3344556677);
EXEC upsert_delivery_executive(NULL, 'Noah', 'Davis', TO_DATE('1989-11-09', 'YYYY-MM-DD'), 4455667788);
EXEC upsert_delivery_executive(NULL, 'Ava', 'Miller', TO_DATE('1991-04-17', 'YYYY-MM-DD'), 5566778899);
EXEC upsert_delivery_executive(NULL, 'William', 'Wilson', TO_DATE('1987-02-25', 'YYYY-MM-DD'), 6677889900);
EXEC upsert_delivery_executive(NULL, 'Sophia', 'Taylor', TO_DATE('1995-09-12', 'YYYY-MM-DD'), 7788990011);
--Updating details
EXEC upsert_delivery_executive('DE7', 'Sophia', 'Wilson', TO_DATE('1995-09-12', 'YYYY-MM-DD'), 7788990011);


-------------------------------------
--Add data using Customer Package
-------------------------------------
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

-- Adding billing addresses for Massachusetts and New York
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 1, '123 Main St', 'Apt 1', 'Boston', 'Massachusetts', '02108');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 2, '456 Elm St', 'Apt 2', 'New York City', 'New York', '10001');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 3, '789 Oak St', 'Apt 3', 'Cambridge', 'Massachusetts', '02139');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 4, '135 Pine St', 'Apt 4', 'Albany', 'New York', '12203');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 5, '246 Maple St', 'Apt 5', 'Worcester', 'Massachusetts', '01608');
EXEC customer_pkg.Upsert_billing_address('BA'||SWADKHAJANA_ADMIN.BILLING_ADDRESS_SEQ.NEXTVAL, 6, '963 Birch St', 'Unit 6', 'Syracuse', 'New York', '13202');

-- Create views

-- 1. Top Restaurants View
CREATE OR REPLACE VIEW View_Top_Restaurants AS
SELECT r.restaurant_id, r.restaurant_name, COUNT(*) as order_count
FROM Order_details od
JOIN Branch_address ba ON od.branch_address_id = ba.branch_address_id
JOIN Restaurant r ON ba.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY order_count DESC;

-- 2. Top Food Items View
CREATE OR REPLACE VIEW View_Top_Items AS
SELECT i.item_id, i.item_name, SUM(oi.quantity) as order_count
FROM Ordered_items oi
JOIN Items i ON oi.item_id = i.item_id
GROUP BY i.item_id, i.item_name
ORDER BY order_count DESC;

-- 3. Menu View
CREATE OR REPLACE VIEW View_Menu AS
SELECT i.item_id, i.item_name, i.item_price, r.restaurant_name
FROM Items i
JOIN Restaurant r ON i.restaurant_id = r.restaurant_id;

-- 4. Delivery Details View
CREATE OR REPLACE VIEW View_Delivery_Details AS
SELECT
    od.order_id,
    od.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    de.executive_id,
    de.first_name || ' ' || de.last_name AS delivery_boy_name,
    da.address_line_1 || ', ' || da.address_line_2 || ', ' || da.city || ', ' || da.state || ', ' || da.pincode AS delivery_address
FROM
    Order_details od
JOIN
    Delivery_executive de ON od.executive_id = de.executive_id
JOIN
    Delivery_address da ON od.delivery_address_id = da.delivery_address_id
JOIN
    Customer_details c ON da.customer_id = c.customer_id;
 
-- 5. Customer Order Details View
CREATE OR REPLACE VIEW View_Customer_Order AS
SELECT
    od.order_id,
    os.order_status_desc,
    p.payment_type,
    r.restaurant_name,
    ot.order_type_name,
    od.order_date,
    od.tax,
    oi.quantity,
    i.item_name,
    i.item_price,
    pc.offer_percentage,
    ROUND((oi.quantity * i.item_price), 2) AS total_price,
    ROUND((oi.quantity * i.item_price * pc.offer_percentage / 100), 2) AS discount_amount,
    ROUND(((oi.quantity * i.item_price) - (oi.quantity * i.item_price * pc.offer_percentage / 100)), 2) AS discounted_price,
    ROUND((oi.quantity * i.item_price * od.tax / 100), 2) AS tax_amount,
    FNCALCULATEORDERTOTALAMOUNT (od.order_id,pc.promo_id,ROUND((oi.quantity * i.item_price * od.tax / 100), 2)) AS gross_amount
FROM
    Order_details od
JOIN Order_status os ON od.order_status_id = os.order_status_id
JOIN Ordered_items oi ON oi.order_id = od.order_id
JOIN Items i ON oi.item_id = i.item_id
JOIN Payment p ON od.payment_id = p.payment_id
JOIN Order_type ot ON od.order_type_id = ot.order_type_id
JOIN BRANCH_ADDRESS ba ON od.BRANCH_ADDRESS_ID = ba.BRANCH_ADDRESS_ID
JOIN RESTAURANT r ON r.RESTAURANT_ID = ba.RESTAURANT_ID
JOIN Restaurant_promo rp ON od.restaurant_promo_id = rp.restaurant_promo_id
JOIN Promo_codes pc ON rp.promo_id = pc.promo_id;
 
-- 6. Restaurant Coupon Relation View
CREATE OR REPLACE VIEW View_Restaurant_Promo AS
SELECT rp.restaurant_promo_id, pc.promo_id, pc.offer_percentage
FROM Restaurant_Promo rp
JOIN Promo_codes pc ON rp.promo_id = pc.promo_id;

--------------------------------------------------------------------------
--Grant User permissions
--------------------------------------------------------------------------
/*
Grant permissions to RESTAURANT_SK
*/
GRANT connect, resource TO RESTAURANT_SK WITH ADMIN OPTION;
GRANT SELECT ON DELIVERY_ADDRESS TO RESTAURANT_SK;
GRANT SELECT ON BILLING_ADDRESS TO RESTAURANT_SK;
GRANT SELECT ON CUSTOMER_DETAILS TO RESTAURANT_SK;
GRANT SELECT ON ORDERED_ITEMS TO RESTAURANT_SK;
GRANT SELECT, UPDATE ON ORDER_DETAILS TO RESTAURANT_SK;
GRANT SELECT ON PAYMENT TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON ORDER_STATUS TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON RESTAURANT TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON ITEMS TO RESTAURANT_SK;
GRANT SELECT ON ORDER_TYPE TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON BRANCH_ADDRESS TO RESTAURANT_SK;
GRANT SELECT ON DELIVERY_EXECUTIVE TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON RESTAURANT_PROMO TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON PROMO_CODES TO RESTAURANT_SK;
--Grant permissions on Views
GRANT SELECT, INSERT, UPDATE ON VIEW_TOP_ITEMS TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON VIEW_MENU TO RESTAURANT_SK;
GRANT SELECT, INSERT, UPDATE ON VIEW_RESTAURANT_PROMO TO RESTAURANT_SK;
--Grant permissions on Sequences
GRANT SELECT ON BRANCH_ADDRESS_SEQ TO RESTAURANT_SK;
GRANT SELECT ON PROMO_CODES_SEQ TO RESTAURANT_SK;
GRANT SELECT ON RESTAURANT_PROMO_SEQ TO RESTAURANT_SK;
GRANT SELECT ON RESTAURANT_SEQ TO RESTAURANT_SK;
GRANT SELECT ON ITEMS_SEQ TO RESTAURANT_SK;
--Grant permission on package and procedures
GRANT EXECUTE ON RESTAURANT_PACKAGE TO RESTAURANT_SK;
GRANT EXECUTE ON update_order_status TO RESTAURANT_SK;

/*
Grant permissions to CUSTOMER_SK
*/
GRANT connect, resource TO CUSTOMER_SK;
GRANT SELECT, INSERT, UPDATE ON DELIVERY_ADDRESS TO CUSTOMER_SK;
GRANT SELECT, INSERT, UPDATE ON BILLING_ADDRESS TO CUSTOMER_SK;
GRANT SELECT, INSERT, UPDATE ON CUSTOMER_DETAILS TO CUSTOMER_SK;
GRANT SELECT, INSERT, UPDATE ON ORDERED_ITEMS TO CUSTOMER_SK;
GRANT SELECT, INSERT, UPDATE ON ORDER_DETAILS TO CUSTOMER_SK;
GRANT SELECT ON PAYMENT TO CUSTOMER_SK;
GRANT SELECT ON ORDER_STATUS TO CUSTOMER_SK;
GRANT SELECT ON RESTAURANT TO CUSTOMER_SK;
GRANT SELECT ON ITEMS TO CUSTOMER_SK;
GRANT SELECT ON ORDER_TYPE TO CUSTOMER_SK;
GRANT SELECT ON BRANCH_ADDRESS TO CUSTOMER_SK;
GRANT SELECT ON DELIVERY_EXECUTIVE TO CUSTOMER_SK;
GRANT SELECT ON RESTAURANT_PROMO TO CUSTOMER_SK;
--Grant permissions on Views
GRANT SELECT ON VIEW_CUSTOMER_ORDER TO CUSTOMER_SK;
GRANT SELECT ON VIEW_TOP_RESTAURANTS TO CUSTOMER_SK;
GRANT SELECT ON VIEW_TOP_ITEMS TO CUSTOMER_SK;
GRANT SELECT ON VIEW_MENU TO CUSTOMER_SK;
GRANT SELECT ON VIEW_RESTAURANT_PROMO TO CUSTOMER_SK;
--Grant permissions on Sequences
GRANT SELECT ON CUSTOMER_DETAILS_SEQ TO CUSTOMER_SK;
GRANT SELECT ON DELIVERY_ADDRESS_SEQ TO CUSTOMER_SK;
GRANT SELECT ON BILLING_ADDRESS_SEQ TO CUSTOMER_SK;
GRANT SELECT ON ORDER_ITEMS_SEQ TO CUSTOMER_SK;
GRANT SELECT ON ORDER_DETAILS_SEQ TO CUSTOMER_SK;
--Grant permission on package and procedures
GRANT EXECUTE ON CUSTOMER_PKG TO CUSTOMER_SK;
GRANT EXECUTE ON update_order_status TO CUSTOMER_SK;

/*
Grant permissions to DELIVERY_EXEC_SK
*/
GRANT connect, resource TO DELIVERY_EXEC_SK;
GRANT SELECT ON DELIVERY_ADDRESS TO DELIVERY_EXEC_SK;
GRANT SELECT ON CUSTOMER_DETAILS TO DELIVERY_EXEC_SK;
GRANT SELECT ON ORDERED_ITEMS TO DELIVERY_EXEC_SK;
GRANT SELECT, UPDATE ON ORDER_DETAILS TO DELIVERY_EXEC_SK;
GRANT SELECT ON PAYMENT TO DELIVERY_EXEC_SK;
GRANT SELECT, INSERT, UPDATE ON ORDER_STATUS TO DELIVERY_EXEC_SK;
GRANT SELECT ON RESTAURANT TO DELIVERY_EXEC_SK;
GRANT SELECT ON ITEMS TO DELIVERY_EXEC_SK;
GRANT SELECT ON ORDER_TYPE TO DELIVERY_EXEC_SK;
GRANT SELECT ON BRANCH_ADDRESS TO DELIVERY_EXEC_SK;
GRANT SELECT, INSERT, UPDATE ON DELIVERY_EXECUTIVE TO DELIVERY_EXEC_SK;
GRANT SELECT ON RESTAURANT_PROMO TO DELIVERY_EXEC_SK;
--Grant Permissions to views
GRANT SELECT ON View_Customer_Order TO DELIVERY_EXEC_SK;
GRANT SELECT ON View_Delivery_Details TO DELIVERY_EXEC_SK;
--Grant permissions on Sequences
GRANT SELECT ON DELIVERY_EXECUTIVE_SEQ TO DELIVERY_EXEC_SK;
--Grant permission on package and procedures
GRANT EXECUTE ON upsert_delivery_executive TO DELIVERY_EXEC_SK;
GRANT EXECUTE ON update_order_status TO DELIVERY_EXEC_SK;
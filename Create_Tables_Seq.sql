--Execution Order:2
--User: SwadKhajana_admin

CLEAR SCREEN;
SET SERVEROUTPUT ON

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
        REFERENCES order_details ( order_id ),
    CONSTRAINT unique_items UNIQUE (item_id, order_id)
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
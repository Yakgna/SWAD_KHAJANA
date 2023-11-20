--Execution Order:2
--User: SwadKhajana_admin

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
    first_name   VARCHAR(15),
    last_name    VARCHAR(15),
    phone_number NUMBER(10),
    email_id     VARCHAR(25),
    PRIMARY KEY ( customer_id )
);

CREATE TABLE delivery_address (
    delivery_address_id VARCHAR(15),
    customer_id         NUMBER,
    address_line_1      VARCHAR(50),
    address_line_2      VARCHAR(50),
    city                VARCHAR(15),
    state               VARCHAR(15),
    pincode             VARCHAR(10),
    PRIMARY KEY ( delivery_address_id ),
    CONSTRAINT "FK_Delivery_address.customer_id" FOREIGN KEY ( customer_id )
        REFERENCES customer_details ( customer_id )
);

CREATE TABLE billing_address (
    billing_address_id VARCHAR(15),
    customer_id        NUMBER,
    address_line_1     VARCHAR(25),
    address_line_2     VARCHAR(25),
    city               VARCHAR(15),
    state              VARCHAR(15),
    pincode            VARCHAR(15),
    PRIMARY KEY ( billing_address_id ),
    CONSTRAINT "FK_Billing_address.customer_id" FOREIGN KEY ( customer_id )
        REFERENCES customer_details ( customer_id )
);

CREATE TABLE payment (
    payment_id   VARCHAR(3),
    payment_type VARCHAR(15),
    PRIMARY KEY ( payment_id )
);

CREATE TABLE order_status (
    order_status_id   VARCHAR(3),
    order_status_desc VARCHAR(15),
    PRIMARY KEY ( order_status_id )
);

CREATE TABLE restaurant (
    restaurant_id   VARCHAR(15),
    restaurant_name VARCHAR(25),
    opening_time    DATE,
    closing_time    DATE,
    PRIMARY KEY ( restaurant_id )
);

CREATE TABLE items (
    item_id       VARCHAR(15),
    restaurant_id VARCHAR(15),
    item_name     VARCHAR(25),
    item_price    NUMBER,
    PRIMARY KEY ( item_id ),
    CONSTRAINT "FK_Items.restaurant_id" FOREIGN KEY ( restaurant_id )
        REFERENCES restaurant ( restaurant_id )
);

CREATE TABLE branch_address (
    branch_address_id VARCHAR(15),
    restaurant_id     VARCHAR(15),
    phone_number      NUMBER(10),
    address_line_1    VARCHAR(25),
    address_line_2    VARCHAR(25),
    city              VARCHAR(15),
    state             VARCHAR(15),
    pincode           VARCHAR(10),
    PRIMARY KEY ( branch_address_id ),
    CONSTRAINT "FK_Branch_address.restaurant_id" FOREIGN KEY ( restaurant_id )
        REFERENCES restaurant ( restaurant_id )
);

CREATE TABLE order_type (
    order_type_id   VARCHAR(2),
    order_type_name VARCHAR(15),
    PRIMARY KEY ( order_type_id )
);

CREATE TABLE delivery_executive (
    executive_id VARCHAR(15),
    first_name   VARCHAR(25),
    last_name    VARCHAR(25),
    dob          DATE,
    phone_number NUMBER,
    PRIMARY KEY ( executive_id )
);

CREATE TABLE promo_codes (
    promo_id         VARCHAR(10),
    offer_percentage NUMBER,
    PRIMARY KEY ( promo_id )
);

CREATE TABLE restaurant_promo (
    restaurant_promo_id VARCHAR(10),
    promo_id            VARCHAR(10),
    restautant_id       VARCHAR(15),
    PRIMARY KEY ( restaurant_promo_id ),
    CONSTRAINT "FK_Restaurant_Promo.promo_id" FOREIGN KEY ( promo_id )
        REFERENCES promo_codes ( promo_id ),
    CONSTRAINT "FK_Restaurant_Promo.restautant_id" FOREIGN KEY ( restautant_id )
        REFERENCES restaurant ( restaurant_id )
);

CREATE TABLE order_details (
    order_id            VARCHAR(15),
    order_type_id       VARCHAR(2),
    branch_address_id   VARCHAR(15),
    order_status_id     VARCHAR(3),
    executive_id        VARCHAR(15),
    delivery_address_id VARCHAR(15),
    billing_address_id  VARCHAR(15),
    restaurant_promo_id VARCHAR(10),
    payment_id          VARCHAR(3),
    order_date          DATE,
    tax                 NUMBER,
    gross_amount        NUMBER,
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
    quantity NUMBER,
    PRIMARY KEY ( item_id,
                  order_id ),
    CONSTRAINT "FK_Ordered_items.item_id" FOREIGN KEY ( item_id )
        REFERENCES items ( item_id ),
    CONSTRAINT "FK_Ordered_items.order_id" FOREIGN KEY ( order_id )
        REFERENCES order_details ( order_id )
);
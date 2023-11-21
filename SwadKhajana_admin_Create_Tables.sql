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
    restaurant_name VARCHAR(50) NOT NULL,
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
        REFERENCES restaurant ( restaurant_id )
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
    gross_amount        NUMBER NOT NULL,
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


-- Assuming the first_name and last_name fields are VARCHAR(15), and phone_number is a NUMBER(10)
INSERT INTO Customer_details VALUES (1, 'John', 'Doe', 1234567890, 'john.doe@email.com');
INSERT INTO Customer_details VALUES (2, 'Jane', 'Doe', 2345678901, 'jane.doe@email.com');
INSERT INTO Customer_details VALUES (3, 'Alice', 'Smith', 3456789012, 'alice.smith@email.com');
INSERT INTO Customer_details VALUES (4, 'Bob', 'Smith', 4567890123, 'bob.smith@email.com');
INSERT INTO Customer_details VALUES (5, 'Carol', 'Jones', 5678901234, 'carol.jones@email.com');
INSERT INTO Customer_details VALUES (6, 'David', 'Jones', 6789012345, 'david.jones@email.com');



--Delivery_address

-- Assuming address_line_1 and address_line_2 are VARCHAR(50), and city, state, pincode are VARCHAR(15)
INSERT INTO Delivery_address VALUES ('DA001', 1, '123 Main St', 'Apt 1', 'CityA', 'StateA', '12345');
INSERT INTO Delivery_address VALUES ('DA002', 2, '456 Elm St', 'Apt 2', 'CityB', 'StateB', '23456');
INSERT INTO Delivery_address VALUES ('DA003', 3, '789 Oak St', 'Apt 3', 'CityC', 'StateC', '34567');
INSERT INTO Delivery_address VALUES ('DA004', 4, '135 Pine St', 'Apt 4', 'CityD', 'StateD', '45678');
INSERT INTO Delivery_address VALUES ('DA005', 5, '246 Maple St', 'Apt 5', 'CityE', 'StateE', '56789');
INSERT INTO Delivery_address VALUES ('DA006', 6, '369 Birch St', 'Apt 6', 'CityF', 'StateF', '67890');

--Billing_address
-- Assuming address_line_1 and address_line_2 are VARCHAR(25), and city, state, pincode are VARCHAR(15)
INSERT INTO Billing_address VALUES ('BA001', 1, '321 Main St', 'Unit 1', 'CityA', 'StateA', '12345');
INSERT INTO Billing_address VALUES ('BA002', 2, '654 Elm St', 'Unit 2', 'CityB', 'StateB', '23456');
INSERT INTO Billing_address VALUES ('BA003', 3, '987 Oak St', 'Unit 3', 'CityC', 'StateC', '34567');
INSERT INTO Billing_address VALUES ('BA004', 4, '531 Pine St', 'Unit 4', 'CityD', 'StateD', '45678');
INSERT INTO Billing_address VALUES ('BA005', 5, '642 Maple St', 'Unit 5', 'CityE', 'StateE', '56789');
INSERT INTO Billing_address VALUES ('BA006', 6, '963 Birch St', 'Unit 6', 'CityF', 'StateF', '67890');


--Payment

-- Assuming payment_type is VARCHAR(15)
INSERT INTO Payment VALUES ('P01', 'Credit Card');
INSERT INTO Payment VALUES ('P02', 'Debit Card');
INSERT INTO Payment VALUES ('P03', 'Cash');
INSERT INTO Payment VALUES ('P04', 'Check');
INSERT INTO Payment VALUES ('P05', 'Online Transfer');
INSERT INTO Payment VALUES ('P06', 'Mobile Payment');


--Order_status
-- Assuming order_status_desc is VARCHAR(15)
INSERT INTO Order_status VALUES ('OS1', 'Received');
INSERT INTO Order_status VALUES ('OS2', 'Processing');
INSERT INTO Order_status VALUES ('OS3', 'Ready');
INSERT INTO Order_status VALUES ('OS4', 'Dispatched');
INSERT INTO Order_status VALUES ('OS5', 'Delivered');
INSERT INTO Order_status VALUES ('OS6', 'Cancelled');


--Restaurant
INSERT INTO Restaurant VALUES ('R006', 'Burger Hub', TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R007', 'Seafood Delight', TO_DATE('11:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R008', 'Mountain View Cafe', TO_DATE('07:30:00', 'HH24:MI:SS'), TO_DATE('20:00:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R009', 'Urban Eats', TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('23:30:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R010', 'Garden Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R011', 'The Downtown Diner', TO_DATE('06:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));

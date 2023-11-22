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
--Customer_details
INSERT INTO Customer_details VALUES (CUSTOMER_DETAILS_SEQ.NEXTVAL, 'John', 'Doe', 1234567890, 'john.doe@email.com');
INSERT INTO Customer_details VALUES (CUSTOMER_DETAILS_SEQ.NEXTVAL, 'Jane', 'Doe', 2345678901, 'jane.doe@email.com');
INSERT INTO Customer_details VALUES (CUSTOMER_DETAILS_SEQ.NEXTVAL, 'Alice', 'Smith', 3456789012, 'alice.smith@email.com');
INSERT INTO Customer_details VALUES (CUSTOMER_DETAILS_SEQ.NEXTVAL, 'Bob', 'Smith', 4567890123, 'bob.smith@email.com');
INSERT INTO Customer_details VALUES (CUSTOMER_DETAILS_SEQ.NEXTVAL, 'Carol', 'Jones', 5678901234, 'carol.jones@email.com');
INSERT INTO Customer_details VALUES (CUSTOMER_DETAILS_SEQ.NEXTVAL, 'David', 'Jones', 6789012345, 'david.jones@email.com');

--Delivery_address
INSERT INTO Delivery_address VALUES ('DA'||DELIVERY_ADDRESS_SEQ.NEXTVAL, 1, '123 Main St', 'Apt 1', 'CityA', 'StateA', '12345');
INSERT INTO Delivery_address VALUES ('DA'||DELIVERY_ADDRESS_SEQ.NEXTVAL, 2, '456 Elm St', 'Apt 2', 'CityB', 'StateB', '23456');
INSERT INTO Delivery_address VALUES ('DA'||DELIVERY_ADDRESS_SEQ.NEXTVAL, 3, '789 Oak St', 'Apt 3', 'CityC', 'StateC', '34567');
INSERT INTO Delivery_address VALUES ('DA'||DELIVERY_ADDRESS_SEQ.NEXTVAL, 4, '135 Pine St', 'Apt 4', 'CityD', 'StateD', '45678');
INSERT INTO Delivery_address VALUES ('DA'||DELIVERY_ADDRESS_SEQ.NEXTVAL, 5, '246 Maple St', 'Apt 5', 'CityE', 'StateE', '56789');
INSERT INTO Delivery_address VALUES ('DA'||DELIVERY_ADDRESS_SEQ.NEXTVAL, 6, '369 Birch St', 'Apt 6', 'CityF', 'StateF', '67890');

--Billing_address
INSERT INTO Billing_address VALUES ('BA'||BILLING_ADDRESS_SEQ.NEXTVAL, 1, '321 Main St', 'Unit 1', 'CityA', 'StateA', '12345');
INSERT INTO Billing_address VALUES ('BA'||BILLING_ADDRESS_SEQ.NEXTVAL, 2, '654 Elm St', 'Unit 2', 'CityB', 'StateB', '23456');
INSERT INTO Billing_address VALUES ('BA'||BILLING_ADDRESS_SEQ.NEXTVAL, 3, '987 Oak St', 'Unit 3', 'CityC', 'StateC', '34567');
INSERT INTO Billing_address VALUES ('BA'||BILLING_ADDRESS_SEQ.NEXTVAL, 4, '531 Pine St', 'Unit 4', 'CityD', 'StateD', '45678');
INSERT INTO Billing_address VALUES ('BA'||BILLING_ADDRESS_SEQ.NEXTVAL, 5, '642 Maple St', 'Unit 5', 'CityE', 'StateE', '56789');
INSERT INTO Billing_address VALUES ('BA'||BILLING_ADDRESS_SEQ.NEXTVAL, 6, '963 Birch St', 'Unit 6', 'CityF', 'StateF', '67890');


--Payment
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Credit Card');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Debit Card');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Cash');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Check');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Online Transfer');
INSERT INTO Payment VALUES ('P'||PAYMENT_SEQ.NEXTVAL, 'Mobile Payment');

--Order_status
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Received');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Processing');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Ready');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Dispatched');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Delivered');
INSERT INTO Order_status VALUES ('OS'||ORDER_STATUS_SEQ.nextval, 'Cancelled');

--Restaurant
INSERT INTO Restaurant VALUES ('R'||RESTAURANT_SEQ.NEXTVAL, 'Burger Hub', TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R'||RESTAURANT_SEQ.NEXTVAL, 'Seafood Delight', TO_DATE('11:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R'||RESTAURANT_SEQ.NEXTVAL, 'Mountain View Cafe', TO_DATE('07:30:00', 'HH24:MI:SS'), TO_DATE('20:00:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R'||RESTAURANT_SEQ.NEXTVAL, 'Urban Eats', TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('23:30:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R'||RESTAURANT_SEQ.NEXTVAL, 'Garden Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R'||RESTAURANT_SEQ.NEXTVAL, 'The Downtown Diner', TO_DATE('06:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));

--Branch_address
INSERT INTO Branch_address VALUES ('BA'||BRANCH_ADDRESS_SEQ.NEXTVAL, 'R1', 9876543210, '123 Burger St', 'Suite 101', 'CityG', 'StateG', '78901');
INSERT INTO Branch_address VALUES ('BA'||BRANCH_ADDRESS_SEQ.NEXTVAL, 'R2', 8765432190, '456 Seafood Rd', 'Suite 102', 'CityH', 'StateH', '89012');
INSERT INTO Branch_address VALUES ('BA'||BRANCH_ADDRESS_SEQ.NEXTVAL, 'R3', 7654321980, '789 Cafe Blvd', 'Suite 103', 'CityI', 'StateI', '90123');
INSERT INTO Branch_address VALUES ('BA'||BRANCH_ADDRESS_SEQ.NEXTVAL, 'R3', 6543219870, '135 Urban Way', 'Suite 104', 'CityJ', 'StateJ', '01234');
INSERT INTO Branch_address VALUES ('BA'||BRANCH_ADDRESS_SEQ.NEXTVAL, 'R4', 5432198760, '246 Bistro Ln', 'Suite 105', 'CityK', 'StateK', '12345');
INSERT INTO Branch_address VALUES ('BA'||BRANCH_ADDRESS_SEQ.NEXTVAL, 'R5', 4321987650, '369 Diner Ave', 'Suite 106', 'CityL', 'StateL', '23456');

--Delivery_executive
INSERT INTO Delivery_executive VALUES ('DE'||DELIVERY_EXECUTIVE_SEQ.NEXTVAL, 'Emma', 'Brown', TO_DATE('1990-01-15', 'YYYY-MM-DD'), 1122334455);
INSERT INTO Delivery_executive VALUES ('DE'||DELIVERY_EXECUTIVE_SEQ.NEXTVAL, 'Liam', 'Johnson', TO_DATE('1988-05-22', 'YYYY-MM-DD'), 2233445566);
INSERT INTO Delivery_executive VALUES ('DE'||DELIVERY_EXECUTIVE_SEQ.NEXTVAL, 'Olivia', 'Williams', TO_DATE('1992-07-30', 'YYYY-MM-DD'), 3344556677);
INSERT INTO Delivery_executive VALUES ('DE'||DELIVERY_EXECUTIVE_SEQ.NEXTVAL, 'Noah', 'Davis', TO_DATE('1989-11-09', 'YYYY-MM-DD'), 4455667788);
INSERT INTO Delivery_executive VALUES ('DE'||DELIVERY_EXECUTIVE_SEQ.NEXTVAL, 'Ava', 'Miller', TO_DATE('1991-04-17', 'YYYY-MM-DD'), 5566778899);
INSERT INTO Delivery_executive VALUES ('DE'||DELIVERY_EXECUTIVE_SEQ.NEXTVAL, 'William', 'Wilson', TO_DATE('1987-02-25', 'YYYY-MM-DD'), 6677889900);

--Promo_codes
INSERT INTO Promo_codes VALUES ('PR'||PROMO_CODES_SEQ.NEXTVAL, 10);
INSERT INTO Promo_codes VALUES ('PR'||PROMO_CODES_SEQ.NEXTVAL, 15);
INSERT INTO Promo_codes VALUES ('PR'||PROMO_CODES_SEQ.NEXTVAL, 20);
INSERT INTO Promo_codes VALUES ('PR'||PROMO_CODES_SEQ.NEXTVAL, 5);
INSERT INTO Promo_codes VALUES ('PR'||PROMO_CODES_SEQ.NEXTVAL, 25);
INSERT INTO Promo_codes VALUES ('PR'||PROMO_CODES_SEQ.NEXTVAL, 30);

--Restaurant_promo relation
INSERT INTO Restaurant_promo VALUES ('RP'||RESTAURANT_PROMO_SEQ.NEXTVAL, 'PR1', 'R1');
INSERT INTO Restaurant_promo VALUES ('RP'||RESTAURANT_PROMO_SEQ.NEXTVAL, 'PR2', 'R2');
INSERT INTO Restaurant_promo VALUES ('RP'||RESTAURANT_PROMO_SEQ.NEXTVAL, 'PR3', 'R3');
INSERT INTO Restaurant_promo VALUES ('RP'||RESTAURANT_PROMO_SEQ.NEXTVAL, 'PR4', 'R4');
INSERT INTO Restaurant_promo VALUES ('RP'||RESTAURANT_PROMO_SEQ.NEXTVAL, 'PR5', 'R5');
INSERT INTO Restaurant_promo VALUES ('RP'||RESTAURANT_PROMO_SEQ.NEXTVAL, 'PR6', 'R6');

-- Items
INSERT INTO Items VALUES ('I'||ITEMS_SEQ.NEXTVAL, 'R1', 'Cheeseburger', 5.99);
INSERT INTO Items VALUES ('I'||ITEMS_SEQ.NEXTVAL, 'R2', 'Veggie Burger', 4.99);
INSERT INTO Items VALUES ('I'||ITEMS_SEQ.NEXTVAL, 'R3', 'Grilled Salmon', 12.99);
INSERT INTO Items VALUES ('I'||ITEMS_SEQ.NEXTVAL, 'R4', 'Fish Tacos', 9.99);
INSERT INTO Items VALUES ('I'||ITEMS_SEQ.NEXTVAL, 'R5', 'Cappuccino', 3.50);
INSERT INTO Items VALUES ('I'||ITEMS_SEQ.NEXTVAL, 'R6', 'Blueberry Muffin', 2.99);

-- Order_type
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Pickup');
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Delivery');
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Drive-Thru');
INSERT INTO Order_type VALUES ('O'||ORDER_TYPE_SEQ.NEXTVAL, 'Inter-state');

INSERT INTO Order_details VALUES ('OD'||ORDER_DETAILS_SEQ.NEXTVAL, 'O1', 'BA1', 'OS1', 'DE1', 'DA1', 'BA1', 'RP1', 'P1', SYSDATE, 1.5);
INSERT INTO Order_details VALUES ('OD'||ORDER_DETAILS_SEQ.NEXTVAL, 'O2', 'BA2', 'OS2', 'DE2', 'DA2', 'BA2', 'RP2', 'P2', SYSDATE, 2.0);
INSERT INTO Order_details VALUES ('OD'||ORDER_DETAILS_SEQ.NEXTVAL, 'O3', 'BA3', 'OS3', 'DE3', 'DA3', 'BA3', 'RP3', 'P3', SYSDATE, 1.0);
INSERT INTO Order_details VALUES ('OD'||ORDER_DETAILS_SEQ.NEXTVAL, 'O1', 'BA4', 'OS4', 'DE4', 'DA4', 'BA4', 'RP4', 'P4', SYSDATE, 2.5);
INSERT INTO Order_details VALUES ('OD'||ORDER_DETAILS_SEQ.NEXTVAL, 'O2', 'BA5', 'OS5', 'DE5', 'DA5', 'BA5', 'RP5', 'P5', SYSDATE, 1.8);
INSERT INTO Order_details VALUES ('OD'||ORDER_DETAILS_SEQ.NEXTVAL, 'O3', 'BA6', 'OS6', 'DE6', 'DA6', 'BA6', 'RP6', 'P6', SYSDATE, 2.2);

INSERT INTO Ordered_items VALUES ('I1', 'OD1', 2);
INSERT INTO Ordered_items VALUES ('I2', 'OD1', 1);
INSERT INTO Ordered_items VALUES ('I3', 'OD2', 3);
INSERT INTO Ordered_items VALUES ('I4', 'OD3', 1);
INSERT INTO Ordered_items VALUES ('I5', 'OD4', 2);
INSERT INTO Ordered_items VALUES ('I6', 'OD5', 1);
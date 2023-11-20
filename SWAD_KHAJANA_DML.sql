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
INSERT INTO Order_status VALUES ('OS06', 'Cancelled');


--Restaurant
INSERT INTO Restaurant VALUES ('R006', 'Burger Hub', TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R007', 'Seafood Delight', TO_DATE('11:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R008', 'Mountain View Cafe', TO_DATE('07:30:00', 'HH24:MI:SS'), TO_DATE('20:00:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R009', 'Urban Eats', TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('23:30:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R010', 'Garden Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
INSERT INTO Restaurant VALUES ('R011', 'The Downtown Diner', TO_DATE('06:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));



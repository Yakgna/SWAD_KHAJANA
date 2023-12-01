-------------------------------------
--Add data using Restaurant Package
-------------------------------------
CLEAR SCREEN;
--Add restaurant details
BEGIN
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Burger Hub', TO_DATE('10:00:00', 'HH24:MI:SS'), TO_DATE('23:59:59', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Seafood Delight', TO_DATE('11:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Mountain View Cafe', TO_DATE('07:30:00', 'HH24:MI:SS'), TO_DATE('20:00:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Urban Eats', TO_DATE('09:00:00', 'HH24:MI:SS'), TO_DATE('23:30:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Garden Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Urban Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('21:30:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Countryside Grill', TO_DATE('12:00:00', 'HH24:MI:SS'), TO_DATE('22:30:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Sushi Haven', TO_DATE('11:30:00', 'HH24:MI:SS'), TO_DATE('23:00:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Pasta Paradise', TO_DATE('12:30:00', 'HH24:MI:SS'), TO_DATE('21:00:00', 'HH24:MI:SS'));
    RESTAURANT_PACKAGE.UPSERT_RESTAURANT(NULL, 'Mediterranean Delights', TO_DATE('10:30:00', 'HH24:MI:SS'), TO_DATE('22:30:00', 'HH24:MI:SS'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding restaurants: ' || SQLERRM);
END;
/
--Add Branch Address
BEGIN
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R1', 9876543210, '123 Burger St', 'Suite 101', 'Boston', 'Massachusetts', '78901');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R6', 8765432190, '456 Seafood Rd', 'Suite 102', 'New York City', 'New York', '89012');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R3', 7654321980, '789 Cafe Blvd', 'Suite 103', 'Cambridge', 'Massachusetts', '90123');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R3', 6543219870, '135 Urban Way', 'Suite 104', 'Albany', 'New York', '01234');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R4', 5432198760, '246 Bistro Ln', 'Suite 105', 'Worcester', 'Massachusetts', '12345');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R5', 4321987650, '369 Diner Ave', 'Suite 106', 'Buffalo', 'New York', '23456');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R6', 3210987654, '789 Sushi Plaza', 'Suite 107', 'Springfield', 'Massachusetts', '34567');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R7', 2109876543, '123 Pasta Lane', 'Suite 108', 'Syracuse', 'New York', '45678');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R8', 1098765432, '456 BBQ Street', 'Suite 109', 'Lowell', 'Massachusetts', '56789');
    RESTAURANT_PACKAGE.UPSERT_BRANCH_ADDRESS(NULL, 'R9', 0987654321, '789 Tacos Road', 'Suite 110', 'Rochester', 'New York', '67890');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding branch addresses: ' || SQLERRM);
END;
/
	 
--Add Items
BEGIN
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Chicken Sandwich', 6.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Caesar Salad', 8.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'French Fries', 3.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Chocolate Shake', 4.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'BBQ Bacon Burger', 9.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Garlic Parmesan Wings', 7.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Vegetarian Wrap', 8.49);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Classic Onion Rings', 5.99);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Vanilla Ice Cream Shake', 5.49);
    RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R1', 'Grilled Veggie Skewers', 9.49);
			  
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/
BEGIN 
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Margherita Pizza', 10.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Pasta Alfredo', 7.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Garlic Bread', 4.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Tiramisu', 6.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Chicken Caesar Salad', 8.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Shrimp Scampi', 12.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Caprese Sandwich', 6.75);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Steak Frites', 14.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Lobster Bisque', 9.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R2', 'Chocolate Fondant', 8.99);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/


BEGIN		  
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'BBQ Ribs', 15.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Shrimp Scampi', 11.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Mashed Potatoes', 3.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Cheesecake', 5.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Grilled Salmon', 18.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Caesar Salad', 8.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Garlic Breadsticks', 4.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Vegetarian Pizza', 14.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Chicken Alfredo Pasta', 12.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R3', 'Tiramisu', 6.99);
	
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Steak Fajitas', 13.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Chicken Quesadilla', 8.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Guacamole', 2.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Salsa and Chips', 3.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Steak Fajitas', 13.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Chicken Quesadilla', 8.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Guacamole', 2.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Salsa and Chips', 3.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Mexican Rice', 4.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R4', 'Churros', 5.50);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN	  
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Espresso', 2.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Chocolate Croissant', 3.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Fruit Salad', 4.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Iced Latte', 5.99); 
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Espresso', 2.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Chocolate Croissant', 3.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Fruit Salad', 4.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Iced Latte', 5.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Blueberry Muffin', 3.75);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R5', 'Avocado Toast', 6.50);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Chicken Tandoori', 14.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Butter Chicken', 12.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Vegetable Biryani', 10.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Garlic Naan', 3.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Mango Lassi', 4.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Palak Paneer', 11.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Kheema Pav', 9.75);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Dal Makhani', 8.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Chicken Curry', 13.25);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R6', 'Gulab Jamun', 5.99);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Spaghetti Bolognese', 13.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Margherita Pasta', 11.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Chicken Alfredo', 15.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Garlic Bread', 4.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Tiramisu', 6.75);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Caesar Salad', 8.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Bruschetta', 5.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Caprese Pizza', 12.25);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Pesto Penne', 10.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R7', 'Lemon Sorbet', 4.50);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Classic Sushi Roll', 9.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Sashimi Platter', 14.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Teriyaki Chicken Bowl', 12.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Miso Soup', 3.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Edamame', 5.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Dragon Roll', 16.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Tempura Udon', 11.75);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Green Tea Ice Cream', 6.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Rainbow Poke Bowl', 13.25);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R8', 'Sushi Burrito', 8.99);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/
BEGIN
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Classic Burger', 9.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Crispy Chicken Sandwich', 8.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Vegetarian Wrap', 7.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Sweet Potato Fries', 4.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Chocolate Shake', 5.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Caprese Salad', 6.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Margherita Pizza', 11.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Chicken Caesar Wrap', 9.25);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Garlic Parmesan Wings', 12.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R9', 'Oreo Cheesecake', 7.99);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Classic Caesar Wrap', 8.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Caprese Panini', 10.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Quinoa Salad', 7.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Sweet Potato Fries', 4.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Pumpkin Spice Latte', 5.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Vegetarian Pizza', 11.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Mushroom Risotto', 12.99);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Avocado Toast', 9.25);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Berry Smoothie Bowl', 6.50);
 RESTAURANT_PACKAGE.UPSERT_ITEM(NULL, 'R10', 'Chocolate Avocado Mousse', 7.99);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding items: ' || SQLERRM);
END;
/

BEGIN
--Add promo codes
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 10);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 15);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 20);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 5);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 25);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 30);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 8);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 18);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 12);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 22);
 RESTAURANT_PACKAGE.UPSERT_PROMO_CODE(NULL, 15);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding promo codes: ' || SQLERRM);
END;
/

BEGIN
	
--Add restaurant promo
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR1', 'R1');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR2', 'R2');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR3', 'R3');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR4', 'R4');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR5', 'R5');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR6', 'R6');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR7', 'R7');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR8', 'R8');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR9', 'R9');
 RESTAURANT_PACKAGE.UPSERT_RESTAURANT_PROMO(NULL, 'PR10', 'R10');
 EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred in adding restaurant promos: ' || SQLERRM);
END;
/


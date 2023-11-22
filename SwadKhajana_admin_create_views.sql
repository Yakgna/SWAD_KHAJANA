--Execution Order:3
--User: SwadKhajana_admin

-- Clear screen and set server output
CLEAR SCREEN;
SET SERVEROUTPUT ON;

-- Create views

-- 1. Top Restaurants View
CREATE OR REPLACE VIEW Top_Restaurants AS
SELECT r.restaurant_id, r.restaurant_name, COUNT(*) as order_count
FROM Order_details od
JOIN Branch_address ba ON od.branch_address_id = ba.branch_address_id
JOIN Restaurant r ON ba.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY order_count DESC;

-- 2. Top Food Items View
CREATE OR REPLACE VIEW Top_Food_Items AS
SELECT i.item_id, i.item_name, COUNT(*) as order_count
FROM Ordered_items oi
JOIN Items i ON oi.item_id = i.item_id
GROUP BY i.item_id, i.item_name
ORDER BY order_count DESC;

-- 3. Menu View
CREATE OR REPLACE VIEW Menu_View AS
SELECT i.item_id, i.item_name, i.item_price, r.restaurant_name
FROM Items i
JOIN Restaurant r ON i.restaurant_id = r.restaurant_id;

-- 4. Delivery Details View
CREATE OR REPLACE VIEW Delivery_Details AS
SELECT od.order_id, od.order_date, de.executive_id, de.first_name || ' ' || de.last_name AS delivery_boy_name, da.address_line_1 || ', ' || da.address_line_2 || ', ' || da.city || ', ' || da.state || ', ' || da.pincode AS delivery_address
FROM Order_details od
JOIN Delivery_executive de ON od.executive_id = de.executive_id
JOIN Delivery_address da ON od.delivery_address_id = da.delivery_address_id;
 
-- 5. Customer Order Details View
CREATE OR REPLACE VIEW Customer_Order_Details AS
SELECT od.order_id, os.order_status_desc, p.payment_type, r.restaurant_name, ot.order_type_name, od.order_date, od.tax, od.gross_amount
FROM Order_details od
JOIN Order_status os ON od.order_status_id = os.order_status_id
JOIN Payment p ON od.payment_id = p.payment_id
JOIN Order_type ot ON od.order_type_id = ot.order_type_id
JOIN BRANCH_ADDRESS ba ON od.BRANCH_ADDRESS_ID = ba.BRANCH_ADDRESS_ID
JOIN RESTAURANT r ON r.RESTAURANT_ID = ba.RESTAURANT_ID;
 
-- 6. Restaurant Coupon Relation View
CREATE OR REPLACE VIEW Restaurant_Coupon_Relation AS
SELECT rp.restaurant_promo_id, pc.promo_id, pc.offer_percentage
FROM Restaurant_Promo rp
JOIN Promo_codes pc ON rp.promo_id = pc.promo_id;

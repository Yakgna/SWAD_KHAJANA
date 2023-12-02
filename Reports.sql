-- Report 1: Interstate Orders
SELECT * FROM Order_details WHERE order_type_id = 'O4';
/
 
-- Report 2: Local Orders
SELECT * FROM Order_details WHERE order_type_id = 'O1';
/
 
-- Report 3: Top 5 Customers
SELECT cd.Customer_ID, cd.first_name, COUNT(*) AS Order_Count 
FROM Order_details od
JOIN delivery_address da ON od.delivery_address_id=da.delivery_address_id
JOIN CUSTOMER_DETAILS cd ON cd.customer_id=da.customer_id
GROUP BY cd.customer_id, cd.first_name
ORDER BY Order_Count DESC 
FETCH FIRST 5 ROWS ONLY;
/
 
-- Report 4: Top 5 Restaurants
SELECT r.Restaurant_ID, COUNT(*) AS Order_Count 
FROM Order_details od
JOIN branch_address ba ON od.branch_address_id=ba.branch_address_id
JOIN restaurant r ON r.restaurant_id=ba.restaurant_id
GROUP BY r.Restaurant_ID 
ORDER BY Order_Count DESC 
FETCH FIRST 5 ROWS ONLY;
/
 
-- Report 5: Top 5 Delivery Boys
SELECT od.executive_id, COUNT(*) AS Delivery_Count 
FROM Order_details od
JOIN delivery_executive de ON od.executive_id=de.executive_id 
GROUP BY od.executive_id 
ORDER BY Delivery_Count DESC 
FETCH FIRST 5 ROWS ONLY;
/
 
-- Report 6: Popular Item sold
SELECT it.Item_name, COUNT(*) AS Order_Count 
FROM Ordered_Items oi
JOIN Items it ON oi.item_id=it.item_id 
GROUP BY it.Item_name 
ORDER BY Order_Count DESC 
FETCH FIRST 1 ROWS ONLY;
/
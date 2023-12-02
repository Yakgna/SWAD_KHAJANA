-- Report 1: Interstate Orders
SELECT * FROM Orders WHERE order_type = 'Interstate';
/
 
-- Report 2: Local Orders
SELECT * FROM Orders WHERE order_type = 'Local';
/
 
-- Report 3: Top 5 Customers
SELECT Customer_ID, COUNT(*) AS Order_Count 
FROM Orders 
GROUP BY Customer_ID 
ORDER BY Order_Count DESC 
FETCH FIRST 5 ROWS ONLY;
/
 
-- Report 4: Top 5 Restaurants
SELECT Restaurant_ID, COUNT(*) AS Order_Count 
FROM Orders 
GROUP BY Restaurant_ID 
ORDER BY Order_Count DESC 
FETCH FIRST 5 ROWS ONLY;
/
 
-- Report 5: Top 5 Delivery Boys
SELECT Delivery_Boy_ID, COUNT(*) AS Delivery_Count 
FROM Orders 
GROUP BY Delivery_Boy_ID 
ORDER BY Delivery_Count DESC 
FETCH FIRST 5 ROWS ONLY;
/
 
-- Report 6: Popular Item in a Restaurant
-- Assuming you need this report for a specific restaurant, replace 'R1' with the desired restaurant ID
SELECT Item_ID, COUNT(*) AS Order_Count 
FROM Order_Items 
WHERE Restaurant_ID = 'R1' 
GROUP BY Item_ID 
ORDER BY Order_Count DESC 
FETCH FIRST 1 ROWS ONLY;
/
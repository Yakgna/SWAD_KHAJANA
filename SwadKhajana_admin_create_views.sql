-- Clear screen and set server output
CLEAR SCREEN;
SET SERVEROUTPUT ON;

-- Drop existing views if they exist
BEGIN
  FOR v IN (
    SELECT VIEW_NAME
    FROM ALL_VIEWS
    WHERE VIEW_NAME IN (
      'TOP_RESTAURANTS',
      'TOP_FOOD_ITEMS',
      'MENU_VIEW',
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP VIEW ' || v.VIEW_NAME;
  END LOOP;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

-- Create views

-- 1. Top Restaurants View
CREATE VIEW Top_Restaurants AS
SELECT r.restaurant_id, r.restaurant_name, COUNT(*) as order_count
FROM Order_details od
JOIN Branch_address ba ON od.branch_address_id = ba.branch_address_id
JOIN Restaurant r ON ba.restaurant_id = r.restaurant_id
GROUP BY r.restaurant_id, r.restaurant_name
ORDER BY order_count DESC
FETCH FIRST 5 ROWS ONLY;

-- 2. Top Food Items View
CREATE VIEW Top_Food_Items AS
SELECT i.item_id, i.item_name, COUNT(*) as order_count
FROM Ordered_items oi
JOIN Items i ON oi.item_id = i.item_id
GROUP BY i.item_id, i.item_name
ORDER BY order_count DESC
FETCH FIRST 5 ROWS ONLY;



-- 3. Menu View
CREATE VIEW Menu_View AS
SELECT i.item_id, i.item_name, i.item_price, r.restaurant_name
FROM Items i
JOIN Restaurant r ON i.restaurant_id = r.restaurant_id;

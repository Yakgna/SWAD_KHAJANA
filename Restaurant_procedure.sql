CREATE OR REPLACE PROCEDURE upsert_restaurant(
    p_restaurant_id   VARCHAR2,
    p_restaurant_name VARCHAR2,
    p_opening_time    DATE,
    p_closing_time    DATE
) AS
BEGIN
    UPDATE restaurant
    SET
        restaurant_name = p_restaurant_name,
        opening_time = p_opening_time,
        closing_time = p_closing_time
    WHERE restaurant_id = p_restaurant_id;

    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO restaurant (restaurant_id, restaurant_name, opening_time, closing_time)
        VALUES (p_restaurant_id, p_restaurant_name, p_opening_time, p_closing_time);
    END IF;
END;
/


BEGIN
    upsert_restaurant('R001', 'Gourmet Bistro', TO_DATE('08:00:00', 'HH24:MI:SS'), TO_DATE('22:00:00', 'HH24:MI:SS'));
END;
/

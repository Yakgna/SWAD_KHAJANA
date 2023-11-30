CREATE OR REPLACE PROCEDURE upsert_order_type(
    p_order_type_id   VARCHAR2,
    p_order_type_name VARCHAR2
) AS
BEGIN
    UPDATE order_type
    SET order_type_name = p_order_type_name
    WHERE order_type_id = p_order_type_id;

    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO order_type (order_type_id, order_type_name)
        VALUES (p_order_type_id, p_order_type_name);
    END IF;
END;
/


BEGIN
    upsert_order_type('O4', 'Takeout');
END;
/
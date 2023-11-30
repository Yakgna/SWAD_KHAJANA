CREATE OR REPLACE PROCEDURE upsert_order_status(
    p_order_status_id   VARCHAR2,
    p_order_status_desc VARCHAR2
) AS
BEGIN
    UPDATE order_status
    SET order_status_desc = p_order_status_desc
    WHERE order_status_id = p_order_status_id;

    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO order_status (order_status_id, order_status_desc)
        VALUES (p_order_status_id, p_order_status_desc);
    END IF;
END;
/

BEGIN
    upsert_order_status('OS7', 'In Progress');
END;
/
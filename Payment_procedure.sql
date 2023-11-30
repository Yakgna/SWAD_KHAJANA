CREATE OR REPLACE PROCEDURE upsert_payment(
    p_payment_id   VARCHAR2,
    p_payment_type VARCHAR2
) AS
BEGIN
    UPDATE payment
    SET payment_type = p_payment_type
    WHERE payment_id = p_payment_id;

    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO payment (payment_id, payment_type)
        VALUES (p_payment_id, p_payment_type);
    END IF;
END;
/

BEGIN
    upsert_payment('P01', 'Mobile Wallet');
END;
/

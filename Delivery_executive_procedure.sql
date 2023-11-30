CREATE OR REPLACE PROCEDURE upsert_delivery_executive(
    p_executive_id VARCHAR2,
    p_first_name   VARCHAR2,
    p_last_name    VARCHAR2,
    p_dob          DATE,
    p_phone_number NUMBER
) AS
BEGIN
    UPDATE delivery_executive
    SET
        first_name = p_first_name,
        last_name = p_last_name,
        dob = p_dob,
        phone_number = p_phone_number
    WHERE executive_id = p_executive_id;

    IF SQL%ROWCOUNT = 0 THEN
        INSERT INTO delivery_executive (executive_id, first_name, last_name, dob, phone_number)
        VALUES (p_executive_id, p_first_name, p_last_name, p_dob, p_phone_number);
    END IF;
END;
/

BEGIN
    upsert_delivery_executive('DE007', 'Sophia', 'Taylor', TO_DATE('1995-09-12', 'YYYY-MM-DD'), 7788990011);
END;
/

CLEAR SCREEN;
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE upsert_delivery_executive(
    p_executive_id SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.executive_id%TYPE,
    p_first_name   SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.first_name%TYPE,
    p_last_name    SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.last_name%TYPE,
    p_dob          SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.dob%TYPE,
    p_phone_number SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE.phone_number%TYPE
) 
AS
BEGIN
    IF p_executive_id IS NULL THEN
        INSERT INTO SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE VALUES 
            ('DE'||SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE_SEQ.NEXTVAL, p_first_name, p_last_name, p_dob, p_phone_number);
        DBMS_OUTPUT.PUT_LINE('New Delivery Executive details added');
    ELSE
        UPDATE SWADKHAJANA_ADMIN.DELIVERY_EXECUTIVE
        SET
            first_name = p_first_name,
            last_name = p_last_name,
            dob = p_dob,
            phone_number = p_phone_number
        WHERE executive_id = p_executive_id;
    DBMS_OUTPUT.PUT_LINE('Details updated for executive '||p_executive_id);
    END IF;
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
       DBMS_OUTPUT.PUT_LINE('Phone number already tagged to a different executive'); 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
        ROLLBACK;
END upsert_delivery_executive;
/
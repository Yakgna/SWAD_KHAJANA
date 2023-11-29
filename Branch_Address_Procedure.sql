CREATE OR REPLACE PROCEDURE INSERT_BRANCH_ADDRESS_PROC (
    p_branch_address_id IN NUMBER,
    p_restaurant_id IN NUMBER,
    p_phone_number VARCHAR2,
    p_address_line1 VARCHAR2,
    p_address_line2 VARCHAR2,
    p_city VARCHAR2,
    p_state VARCHAR2,
    p_pincode VARCHAR2
)
AS
BEGIN
    INSERT INTO BRANCH_ADDRESS (
        BRANCH_ADDRESS_ID,
        RESTAURANT_ID,
        PHONE_NUMBER,
        ADDRESS_LINE_1,
        ADDRESS_LINE_2,
        CITY,
        STATE,
        PINCODE
    ) VALUES (
        p_branch_address_id,
        p_restaurant_id,
        p_phone_number,
        p_address_line1,
        p_address_line2,
        p_city,
        p_state,
        p_pincode
    );

    COMMIT; -- Commit the transaction
    DBMS_OUTPUT.PUT_LINE('Branch Address inserted successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting Branch Address: ' || SQLERRM);
        ROLLBACK; -- Rollback the transaction in case of an error
END;
/



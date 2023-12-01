CLEAR SCREEN;
SET SERVEROUTPUT ON
CREATE OR REPLACE PACKAGE RESTAURANT_PACKAGE AS 
    -- Declaring the procedures
    PROCEDURE UPSERT_ITEM(
        p_item_id IN SWADKHAJANA_ADMIN.ITEMS.ITEM_ID%TYPE,
        p_restaurant_id IN SWADKHAJANA_ADMIN.ITEMS.RESTAURANT_ID%TYPE,
        p_item_name IN SWADKHAJANA_ADMIN.ITEMS.ITEM_NAME%TYPE,
        p_item_price IN SWADKHAJANA_ADMIN.ITEMS.ITEM_PRICE%TYPE
    );

    PROCEDURE UPSERT_PROMO_CODE(
        p_promo_id IN SWADKHAJANA_ADMIN.PROMO_CODES.PROMO_ID%TYPE,
        p_offer_percentage IN SWADKHAJANA_ADMIN.PROMO_CODES.OFFER_PERCENTAGE%TYPE
    );

    PROCEDURE UPSERT_RESTAURANT_PROMO(
        p_restaurant_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE,
        p_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.PROMO_ID%TYPE,
        p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_ID%TYPE
    );

    PROCEDURE UPSERT_BRANCH_ADDRESS(
        p_branch_address_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.BRANCH_ADDRESS_ID%TYPE, 
        p_restaurant_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.RESTAURANT_ID%TYPE, 
        p_phone_number IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PHONE_NUMBER%TYPE, 
        p_address_line1 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_1%TYPE, 
        p_address_line2 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_2%TYPE, 
        p_city IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.CITY%TYPE, 
        p_state IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.STATE%TYPE, 
        p_pincode IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PINCODE%TYPE
    );

    PROCEDURE UPSERT_RESTAURANT(
        p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_ID%TYPE,
        p_restaurant_name IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_NAME%TYPE,
        p_opening_time IN SWADKHAJANA_ADMIN.RESTAURANT.OPENING_TIME%TYPE,
        p_closing_time IN SWADKHAJANA_ADMIN.RESTAURANT.CLOSING_TIME%TYPE
    );

END RESTAURANT_PACKAGE;
/

CREATE OR REPLACE PACKAGE BODY RESTAURANT_PACKAGE AS
    -- Implementation for UPSERT_ITEM
    PROCEDURE UPSERT_ITEM(
            p_item_id IN SWADKHAJANA_ADMIN.ITEMS.ITEM_ID%TYPE, 
            p_restaurant_id IN SWADKHAJANA_ADMIN.ITEMS.RESTAURANT_ID%TYPE, 
            p_item_name IN SWADKHAJANA_ADMIN.ITEMS.ITEM_NAME%TYPE, 
            p_item_price IN SWADKHAJANA_ADMIN.ITEMS.ITEM_PRICE%TYPE) 
    IS
    BEGIN
        IF p_item_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.items (item_id, restaurant_id, item_name, item_price)
            VALUES ('I'||SWADKHAJANA_ADMIN.ITEMS_SEQ.NEXTVAL, p_restaurant_id, p_item_name, p_item_price);
        ELSE 
            UPDATE SWADKHAJANA_ADMIN.items
                SET restaurant_id = p_restaurant_id,
                    item_name = p_item_name,
                    item_price = p_item_price
            WHERE item_id = p_item_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_ITEM;

    -- Implementation for UPSERT_PROMO_CODE
    PROCEDURE UPSERT_PROMO_CODE(
            p_promo_id IN SWADKHAJANA_ADMIN.PROMO_CODES.PROMO_ID%TYPE, 
            p_offer_percentage IN SWADKHAJANA_ADMIN.PROMO_CODES.OFFER_PERCENTAGE%TYPE) 
    IS
    BEGIN
        IF p_promo_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.promo_codes (promo_id, offer_percentage)
            VALUES ('PR'||SWADKHAJANA_ADMIN.PROMO_CODES_SEQ.NEXTVAL, p_offer_percentage);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.promo_codes
            SET offer_percentage = p_offer_percentage
            WHERE promo_id = p_promo_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_PROMO_CODE;

    -- Implementation for UPSERT_RESTAURANT_PROMO
    PROCEDURE UPSERT_RESTAURANT_PROMO(
            p_restaurant_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE, 
            p_promo_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.PROMO_ID%TYPE, 
            p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT_PROMO.RESTAURANT_ID%TYPE) 
    IS
    BEGIN
        IF p_restaurant_promo_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.restaurant_promo (restaurant_promo_id, promo_id, restaurant_id)
            VALUES ('RP'||SWADKHAJANA_ADMIN.RESTAURANT_PROMO_SEQ.NEXTVAL, p_promo_id, p_restaurant_id);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.restaurant_promo
                SET promo_id = p_promo_id,
                restaurant_id = p_restaurant_id
            WHERE restaurant_promo_id = p_restaurant_promo_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_RESTAURANT_PROMO;

    -- Implementation for INSERT_BRANCH_ADDRESS_PROC
    PROCEDURE UPSERT_BRANCH_ADDRESS(
            p_branch_address_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.BRANCH_ADDRESS_ID%TYPE, 
            p_restaurant_id IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.RESTAURANT_ID%TYPE, 
            p_phone_number IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PHONE_NUMBER%TYPE, 
            p_address_line1 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_1%TYPE, 
            p_address_line2 IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.ADDRESS_LINE_2%TYPE, 
            p_city IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.CITY%TYPE, 
            p_state IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.STATE%TYPE, 
            p_pincode IN SWADKHAJANA_ADMIN.BRANCH_ADDRESS.PINCODE%TYPE) 
    IS
    BEGIN
        IF p_branch_address_id IS NULL THEN 
            INSERT INTO SWADKHAJANA_ADMIN.branch_address (branch_address_id, restaurant_id, phone_number, address_line_1, address_line_2, city, state, pincode)
            VALUES ('RBA'||SWADKHAJANA_ADMIN.BRANCH_ADDRESS_SEQ.NEXTVAL, p_restaurant_id, p_phone_number, p_address_line1, p_address_line2, p_city, p_state, p_pincode);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.branch_address SET
                restaurant_id = p_restaurant_id,
                phone_number = p_phone_number,
                address_line_1 = p_address_line1, 
                address_line_2 = p_address_line2, 
                city = p_city, 
                state = p_state, 
                pincode = p_pincode
            WHERE branch_address_id = p_branch_address_id; 
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Address already exists');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_BRANCH_ADDRESS;

    -- Implementation for upsert_restaurant
    PROCEDURE UPSERT_RESTAURANT(
        p_restaurant_id IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_ID%TYPE, 
        p_restaurant_name IN SWADKHAJANA_ADMIN.RESTAURANT.RESTAURANT_NAME%TYPE, 
        p_opening_time IN SWADKHAJANA_ADMIN.RESTAURANT.OPENING_TIME%TYPE, 
        p_closing_time IN SWADKHAJANA_ADMIN.RESTAURANT.CLOSING_TIME%TYPE) 
    IS
    v_seq_count INTEGER;
    v_id INTEGER:=SWADKHAJANA_ADMIN.RESTAURANT_SEQ.NEXTVAL;
    BEGIN
        IF p_restaurant_id IS NULL THEN
            INSERT INTO SWADKHAJANA_ADMIN.restaurant (restaurant_id, restaurant_name, opening_time, closing_time)
            VALUES ('R'||v_id, p_restaurant_name, p_opening_time, p_closing_time);
        ELSE
            UPDATE SWADKHAJANA_ADMIN.restaurant
            SET restaurant_name = p_restaurant_name,
                opening_time = p_opening_time,
                closing_time = p_closing_time
            WHERE restaurant_id = p_restaurant_id;    
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Restaurant name already exists');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occured: '||SQLERRM);
    END UPSERT_RESTAURANT;
END RESTAURANT_PACKAGE;
/

/*
Grant permission to Restaurant_SK user
*/
GRANT EXECUTE ON RESTAURANT_PACKAGE TO RESTAURANT_SK;
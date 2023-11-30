
CREATE OR REPLACE PACKAGE RESTAURANT_PACKAGE AS 

    -- Declaring the procedures
    PROCEDURE UPSERT_ITEM(
        p_item_id IN ITEMS.ITEM_ID%TYPE,
        p_restaurant_id IN ITEMS.RESTAURANT_ID%TYPE,
        p_item_name IN ITEMS.ITEM_NAME%TYPE,
        p_item_price IN ITEMS.ITEM_PRICE%TYPE
    );

    PROCEDURE UPSERT_PROMO_CODE(
        p_promo_id IN PROMO_CODES.PROMO_ID%TYPE,
        p_offer_percentage IN PROMO_CODES.OFFER_PERCENTAGE%TYPE
    );

    PROCEDURE UPSERT_RESTAURANT_PROMO(
        p_restaurant_promo_id IN RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE,
        p_promo_id IN RESTAURANT_PROMO.PROMO_ID%TYPE,
        p_restaurant_id IN RESTAURANT_PROMO.RESTAURANT_ID%TYPE
    );

    PROCEDURE INSERT_BRANCH_ADDRESS_PROC(
        p_branch_address_id IN BRANCH_ADDRESS.BRANCH_ADDRESS_ID%TYPE,
        p_restaurant_id IN BRANCH_ADDRESS.RESTAURANT_ID%TYPE,
        p_phone_number IN BRANCH_ADDRESS.PHONE_NUMBER%TYPE,
        p_address_line1 IN BRANCH_ADDRESS.ADDRESS_LINE_1%TYPE,
        p_address_line2 IN BRANCH_ADDRESS.ADDRESS_LINE_2%TYPE,
        p_city IN BRANCH_ADDRESS.CITY%TYPE,
        p_state IN BRANCH_ADDRESS.STATE%TYPE,
        p_pincode IN BRANCH_ADDRESS.PINCODE%TYPE
    );

    PROCEDURE upsert_restaurant(
        p_restaurant_id IN RESTAURANT.RESTAURANT_ID%TYPE,
        p_restaurant_name IN RESTAURANT.RESTAURANT_NAME%TYPE,
        p_opening_time IN RESTAURANT.OPENING_TIME%TYPE,
        p_closing_time IN RESTAURANT.CLOSING_TIME%TYPE
    );

END RESTAURANT_PACKAGE;
/
CREATE OR REPLACE PACKAGE BODY RESTAURANT_PACKAGE AS

    -- Implementation for UPSERT_ITEM
     PROCEDURE UPSERT_ITEM(p_item_id IN ITEMS.ITEM_ID%TYPE, p_restaurant_id IN ITEMS.RESTAURANT_ID%TYPE, p_item_name IN ITEMS.ITEM_NAME%TYPE, p_item_price IN ITEMS.ITEM_PRICE%TYPE) IS
        v_item_id ITEMS.ITEM_ID%TYPE;
    BEGIN
        UPDATE items
        SET restaurant_id = p_restaurant_id,
            item_name = p_item_name,
            item_price = p_item_price
        WHERE item_id = p_item_id;

        IF SQL%ROWCOUNT = 0 THEN
            SELECT ITEMS_SEQ.NEXTVAL INTO v_item_id FROM DUAL;
            INSERT INTO items (item_id, restaurant_id, item_name, item_price)
            VALUES (v_item_id, p_restaurant_id, p_item_name, p_item_price);
        END IF;
    END UPSERT_ITEM;

    -- Implementation for UPSERT_PROMO_CODE
    PROCEDURE UPSERT_PROMO_CODE(p_promo_id IN PROMO_CODES.PROMO_ID%TYPE, p_offer_percentage IN PROMO_CODES.OFFER_PERCENTAGE%TYPE) IS
        v_promo_id PROMO_CODES.PROMO_ID%TYPE;
    BEGIN
        UPDATE promo_codes
        SET offer_percentage = p_offer_percentage
        WHERE promo_id = p_promo_id;

        IF SQL%ROWCOUNT = 0 THEN
            SELECT PROMO_CODES_SEQ.NEXTVAL INTO v_promo_id FROM DUAL;
            INSERT INTO promo_codes (promo_id, offer_percentage)
            VALUES (v_promo_id, p_offer_percentage);
        END IF;
    END UPSERT_PROMO_CODE;

    -- Implementation for UPSERT_RESTAURANT_PROMO
    PROCEDURE UPSERT_RESTAURANT_PROMO(p_restaurant_promo_id IN RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE, p_promo_id IN RESTAURANT_PROMO.PROMO_ID%TYPE, p_restaurant_id IN RESTAURANT_PROMO.RESTAURANT_ID%TYPE) IS
        v_restaurant_promo_id RESTAURANT_PROMO.RESTAURANT_PROMO_ID%TYPE;
    BEGIN
        UPDATE restaurant_promo
        SET promo_id = p_promo_id,
            restaurant_id = p_restaurant_id
        WHERE restaurant_promo_id = p_restaurant_promo_id;

        IF SQL%ROWCOUNT = 0 THEN
            SELECT RESTAURANT_PROMO_SEQ.NEXTVAL INTO v_restaurant_promo_id FROM DUAL;
            INSERT INTO restaurant_promo (restaurant_promo_id, promo_id, restaurant_id)
            VALUES (v_restaurant_promo_id, p_promo_id, p_restaurant_id);
        END IF;
    END UPSERT_RESTAURANT_PROMO;
    -- Implementation for INSERT_BRANCH_ADDRESS_PROC
    PROCEDURE INSERT_BRANCH_ADDRESS_PROC(p_branch_address_id IN BRANCH_ADDRESS.BRANCH_ADDRESS_ID%TYPE, p_restaurant_id IN BRANCH_ADDRESS.RESTAURANT_ID%TYPE, p_phone_number IN BRANCH_ADDRESS.PHONE_NUMBER%TYPE, p_address_line1 IN BRANCH_ADDRESS.ADDRESS_LINE_1%TYPE, p_address_line2 IN BRANCH_ADDRESS.ADDRESS_LINE_2%TYPE, p_city IN BRANCH_ADDRESS.CITY%TYPE, p_state IN BRANCH_ADDRESS.STATE%TYPE, p_pincode IN BRANCH_ADDRESS.PINCODE%TYPE) IS
    BEGIN
        INSERT INTO branch_address (branch_address_id, restaurant_id, phone_number, address_line_1, address_line_2, city, state, pincode)
        VALUES (p_branch_address_id, p_restaurant_id, p_phone_number, p_address_line1, p_address_line2, p_city, p_state, p_pincode);
    END INSERT_BRANCH_ADDRESS_PROC;

    -- Implementation for upsert_restaurant
    PROCEDURE upsert_restaurant(p_restaurant_id IN RESTAURANT.RESTAURANT_ID%TYPE, p_restaurant_name IN RESTAURANT.RESTAURANT_NAME%TYPE, p_opening_time IN RESTAURANT.OPENING_TIME%TYPE, p_closing_time IN RESTAURANT.CLOSING_TIME%TYPE) IS
    BEGIN
        UPDATE restaurant
        SET restaurant_name = p_restaurant_name,
            opening_time = p_opening_time,
            closing_time = p_closing_time
        WHERE restaurant_id = p_restaurant_id;

        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO restaurant (restaurant_id, restaurant_name, opening_time, closing_time)
            VALUES (p_restaurant_id, p_restaurant_name, p_opening_time, p_closing_time);
        END IF;
    END upsert_restaurant;
    END RESTAURANT_PACKAGE;
/

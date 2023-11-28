CREATE OR REPLACE FUNCTION APPADMIN.FNCALCULATEORDERTOTALAMOUNT (
    f_orderId IN NUMBER,
    f_offer_id NUMBER,
    f_tax NUMBER,
    f_delivery_charge NUMBER
)
RETURN NUMBER
IS
    orderTotalAmount DECIMAL(10,2);
    min_order DECIMAL(10,2);
    max_disc DECIMAL(10,2);
BEGIN
    -- Calculate order total amount
    SELECT COALESCE(SUM(i.COST * oi.QUANTITY), 0) INTO orderTotalAmount
    FROM APPADMIN.ORDERED_ITEMS oi
    JOIN APPADMIN.ITEMS i ON oi.ITEM_ID = i.ITEM_ID
    WHERE oi.ORDER_ID = f_orderId;

    -- Get minimum order amount for the coupon
    SELECT COALESCE(c.minimum_order, 0) INTO min_order
    FROM APPADMIN.COUPONS c
    JOIN APPADMIN.RESTAURANT_COUPON_RELATION rcr ON c.promo_code_id = rcr.promo_code_id
    WHERE rcr.offer_id = f_offer_id;

    -- If orderTotalAmount is greater than minimum order, apply maximum discount
    IF orderTotalAmount > min_order THEN
        -- Get maximum discount for the coupon
        SELECT COALESCE(c.maximum_discount, 0) INTO max_disc
        FROM APPADMIN.COUPONS c
        JOIN APPADMIN.RESTAURANT_COUPON_RELATION rcr ON c.promo_code_id = rcr.promo_code_id
        WHERE rcr.offer_id = f_offer_id;

        -- Ensure max_disc does not exceed orderTotalAmount
        max_disc := LEAST(max_disc, orderTotalAmount);

        orderTotalAmount := GREATEST(orderTotalAmount - max_disc, 0) + f_tax + f_delivery_charge;
    ELSE
        orderTotalAmount := orderTotalAmount + f_tax + f_delivery_charge;
    END IF;

    RETURN orderTotalAmount;
END;
/



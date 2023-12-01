CLEAR SCREEN;
CREATE OR REPLACE FUNCTION SWADKHAJANA_ADMIN.FNCALCULATEORDERTOTALAMOUNT (
    f_orderId IN NUMBER,
    f_offer_id NUMBER,
    f_tax NUMBER,
    f_delivery_charge NUMBER
)
RETURN NUMBER
IS
    orderTotalAmount DECIMAL(10,2);
    max_disc DECIMAL(10,2);
BEGIN
    -- Calculate order total amount
    SELECT COALESCE(SUM(i.ITEM_PRICE * oi.QUANTITY), 0) INTO orderTotalAmount
    FROM SWADKHAJANA_ADMIN.ORDERED_ITEMS oi
    JOIN SWADKHAJANA_ADMIN.ITEMS i ON oi.ITEM_ID = i.ITEM_ID
    WHERE oi.ORDER_ID = f_orderId;
    
    -- Get maximum discount for the coupon
    SELECT COALESCE(c.OFFER_PERCENTAGE, 0) INTO max_disc
    FROM SWADKHAJANA_ADMIN.PROMO_CODES c
    JOIN SWADKHAJANA_ADMIN.RESTAURANT_PROMO rcr ON c.PROMO_ID = rcr.PROMO_ID
    WHERE rcr.RESTAURANT_PROMO_ID = f_offer_id;

    -- Ensure max_disc does not exceed orderTotalAmount
    max_disc := LEAST(max_disc, orderTotalAmount);

    orderTotalAmount := GREATEST(orderTotalAmount - max_disc, 0) + f_tax + f_delivery_charge;

    RETURN orderTotalAmount;
END;
/
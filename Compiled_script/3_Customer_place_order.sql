--To be run in CUSTOMER_SK User

--Place order 1
EXEC SWADKHAJANA_ADMIN.customer_pkg.place_order('O1', 'DA1', 'BA1', 'RBA1',  'RP1', 'P1', SYSDATE, 'DE1', 18);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I1',2);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I2',4);

--Place order 2
EXEC SWADKHAJANA_ADMIN.customer_pkg.place_order('O2', 'DA2', 'BA2', 'RBA3',  NULL, 'P2', SYSDATE, 'DE2', 18);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I21',2);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I22',4);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I23',1);

--Place order 3
EXEC SWADKHAJANA_ADMIN.customer_pkg.place_order('O3', 'DA5', 'BA5', 'RBA6',  'RP3', 'P3', SYSDATE, 'DE3', 18);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I51',2);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I52',4);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I53',1);

--Place order 4
EXEC SWADKHAJANA_ADMIN.customer_pkg.place_order('O4', 'DA6', 'BA6', 'RBA4',  'RP5', 'P4', SYSDATE, 'DE4', 18);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I31',2);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I32',4);
EXEC SWADKHAJANA_ADMIN.customer_pkg.add_ordered_items('I33',1);

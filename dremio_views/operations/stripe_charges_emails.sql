SELECT ARRAY_SLICE(MAP_VALUES(stripe_charges."metadata"."_airbyte_additional_properties"), - 1) [ 0 ] AS customer_email,
       amount / 100.0 AS amount,
       TO_TIMESTAMP(updated) AS payment_date,
       amount / 100.0 AS amount_due,
       status,
       invoice
FROM   operations."stripe_charges"
WHERE  invoice IS NULL AND
       status = 'succeeded' AND
       ARRAY_SLICE(MAP_VALUES(stripe_charges."metadata"."_airbyte_additional_properties"), - 1) [ 0 ] IS NOT NULL
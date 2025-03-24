SELECT
    rl.*,
    cd.*,
    o.AE_contact
FROM "operations.billing-project"."RankedLineItems" AS rl
LEFT JOIN (
    SELECT contact_id, email, stripe_email, customer_id
    FROM "operations.billing-project"."CustomerData"
    WHERE customer_row = 1
) AS cd 
    ON rl.contact_id = cd.contact_id
LEFT JOIN (
    SELECT 
         id AS owner_id, 
         email AS AE_contact
    FROM "hubspot_data".owners
) AS o
    ON rl.properties_hubspot_owner_id = o.owner_id
WHERE rl.row_num = 1
ORDER BY rl.deal_id DESC, rl.line_item_id, rl.contact_id
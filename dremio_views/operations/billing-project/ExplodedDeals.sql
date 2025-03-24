SELECT
    t.id AS deal_id,
    FLATTEN(t.line_items) AS line_item_id,
    FLATTEN(t.contacts) AS contact_id,
    t.properties_dealname AS deal_name,
    t.properties_deal_currency_code,
    t.properties_hubspot_owner_id
FROM "hubspot_data"."deals_deduped" AS t
LEFT JOIN "operations.billing-project"."ExistingInvoiceDeals" AS e
  ON t.id = e.deal_id
WHERE t.properties_hs_is_closed_won = TRUE
  AND t.properties_dealstage = 'closedwon'
  AND t.line_items IS NOT NULL
  AND t.properties_pipeline = 'default'
  AND e.deal_id IS NULL
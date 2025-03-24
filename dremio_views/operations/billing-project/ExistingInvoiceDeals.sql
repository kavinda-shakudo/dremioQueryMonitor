SELECT DISTINCT 
    t."metadata"._airbyte_additional_properties['deal_id'] AS deal_id
FROM operations."stripe_invoices" AS t
WHERE t."metadata"._airbyte_additional_properties IS NOT NULL
  AND t.status IN ('draft','void','paid','open')
ORDER BY deal_id DESC
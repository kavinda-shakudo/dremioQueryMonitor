SELECT *,
       FLATTEN(contacts) as contact_id
FROM   "hubspot_data"."deals_deduped"
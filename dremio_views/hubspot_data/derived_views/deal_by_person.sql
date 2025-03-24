SELECT    deals.id as deal_id, 
          deals.properties_hs_createdate.member0 as createdat,
          deals.properties_dealname,
          ds.label as properties_dealstage,
          deals.properties_amount,
          deals.properties_amount_in_home_currency,
          deals.properties_dealstage,
          owners.firstname
FROM      "hubspot_data"."deals_deduped" deals
LEFT JOIN "hubspot_data"."deal_pipelines_deduped" ds
ON        ds.stageid = deals.properties_dealstage
LEFT JOIN "hubspot_data".owners owners
ON        deals.properties_hs_created_by_user_id = owners.userId
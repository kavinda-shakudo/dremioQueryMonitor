SELECT 
    "properties_amount",
    "properties_dealname",
    "properties_hs_analytics_source_data_2",
    d."properties_createdate".member0 AS create_date,  
    "properties_dealstage",
    d."properties_closedate".member0 AS close_date,
    d."properties_hs_object_id"  
FROM
    "hubspot_data"."deals_deduped" d 
WHERE 
    "properties_dealstage" NOT IN ('closedlost', '209083827', 'closedwon', '37336401')
    AND "properties_pipeline" NOT IN ('93782110')



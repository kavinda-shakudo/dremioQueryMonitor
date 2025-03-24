SELECT 
    id AS deal_id,
    properties_dealname AS dealname,
    properties_dealstage AS dealstage,
    FLATTEN(contacts) AS contact,
    FLATTEN(companies) AS company
FROM hubspot_data.deals_deduped
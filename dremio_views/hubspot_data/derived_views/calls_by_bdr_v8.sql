SELECT DISTINCT 
    ec.properties_hubspot_owner_id,
    ec.properties_hs_connected_count,
    ec.createdat.member0 as createdat,
    ec.properties_hs_call_status,
    ec.properties_hs_call_title,
    ec.contacts,
    ec.properties_hs_call_duration,
    o.firstname,
    ec.properties_hs_call_disposition,
    ec.properties_hs_object_id AS engagement_id,
    ec.contacts[0] AS contact_id,  -- Adjusted for 0-based indexing
    c.properties_jobtitle AS jobtitle,
    c.properties_role_seniority AS role_seniority,
    CAST(ec.properties_hubspot_owner_id AS VARCHAR) as owner_id  -- Type casting to VARCHAR
FROM 
    "hubspot_data"."engagements_calls_deduped" ec
    LEFT JOIN "hubspot_data".owners o ON CAST(ec.properties_hubspot_owner_id AS VARCHAR) = CAST(o.id AS VARCHAR)
    LEFT JOIN "hubspot_data"."contacts_deduped" c ON c.id = ec.contacts[0]  -- Adjusted for 0-based indexing
WHERE 
    ec.properties_hubspot_owner_id IS NOT NULL;

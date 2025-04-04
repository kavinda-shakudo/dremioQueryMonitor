WITH stage_id_classification AS (
    SELECT DISTINCT stageid,
        CASE 
            WHEN label IN ('Closed lost', 'Closed won', 'Churned') THEN FALSE
            ELSE TRUE
        END AS active_deal
    FROM "hubspot_data"."deal_pipelines_deduped"
)
SELECT DISTINCT
    ec.properties_hubspot_owner_id,
    ec.properties_hs_connected_count,
    ec.createdat.member0 as createdat,
    ec.properties_hs_call_status,
    ec.properties_hs_call_title,
    ec.contacts[0] AS contact_id,  -- Dremio arrays are 0-indexed
    ec.properties_hs_call_duration,
    o.firstname,
    o.email,
    ec.properties_hs_call_disposition,
    ec.properties_hs_object_id AS engagement_id,
    c.properties_jobtitle AS jobtitle,
    c.properties_role_seniority AS role_seniority,
    ec.companies[0] AS company_id,  -- Accessing the first company in the array
    d.properties_dealname,
    sic.stageid
FROM 
    "hubspot_data"."engagements_calls_deduped" ec
    LEFT JOIN "hubspot_data".owners o ON CAST(ec.properties_hubspot_owner_id AS VARCHAR) = CAST(o.id AS VARCHAR)
    LEFT JOIN "hubspot_data"."contacts_deduped" c ON c.id = ec.contacts[0]  -- Join on the first contact, assuming array is not empty
    LEFT JOIN "hubspot_data"."deals_deduped" d ON d.companies[0] = ec.companies[0]  -- Join on the first company
    LEFT JOIN stage_id_classification sic ON d.properties_dealstage = sic.stageid
WHERE 
    (d.properties_dealname IS NULL OR sic.active_deal IS FALSE) 
    AND ec.properties_hubspot_owner_id IS NOT NULL
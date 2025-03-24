SELECT 
    id,                                   -- Unique identifier for each contact
    contacts.createdAt.member0 AS createdAt,       -- Creation date of the contact
    contacts.updatedAt.member0 AS updatedAt,       -- Last updated date of the contact
    properties_lastname,                  -- Last name of the contact
    properties_firstname,                 -- First name of the contact
    properties_city,                      -- City of the contact
    properties_state,                     -- State of the contact
    properties_hs_analytics_source,       -- Analytics source of the contact
    properties_hs_analytics_source_data_1,-- Analytics source data 1
    properties_hs_analytics_source_data_2 -- Analytics source data 2
FROM 
    "hubspot_data"."derived_views".contacts as contacts
WHERE 
    -- Exclude contacts with the 'hs_analytics_source' property set to 'OFFLINE'
    properties_hs_analytics_source != 'OFFLINE'
    -- Exclude contacts with specific 'hs_analytics_source_data_2' property values
    AND properties_hs_analytics_source_data_2 != 'us-content-lgf-llama3-vbphones-consult'
    AND properties_hs_analytics_source_data_2 != 'Shakudo-internal-auto-contact-creation'
    AND properties_hs_analytics_source_data_2 != '2674917'
    -- Filter contacts with a creation date within the last 3 months
    AND CAST(contacts.createdAt.member0 AS TIMESTAMP) > CURRENT_DATE - INTERVAL '3' MONTH;

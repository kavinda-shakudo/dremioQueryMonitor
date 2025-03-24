SELECT 
    id AS contact_id,
    c.createdAt.member0 AS createdAt,
    properties_firstname AS firstname,
    properties_lastname AS lastname,
    properties_jobtitle AS jobtitle,
    CAST(CAST(properties_associatedcompanyid AS BIGINT) AS VARCHAR) AS company_id,
    properties_hubspot_owner_id AS owner_id,
    properties_email
FROM hubspot_data.contacts_deduped c
WHERE NOT ENDS_WITH(properties_email, 'shakudo.io')
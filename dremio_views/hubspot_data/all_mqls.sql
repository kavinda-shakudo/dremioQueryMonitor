SELECT c.id, -- Unique identifier for each contact
       c.createdAt.member0 as createdAt, -- Creation date of the contact
       c.updatedAt.member0 as updatedAt, -- Last updated date of the contact
       c.properties_lastname, -- Last name of the contact
       c.properties_firstname, -- First name of the contact
       c.properties_city, -- City of the contact
       c.properties_state, -- State of the contact
       c.properties_hs_analytics_source,
       c.properties_hs_analytics_source_data_1,
       c.properties_hs_analytics_source_data_2,
       c.properties_hs_object_source_detail_1,
       c.properties_lead_source,
       c.properties_lead_source_detail,
       c."properties_jobtitle",
       c."properties_role_seniority",
       c.properties_linkedin_profile_link
FROM   "hubspot_data"."contacts_deduped" c
WHERE  (c.properties_hs_analytics_source_data_2 IS NULL OR
        c.properties_hs_analytics_source_data_2 <> 'us-content-lgf-llama3-vbphones-consult') AND
       c.createdAt.member0 > '2024-09-01' AND
       (c.properties_hs_analytics_source <> 'OFFLINE' OR
        c.properties_hs_analytics_source_data_2 IN (
          'Shakudo-internal-auto-contact-creation',
          '2674917') OR
        c.properties_lead_source = 'Shakudo-internal-auto-contact-creation')
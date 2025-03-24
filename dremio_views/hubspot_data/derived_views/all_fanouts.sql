SELECT DISTINCT c.id,
                c.createdAt.member0 as createdAt,
                c.updatedAt.member0 as updatedAt,
                c.properties_lastname AS lastname,
                c.properties_firstname AS firstname,
                c.properties_email AS email,
                c.properties_mobilephone AS mobilephone,
                c.properties_phone AS phone,
                c.properties_city AS city,
                c.properties_state AS state,
                c.properties_hs_analytics_source AS hs_analytics_source,
                c.properties_hs_analytics_source_data_1 AS hs_analytics_source_data_1,
                c.properties_hs_analytics_source_data_2 AS hs_analytics_source_data_2,
                c.properties_hs_object_source_detail_1 AS hs_object_source_detail_1,
                c.properties_lead_source AS lead_source,
                c.properties_lead_source_detail AS lead_source_detail,
                c."properties_jobtitle" AS jobtitle,
                c."properties_role_seniority" AS role_seniority,
                c.properties_linkedin_profile_link AS linkedin_profile_link,
                co.id as company_id,
                co.properties_name as company_name,
                co.properties_numberofemployees,
                d.id as deal_id
FROM            "hubspot_data"."contacts_deduped" c
LEFT JOIN       hubspot_data.companies_deduped co
ON              c.properties_associatedcompanyid = co.id
LEFT JOIN       (SELECT *,
                        FLATTEN(d.companies) as company_id
                 FROM   hubspot_data.deals_deduped d
                ) d
ON              d.company_id = co.id
WHERE           c.properties_lead_source_detail IS NOT NULL AND
                c.properties_lead_source_detail = 'Shakudo-internal-auto-contact-creation'
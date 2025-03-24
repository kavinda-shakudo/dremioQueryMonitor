SELECT DISTINCT amql.*,
                co.properties_name as company_name,
                co.properties_numberofemployees as num_employees,
                d.properties_dealname as deal_name,
                d.id as deal_id
FROM            "hubspot_data"."derived_views"."all_mqls_all_dates" amql
LEFT JOIN       (SELECT *,
                        FLATTEN(contacts) as contact_id
                 FROM   companies_deduped
                ) co
ON              co.contact_id = amql.id
LEFT JOIN       (SELECT *,
                        FLATTEN(contacts) as contact_id,
                        FLATTEN(companies) as company_id
                 FROM   deals_deduped
                ) d
ON              d.contact_id = amql.id OR
                d.company_id = co.id
WHERE           amql.properties_state IN (
                  'California',
                  'CA') AND
                co.properties_numberofemployees > 100 AND
                d.id IS NULL AND
                (properties_role_seniority LIKE 'L1%' OR
                 properties_role_seniority LIKE 'L2%')
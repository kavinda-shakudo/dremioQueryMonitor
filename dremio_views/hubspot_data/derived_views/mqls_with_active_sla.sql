SELECT *
FROM   (SELECT    c.id as contact_id,
                  c.properties_firstname as firstname,
                  c.properties_lastname as lastname,
                  c.properties_company as company,
                  c.properties_jobtitle as jobtitle,
                  c.properties_phone as phone,
                  o.email as owner,
                  c.properties_role_seniority as role_seniority,
                  c.createdAt.member0 as contact_createdAt,
                  c."properties_linkedin_profile_link",
                  c.properties_hs_analytics_source,
                  c.properties_hs_analytics_source_data_1,
                  c.properties_hs_analytics_source_data_2,
                  COUNT(t.id) as num_tasks
        FROM      hubspot_data.contacts_deduped c
        LEFT JOIN hubspot_data.derived_views.recent_tasks t
        ON        c.id = t.contact_id AND
                  t.properties_hs_object_source = 'INTEGRATION' AND
                  c.properties_company IS NOT NULL
        LEFT JOIN hubspot_data.owners o
        ON        t.properties_hubspot_owner_id = o.id
        WHERE     (c.properties_hs_analytics_source_data_2 IS NULL OR
                   c.properties_hs_analytics_source_data_2 <> 'us-content-lgf-llama3-vbphones-consult') AND
                  c.createdAt.member0 > '2024-09-01' AND
                  t.createdAt <= CURRENT_DATE() AND
                  (t.due_date >= CURRENT_DATE() OR
                   t."properties_hs_task_is_past_due_date") AND
                  t.properties_hs_task_status <> 'COMPLETED' AND
                  (c.properties_hs_analytics_source <> 'OFFLINE' OR
                   c.properties_hs_analytics_source_data_2 IN (
                     'Shakudo-internal-auto-contact-creation',
                     '2674917') OR
                   c.properties_lead_source = 'Shakudo-internal-auto-contact-creation')
        GROUP BY  c.id,
                  c."properties_linkedin_profile_link",
                  firstname,
                  lastname,
                  company,
                  phone, 
                  jobtitle,
                  o.email,
                  role_seniority,
                  contact_createdAt,
                  c.properties_hs_analytics_source,
                  c.properties_hs_analytics_source_data_1,
                  c.properties_hs_analytics_source_data_2
        ORDER BY  contact_createdAt DESC)
WHERE  num_tasks > 0;
SELECT *
FROM   (SELECT    c.id as contact_id,
                  c.createdAt.member0 as createdAt,
                  c."properties_linkedin_profile_link",
                  c.properties_hs_analytics_source,
                  c.properties_hs_analytics_source_data_1,
                  c.properties_hs_analytics_source_data_2,
                  COUNT(t.id) as num_tasks
        FROM      hubspot_data.contacts_deduped c
        LEFT JOIN hubspot_data.derived_views.recent_tasks t
        ON        c.id = t.contact_id AND
                  t.properties_hs_object_source = 'INTEGRATION'
        WHERE     (c.properties_hs_analytics_source_data_2 IS NULL OR
                   c.properties_hs_analytics_source_data_2 <> 'us-content-lgf-llama3-vbphones-consult') AND
                  c.createdAt.member0 > '2024-09-01' AND
                  (c.properties_hs_analytics_source <> 'OFFLINE' OR
                   c.properties_hs_analytics_source_data_2 IN (
                     'Shakudo-internal-auto-contact-creation',
                     '2674917') OR
                   c.properties_lead_source_detail = 'Shakudo-internal-auto-contact-creation') 
        GROUP BY  c.id,
                  c."properties_linkedin_profile_link",
                  createdAt,
                  c.properties_hs_analytics_source,
                  c.properties_hs_analytics_source_data_1,
                  c.properties_hs_analytics_source_data_2
        ORDER BY  createdAt DESC)
WHERE  num_tasks = 0;
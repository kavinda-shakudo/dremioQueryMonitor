SELECT DISTINCT emf.id,
                emf.properties_hs_meeting_title as meeting_title,
                emf.properties_hs_meeting_start_time.member0 as meeting_start_time,
                emf.properties_hs_meeting_external_url as meeting_link,
                emf.properties_hs_meeting_external_url as meeting_calendar_url,
                df.properties_dealname as dealname,
                c.properties_name as company_name,
                o.firstName as owner_firstname,
                dp.label as dealstage,
                dp.pipeline_name as pipeline,
                LISTAGG(DISTINCT df.contact_id, ',') AS attending_contact_ids
FROM            (SELECT FLATTEN(d.contacts) as contact_id,
                        FLATTEN(d.companies) as company_id,
                        *
                 FROM   deals_deduped d
                ) df
INNER JOIN      (SELECT FLATTEN(em.contacts) as contact_id,
                        *
                 FROM   engagements_meetings_deduped em
                 WHERE  em."properties_hs_meeting_start_time".member0 > CURRENT_DATE()
                ) emf
ON              df.contact_id = emf.contact_id
LEFT JOIN       deal_pipelines_deduped dp
ON              df.properties_dealstage = dp.stageId
LEFT JOIN       companies_deduped c
ON              df.company_id = c.id
LEFT JOIN       hubspot_data.owners o
ON              o.id = df.properties_hubspot_owner_id
WHERE           dp.label NOT IN (
                  'Closed lost',
                  'Parking lot',
                  'Churned') AND
                emf.properties_hs_meeting_external_url IS NOT NULL
GROUP BY        emf.id,
                emf.properties_hs_meeting_title,
                emf.properties_hs_meeting_start_time.member0,
                emf.properties_hs_meeting_external_url,
                df.properties_dealname,
                c.properties_name,
                dp.label,
                dp.pipeline_name,
                o.firstName
ORDER BY        emf.properties_hs_meeting_start_time.member0 ASC
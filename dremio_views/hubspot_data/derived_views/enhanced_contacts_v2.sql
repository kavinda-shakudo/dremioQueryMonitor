SELECT DISTINCT c.id as contact_id,
                c.createdAt.member0 as createdAt,
                emx.hubspot_meeting_id as meeting_id,
                emx.meeting_calendar_url as meeting_calendar_url,
                c."properties_firstname" as firstname,
                c.properties_lastname as lastname,
                c.properties_jobtitle as jobtitle,
                c.properties_role_seniority as role_seniority,
                CAST(CAST(c."properties_associatedcompanyid" AS BIGINT) AS VARCHAR) as company_id,
                co.properties_name as company_name,
                c.properties_hubspot_owner_id as owner_id,
                o.firstName as owner_firstname,
                o.lastName as owner_lastname,
                emx.meeting_start_time as meeting_start_time,
                emx.meeting_end_time as meeting_end_time,
                emx.title as meeting_title,
                emx.meeting_created_date as meeting_created_date,
                c.properties_hs_analytics_source as hs_analytics_source,
                c.properties_hs_analytics_source_data_1 as hs_analytics_source_data_1,
                c.properties_hs_analytics_source_data_2 as hs_analytics_source_data_2,
                c.properties_lead_source as lead_source,
                c.properties_lead_source_detail as lead_source_detail,
                c.properties_city as city,
                c.properties_state as state,
                dx.id as deal_id,
                dx.properties_dealname as dealname,
                dp.label
FROM            contacts_deduped c
LEFT JOIN       companies_deduped co
ON              CAST(CAST(c.properties_associatedcompanyid as BIGINT) AS VARCHAR) = co.id
LEFT JOIN       owners o
ON              o.id = c.properties_hubspot_owner_id
LEFT JOIN       (SELECT FLATTEN(em.contact_ids) as contact,
                        *
                 FROM   "hubspot_data"."derived_views"."fireflies_hubspot_merged" em
                 WHERE  em.total_non_shakudo_talk_time > 0
                ) emx
ON              emx.contact = c.id
LEFT JOIN       (SELECT FLATTEN(d.contacts) as contact,
                        FLATTEN(d.companies) as company,
                        d.*
                 FROM   deals_deduped d
                ) dx
ON              dx.contact = c.id OR
                dx.company = c.properties_associatedcompanyid
LEFT JOIN       deal_pipelines_deduped dp
on              dp.stageId = dx.properties_dealstage
WHERE           NOT ENDS_WITH(c.properties_email, 'shakudo.io') OR
                c.properties_email IS NULL
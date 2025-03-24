SELECT contact_id,
       DATE_TRUNC('DAY', contact_createdat) AS contact_createdat_day,
       deal_id,
       DATE_TRUNC('DAY', deal_createdat) AS deal_createdat_day,
       ABS(CAST(CAST(DATE_DIFF(contact_createdat, deal_createdat) AS INTERVAL DAY) AS INT)) as days_to_convert_contact_to_deal,
       deal_name,
       deal_stage,
       hs_analytics_source,
       hs_analytics_source_data_1,
       hs_analytics_source_data_2
FROM   (SELECT *
        FROM   (SELECT     c.id as contact_id,
                           c.createdAt as contact_createdat,
                           df.id as deal_id,
                           df.deal_createdat,
                           deal_name,
                           dp.label as deal_stage,
                           c.properties_hs_analytics_source as hs_analytics_source,
                           c.properties_hs_analytics_source_data_1 as hs_analytics_source_data_1,
                           c.properties_hs_analytics_source_data_2 as hs_analytics_source_data_2,
                           RANK() OVER(PARTITION BY df.id ORDER BY c.createdAt ASC) as contact_rank
                FROM       (SELECT id,
                                   properties_dealstage as stage_id,
                                   properties_dealname as deal_name,
                                   d.createdAt.member0 as deal_createdat,
                                   FLATTEN(d.contacts) as contact_id
                            FROM   deals_deduped d
                           ) df
                INNER JOIN "hubspot_data"."derived_views"."all_mqls_all_dates" c
                ON         df.contact_id = c.id
                LEFT JOIN  deal_pipelines_deduped dp
                ON         df.stage_id = dp.stageId
               ) ranked_deal_contacts
        WHERE  contact_rank = 1
       ) nested_0;
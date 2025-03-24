SELECT   company_id,
         meeting_id,
         meeting_calendar_url,
         meeting_title,
         meeting_start_time,
         meeting_created_date,
         owner_firstname,
         LISTAGG("hs_analytics_source", ',') as analytics_sources,
         LISTAGG("hs_analytics_source_data_1", ',') as analytics_sources_data_1,
         hs_analytics_source_data_2 as analytics_sources_data_2,
         LISTAGG(lead_source, ',') as lead_source_agg,
         LISTAGG(lead_source_detail, ',') as lead_source_detail_agg,
         contact_id
FROM     (SELECT *
          FROM   "hubspot_data".derived_views.enhanced_contacts
          WHERE  hs_analytics_source_data_2 IS NOT NULL AND
                 meeting_start_time IS NOT NULL AND
                 meeting_calendar_url IS NOT NULL
         ) nested_0
GROUP BY company_id,
         meeting_id,
         meeting_calendar_url,
         meeting_title,
         meeting_start_time,
         meeting_created_date,
         owner_firstname,
         hs_analytics_source_data_2,
         contact_id
ORDER BY meeting_start_time DESC
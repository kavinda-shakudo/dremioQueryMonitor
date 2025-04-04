SELECT   company_id,
         meeting_id,
         meeting_calendar_url,
         meeting_title,
         meeting_start_time,
         owner_firstname,
         ARRAY_AGG("hs_analytics_source") as analytics_sources,
         ARRAY_AGG("hs_analytics_source_data_1") as analytics_sources_data_1,
         ARRAY_AGG("hs_analytics_source_data_2") as analytics_sources_data_2,
         ARRAY_AGG(lead_source) as lead_source_agg,
         ARRAY_AGG(lead_source_detail) as lead_source_detail_agg,
         ARRAY_AGG(DISTINCT "contact_id") AS non_shakudo_attendees
FROM     (SELECT *
          FROM   derived_views.enhanced_contacts
          WHERE  meeting_start_time > CURRENT_DATE() AND
                 dealname is NULL
         ) nested_0
GROUP BY company_id,
         meeting_id,
         meeting_calendar_url,
         meeting_title,
         meeting_start_time,
         owner_firstname
ORDER BY meeting_start_time ASC
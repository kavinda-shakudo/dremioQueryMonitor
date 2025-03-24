SELECT   firefly_meeting_id,
         organizer_email,
         total_shakudo_talk_time,
         total_non_shakudo_talk_time,
         title,
         LISTAGG(DISTINCT contact_id, ',') AS contact_ids,
         LISTAGG(DISTINCT contact_created_date, ',') as contact_create_dates,
         MIN(meeting_created_date) AS meeting_created_date,
         MIN(meeting_start_time) AS meeting_start_time,
         MIN(meeting_end_time) AS meeting_end_time,
         MIN(hubspot_meeting_id) AS hubspot_meeting_id,
         MIN(meeting_calendar_url) AS meeting_calendar_url,
         LISTAGG(owner_id, ',') AS owner_ids,
         MIN(owner_firstname) AS owner_firstnames,
         LISTAGG(DISTINCT hs_analytics_source, ',') AS hs_analytics_sources,
         LISTAGG(DISTINCT hs_analytics_source_data_1, ',') AS hs_analytics_source_datas_1,
         LISTAGG(DISTINCT hs_analytics_source_data_2, ',') AS hs_analytics_source_datas_2,
         MIN(deal_id) AS deal_ids,
         MIN(dealname) AS dealnames,
         MIN(label) AS labels
FROM     hubspot_data.temp_views.joined_meeting_data
GROUP BY firefly_meeting_id,
         total_shakudo_talk_time,
         total_non_shakudo_talk_time,
         title,
         organizer_email
ORDER BY meeting_start_time DESC
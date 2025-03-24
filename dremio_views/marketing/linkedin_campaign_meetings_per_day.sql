SELECT   DATE_TRUNC('DAY', contact_create_date) as contact_create_date_day,
         MIN(DATE_TRUNC('DAY', first_meeting_created_date)) as first_meeting_date_day,
         MEDIAN(ALL CAST(CAST(DATE_DIFF(first_meeting_created_date, contact_create_date) AS INTERVAL DAY) AS INT)) as median_time_to_convert,
         COUNT(DISTINCT contact_id) as num_meetings,
         hs_analytics_source_data_2
FROM     "hubspot_data"."derived_views"."mql_meetings_deals"
GROUP BY contact_create_date_day,
         hs_analytics_source_data_2
ORDER BY contact_create_date_day DESC,
         COUNT(DISTINCT contact_id) DESC
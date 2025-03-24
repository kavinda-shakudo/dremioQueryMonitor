SELECT   organizer_email,
         COUNT(*) as num_meetings,
         MEDIAN(ALL total_non_shakudo_talk_time) as median_non_shakudo_talk_time,
         MEDIAN(ALL total_shakudo_talk_time) as median_shakudo_talk_time,
         MIN(meeting_start_time) AS earliest_meeting_start_time,
         ABS(CAST(CAST(DATE_DIFF(earliest_meeting_start_time, CURRENT_DATE()) AS INTERVAL DAY) AS INT)) AS active_days_last_year,
         ARRAY_AGG(ALL title) as all_meetings
FROM     (SELECT   organizer_email,
                   title,
                   MIN("meeting_start_time") as meeting_start_time,
                   SUM(ALL total_non_shakudo_talk_time) as total_non_shakudo_talk_time,
                   SUM(ALL total_shakudo_talk_time) as total_shakudo_talk_time
          FROM     "hubspot_data"."derived_views"."bdrs_fireflies"
          WHERE    title NOT IN (
                     'Sales Training',
                     'Sales training [ Sat ]') AND
                   total_non_shakudo_talk_time > 0 AND
                   meeting_created_date > DATE_SUB(CURRENT_DATE(), 365)
          GROUP BY organizer_email,
                   title
         ) combined_ctl
GROUP BY organizer_email;
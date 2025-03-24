SELECT   organizer_email,
         COUNT(*) as num_meetings,
         AVG(ALL total_non_shakudo_talk_time) as median_non_shakudo_talk_time,
         AVG(ALL total_shakudo_talk_time) as median_shakudo_talk_time,
         LISTAGG(ALL title, ',') as meeting_titles
FROM     (SELECT   organizer_email,
                   title,
                   SUM(ALL total_non_shakudo_talk_time) as total_non_shakudo_talk_time,
                   SUM(ALL total_shakudo_talk_time) as total_shakudo_talk_time
          FROM     "hubspot_data"."derived_views"."bdrs_fireflies"
          WHERE    meeting_start_time > DATE_SUB(CURRENT_DATE(), 14) AND
                   title NOT IN (
                     'Sales Training',
                     'Sales training [ Sat ]') AND
                   total_non_shakudo_talk_time > 0
          GROUP BY organizer_email,
                   title
         ) combined_ctl
GROUP BY organizer_email
WITH     filtered_meetings AS (
           SELECT "hs_analytics_source_data_2",
                  "num_meetings"
           FROM   "marketing"."linkedin_campaign_meetings_per_day"
           WHERE  "hs_analytics_source_data_2" IS NOT NULL),
         filtered_contacts AS (
           SELECT "properties_hs_analytics_source_data_2",
                  "properties_role_seniority"
           FROM   "hubspot_data"."contacts_deduped"
           WHERE  "properties_hs_latest_source_data_1" LIKE '%Linkedin%')
SELECT   m."hs_analytics_source_data_2",
         c."properties_role_seniority",
         SUM(m."num_meetings") AS total_meetings
FROM     filtered_meetings m
JOIN     filtered_contacts c
ON       m."hs_analytics_source_data_2" = c."properties_hs_analytics_source_data_2"
GROUP BY m."hs_analytics_source_data_2",
         c."properties_role_seniority"
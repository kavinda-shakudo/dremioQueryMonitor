WITH FlattenedTable2 AS (
    SELECT 
        FLATTEN(contact_ids) AS contact_id, 
        title AS meeting_title
    FROM "hubspot_data"."Superset_reports"."Bizops tables"."Occurred Meetings Staging" 
)
SELECT 
    LKN.campaignname AS campaign_name,
    COUNT(b.meeting_title) AS meeting_title_count,
    COUNT(MQL.hs_record_id) AS record_id_count, 
    SUM(DISTINCT(LKN.daily_cost_in_usd)) AS total_daily_cost 
FROM 
    "hubspot_data"."Superset_reports"."Bizops tables"."Linkedin daily spend" AS LKN
FULL OUTER JOIN 
    "hubspot_data"."Superset_reports"."MQLS PER DAY" AS MQL
ON 
    MQL.hs_latest_source = LKN.start_ts_day AND 
    MQL."properties_hs_latest_source_data_2" = LKN.campaignname
LEFT JOIN FlattenedTable2 AS b
ON 
    MQL.hs_record_id = b.contact_id
WHERE 
    LKN.start_ts_day >= DATE_SUB(CURRENT_DATE, 60) 
GROUP BY 
    LKN.campaignname
ORDER BY 
    total_daily_cost DESC


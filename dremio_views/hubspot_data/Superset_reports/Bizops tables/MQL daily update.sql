
SELECT 
    LKN.start_ts_day,
    MQL.EXPR$0,
    LKN.daily_cost_in_usd,
    LKN.Channel,
    LKN.campaignname AS campaign_name,
    MQL.hs_record_id AS record_id, 
    MQL."properties_company" AS company
FROM 
    "hubspot_data"."Superset_reports"."Bizops tables"."Linkedin daily spend" AS LKN
FULL OUTER JOIN 
    "hubspot_data"."Superset_reports"."MQLS PER DAY" AS MQL
ON 
    MQL.hs_latest_source = LKN.start_ts_day AND 
    MQL."properties_hs_latest_source_data_2" = LKN.campaignname
WHERE 
    LKN.start_ts_day IS NOT NULL



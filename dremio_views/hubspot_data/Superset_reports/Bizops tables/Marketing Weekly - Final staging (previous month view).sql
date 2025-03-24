SELECT 
    campaign_name,
    CAST(meeting_title_count AS FLOAT) AS meeting_title_count,
    CAST(record_id_count AS FLOAT) AS record_id_count,
    CAST(total_daily_cost*1.4 AS FLOAT) AS total_daily_cost,
    COUNT(d."properties_dealname") AS deal_count, 
    CAST(SUM(d."properties_amount") AS FLOAT) AS deal_total_amount
FROM 
    "hubspot_data"."Superset_reports"."Bizops tables"."Daily marketing MoM - Triplejoin Previous month staging" AS staging
LEFT JOIN "hubspot_data"."Superset_reports"."Bizops tables"."deals - staging (previous month)" AS d
ON 
    d."properties_hs_analytics_source_data_2" = staging.campaign_name
GROUP BY 
    staging.campaign_name,
    meeting_title_count,
    record_id_count,
    total_daily_cost
ORDER BY meeting_title_count

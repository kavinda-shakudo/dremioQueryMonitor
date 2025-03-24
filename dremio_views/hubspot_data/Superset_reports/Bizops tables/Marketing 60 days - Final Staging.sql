SELECT 
    campaign_name,
    CAST(meeting_title_count AS FLOAT) AS meeting_title_count,
    CAST(record_id_count AS FLOAT) AS record_id_count,
    CAST(total_daily_cost*1.4 AS INT) AS total_daily_cost,
    COUNT(d."properties_amount") AS deal_count, 
    CAST(SUM(d."properties_amount") AS FLOAT) AS deal_total_amount, 
    ARRAY_AGG(
        CASE 
            WHEN d."properties_dealname" IS NOT NULL THEN 
                CONCAT('["', d."properties_dealname", '"](https://app.hubspot.com/contacts/21367798/record/0-3/', CAST(d."properties_hs_object_id" AS BIGINT), ')')
            ELSE NULL 
        END
    ) FILTER (WHERE d."properties_dealname" IS NOT NULL) AS dealname_links -- Filter out NULL deal names
FROM 
    "hubspot_data"."Superset_reports"."Bizops tables"."Daily marketing MoM - Triplejoin staging" AS staging
LEFT JOIN "hubspot_data"."Superset_reports"."Bizops tables"."deals - staging" AS d
    ON d."properties_hs_analytics_source_data_2" = staging.campaign_name

GROUP BY 
    staging.campaign_name,
    meeting_title_count,
    record_id_count,
    total_daily_cost;
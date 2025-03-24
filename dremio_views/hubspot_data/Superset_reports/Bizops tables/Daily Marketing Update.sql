WITH daily_cpl AS (
    SELECT 
        Channel,
        CAST(ROUND(SUM(DISTINCT daily_cost_in_usd), 2) AS DECIMAL(10, 2))*1.4 AS Todays_Spend,
        ROUND(SUM(DISTINCT daily_cost_in_usd) / NULLIF(COUNT(DISTINCT company), 0), 2)*1.4 AS Cost_Per_Lead,  -- Count distinct companies
        campaign_name,
        ARRAY_AGG('[' || company || '](https://app.hubspot.com/contacts/21367798/record/0-1/' || CAST(record_id AS VARCHAR) || ')') AS Company_Links
    FROM "hubspot_data"."Superset_reports"."Bizops tables"."MQL daily update"
    WHERE CAST(start_ts_day AS DATE) = DATE_SUB(CURRENT_DATE, 1)
    GROUP BY Channel, campaign_name
),
previous_data AS (
    SELECT 
        Channel,
        campaign_name,
        ROUND(SUM(DISTINCT daily_cost_in_usd) / NULLIF(COUNT(DISTINCT company), 0), 2)*1.4 AS Cost_Per_Lead  -- Count distinct companies
    FROM "hubspot_data"."Superset_reports"."Bizops tables"."MQL daily update"
    WHERE CAST(start_ts_day AS DATE) = DATE_SUB(CURRENT_DATE, 8) -- Date a week ago
    GROUP BY Channel, campaign_name
)
SELECT 
    current_data.Channel,
    current_data.Todays_Spend,
    COALESCE(current_data.Cost_Per_Lead, 0) AS Cost_Per_Lead,  -- Replace NULL with 0
    current_data.campaign_name,
    current_data.Company_Links,
    COALESCE(previous_data.Cost_Per_Lead, 0) AS CPL_Last_Week,  -- Replace NULL with 0
    CASE 
        WHEN COALESCE(previous_data.Cost_Per_Lead, 0) != 0 
        THEN ROUND(((current_data.Cost_Per_Lead - previous_data.Cost_Per_Lead) / previous_data.Cost_Per_Lead) * 100, 2) 
        ELSE NULL 
    END AS VS_Last_Week_CPL
FROM 
    daily_cpl AS current_data
LEFT JOIN previous_data
    ON current_data.Channel = previous_data.Channel 
    AND current_data.campaign_name = previous_data.campaign_name
ORDER BY 
    current_data.Channel, current_data.campaign_name;

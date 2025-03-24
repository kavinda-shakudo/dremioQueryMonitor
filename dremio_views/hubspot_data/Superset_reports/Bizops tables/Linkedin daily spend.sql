SELECT   DATE_TRUNC('DAY', start_ts) AS start_ts_day,
         SUM(costInUsd) AS daily_cost_in_usd,
         'Linkedin' AS Channel,
         name AS campaignname
FROM     marketing.linkedin_campaigns_combined AS lcc
WHERE    costInUsd > 0
GROUP BY start_ts_day, campaignname
ORDER BY start_ts_day DESC,
         daily_cost_in_usd DESC;
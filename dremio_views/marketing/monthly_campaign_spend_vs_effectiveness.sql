SELECT    lcc."name",
          DATE_TRUNC('MONTH', start_ts) AS start_ts_month,
          SUM(costInUsd) AS Sum_costInUsd,
          MAX(lcmm.cost_per_meeting) AS expected_cost_per_meeting,
          CAST(CAST(DATE_DIFF(CURRENT_DATE(), MIN(earliest_start_date)) AS INTERVAL DAY) AS INT) as campaign_age
FROM      marketing.linkedin_campaigns_combined AS lcc
LEFT JOIN marketing."linkedin_conversions_to_meetings_monthly" lcmm
ON        LOWER(lcc.name) = LOWER(lcmm.name)
WHERE     costInUsd > 0
GROUP BY  lcc."name",
          start_ts_month
ORDER BY  start_ts_month DESC,
          Sum_costInUsd DESC;
SELECT   earliest_start_date,
         name,
         CASE WHEN num_meetings > 0 THEN usd_cost / num_meetings ELSE CAST('Inf' AS FLOAT) END AS cost_per_meeting,
         CASE WHEN num_deals > 0 THEN usd_cost / num_deals ELSE CAST('Inf' AS FLOAT) END AS cost_per_deal,
         CASE WHEN num_won_deals > 0 THEN usd_cost / num_won_deals ELSE CAST('Inf' AS FLOAT) END AS cost_per_won_deal,
         CASE WHEN num_trial_deals > 0 THEN usd_cost / num_trial_deals ELSE CAST('Inf' AS FLOAT) END AS cost_per_trial_deal,
         usd_cost,
         num_meetings,
         num_won_deals,
         num_trial_deals,
         num_deals
FROM     (SELECT   MIN(li_combined.start_ts) as earliest_start_date,
                   li_combined.activity_name AS name,
                   SUM(li_combined.costInUsd) AS usd_cost,
                   SUM(COALESCE(li_combined.num_meetings, 0)) AS num_meetings,
                   SUM(COALESCE(li_combined.num_won_deals, 0)) AS num_won_deals,
                   SUM(COALESCE(li_combined.num_trial_deals, 0)) AS num_trial_deals,
                   SUM(COALESCE(li_combined.num_deals, 0)) AS num_deals
          FROM     (SELECT          *
                    FROM            marketing."meetings_per_day_by_campaign" cte_meetings
                    FULL OUTER JOIN marketing."deals_per_day_by_campaign_aggregate" cte_deals
                    ON              cte_meetings.start_ts = cte_deals.start_ts AND
                                    cte_meetings.activity_name = cte_deals.activity_name
                   ) li_combined
          GROUP BY li_combined.activity_name
         ) lcm
ORDER BY
         -- Adjust the ORDER BY clause to sort by effectiveness
         usd_cost DESC,
         cost_per_won_deal ASC;
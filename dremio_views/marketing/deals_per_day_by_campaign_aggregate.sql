SELECT    lcc.start_ts,
          LOWER(lcc.name) AS activity_name,
          COALESCE(dpdc.num_won_deals, 0) as num_won_deals,
          COALESCE(dpdc.num_trial_deals, 0) as num_trial_deals,
          COALESCE(dpdc.num_deals, 0) as num_deals,
          lcc.campaign_id,
          lcc.created_ts,
          lcc.end_ts,
          COALESCE(lcc.costInUsd, 0) AS costInUsd
FROM      linkedin_campaigns_combined lcc
LEFT JOIN marketing."deals_per_day_by_campaign" dpdc
ON        lcc.start_ts = dpdc.contact_createdat_day AND
          LOWER(lcc.name) = dpdc.hs_analytics_source_data_2
ORDER BY  lcc.start_ts DESC
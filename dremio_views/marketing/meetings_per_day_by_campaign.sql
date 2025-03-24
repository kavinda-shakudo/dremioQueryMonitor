SELECT    lcc.start_ts,
          LOWER(lcc.name) AS activity_name,
          COALESCE(lcmpd.num_meetings, 0) AS num_meetings,
          lcc.campaign_id,
          lcc.created_ts,
          lcc.end_ts,
          COALESCE(lcc.costInUsd, 0) AS costInUsd
FROM      linkedin_campaigns_combined lcc
LEFT JOIN linkedin_campaign_meetings_per_day lcmpd
ON        lcmpd.contact_create_date_day = lcc.start_ts AND
          LOWER(lcmpd.hs_analytics_source_data_2) = LOWER(lcc.name)
ORDER BY  lcc.start_ts DESC
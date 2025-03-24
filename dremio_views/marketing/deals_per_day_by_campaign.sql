SELECT   DATE_TRUNC('DAY', contact_createdat) as contact_createdat_day,
         hs_analytics_source_data_2,
         SUM(CASE WHEN earliest_won IS NOT NULL THEN 1 ELSE 0 END) as num_won_deals,
         SUM(CASE WHEN earliest_trial IS NOT NULL THEN 1 ELSE 0 END) as num_trial_deals,
         COUNT(company_id) AS num_deals
FROM     "hubspot_data".reports."customers_from_online_sources"
GROUP BY DATE_TRUNC('DAY', contact_createdat),
         hs_analytics_source_data_2
ORDER BY contact_createdat_day DESC
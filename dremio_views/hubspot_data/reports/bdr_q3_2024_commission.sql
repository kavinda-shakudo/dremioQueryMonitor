SELECT    bdr_email,
          SUM(CASE WHEN daily_activity_bonus_achieved = true THEN 50 ELSE 0 END) AS activity_bonus,
          SUM(opps_commission) as opps_commission_total
FROM      "hubspot_data".reports."bdrs_activity_q3_2024"
GROUP BY  bdr_email
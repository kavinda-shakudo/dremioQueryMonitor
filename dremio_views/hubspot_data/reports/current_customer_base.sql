SELECT    ARRAY_AGG(d.properties_dealname) AS all_company_deals,
          SUM(d.properties_amount_in_home_currency) AS total_arr,
          MIN(d."properties_hs_v2_date_entered_closedwon".member0) as earliest_date_won,
          MAX(d."properties_hs_v2_date_entered_37336401".member0) as latest_date_churned,
          c.id as company_id,
          c.properties_name as company_name
FROM      "hubspot_data"."deals_deduped" d
LEFT JOIN hubspot_data.companies_deduped c
ON        c.id = d.companies[0]
WHERE     d."properties_hs_v2_date_entered_closedwon".member0 < CURRENT_DATE AND
          (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
           d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0) AND
          d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY  c.id,
          c.properties_name;
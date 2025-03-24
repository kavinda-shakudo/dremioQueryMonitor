SELECT 
    ARRAY_AGG(d.properties_dealname) AS all_company_deals,
    SUM(d.properties_amount_in_home_currency) AS total_arr,
    MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
    MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
    c.id AS company_id,
    c.properties_name AS company_name
FROM 
    "hubspot_data"."deals_deduped" d
LEFT JOIN 
    companies_deduped c ON c.id = d.companies[0]
WHERE 
    d."properties_hs_v2_date_entered_closedwon".member0 < DATE_TRUNC('month', DATE_ADD(CURRENT_DATE, INTERVAL '-3' MONTH))
    AND (
        d."properties_hs_v2_date_entered_37336401".member0 IS NULL 
        OR d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 
        OR d."properties_hs_v2_date_entered_37336401".member0 >= DATE_TRUNC('month', DATE_ADD(CURRENT_DATE, INTERVAL '-3' MONTH))
    ) AND "properties_hs_v2_date_entered_closedlost" IS NULL
GROUP BY 
    c.id, c.properties_name
SELECT           DATE_TRUNC('Month', CURRENT_DATE) AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name

UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '1' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '1' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '2' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '2' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '2' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '3' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '3' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '3' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '4' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '4' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '4' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '5' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '5' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '5' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '6' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '6' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '6' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '7' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '7' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '7' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '8' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '8' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '8' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '9' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '9' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '9' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '10' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '10' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '10' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '11' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '11' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '11' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
UNION ALL SELECT DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '12' MONTH AS Date_range,
                 ARRAY_AGG(d.properties_dealname) AS all_company_deals,
                 SUM(d.properties_amount_in_home_currency) AS total_arr,
                 MIN(d."properties_hs_v2_date_entered_closedwon".member0) AS earliest_date_won,
                 MAX(d."properties_hs_v2_date_entered_37336401".member0) AS latest_date_churned,
                 c.id AS company_id,
                 c.properties_name AS company_name
FROM             "hubspot_data"."deals_deduped" d
LEFT JOIN        "hubspot_data"."companies_deduped" c
ON               c.id = d.companies[0]
WHERE            d."properties_hs_v2_date_entered_closedwon".member0 < date_trunc('month', CURRENT_DATE) - INTERVAL '12' MONTH AND
                 (d."properties_hs_v2_date_entered_37336401".member0 IS NULL OR
                  d."properties_hs_v2_date_entered_37336401".member0 < d."properties_hs_v2_date_entered_closedwon".member0 OR
                  d."properties_hs_v2_date_entered_37336401".member0 >= date_trunc('month', CURRENT_DATE)- INTERVAL '12' MONTH ) AND
                 d."properties_hs_v2_date_entered_closedlost".member0 IS NULL
GROUP BY         c.id,
                 c.properties_name
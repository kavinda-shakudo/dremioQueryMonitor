WITH      deals_cte AS (
            SELECT DISTINCT *
            FROM            (SELECT d.properties_dealname AS deal_name,
                                    d.properties_amount_in_home_currency,
                                    d.properties_hs_date_entered_closedwon.member0 AS date_won,
                                    d.properties_hs_date_entered_37336401.member0 AS date_churned,
                                    d.properties [ 'hs_date_entered_presentationscheduled' ] . member0 AS date_entered_trial,
                                    FLATTEN(d.companies) companies_aggd,
                                    d.properties_hs_object_id AS deal_id
                             FROM   "hubspot_data"."deals_deduped" d
                             WHERE  d.properties_hs_date_entered_closedwon.member0 < CURRENT_DATE() AND
                                    d.properties_hs_date_entered_37336401 IS NULL))
SELECT    c.id AS company_id,
          c.properties_name AS company_name,
          SUM(deals_cte.properties_amount_in_home_currency) AS total_amount,
          ARRAY_AGG(deals_cte.deal_name) AS deal_names,
          ARRAY_AGG(deals_cte.date_won) AS dates_won,
          MIN(deals_cte.date_won) AS earliest_won,
          ARRAY_AGG(deals_cte.date_churned) AS dates_churned,
          ARRAY_AGG(deals_cte.date_entered_trial) AS dates_entered_trial,
          MIN(deals_cte.date_entered_trial) AS earliest_trial,
          ARRAY_AGG(deals_cte.deal_id) AS deal_ids
FROM      deals_cte
LEFT JOIN "hubspot_data"."companies_deduped" c
ON        c.id = deals_cte.companies_aggd
GROUP BY  c.id,
          c.properties_name;
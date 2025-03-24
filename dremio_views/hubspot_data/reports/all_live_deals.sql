WITH      deals_cte AS (
            SELECT    d.properties_dealname AS deal_name,
                      d.createdat.member0 AS deal_createdat,
                      dp.label as deal_stage,
                      d.properties_amount_in_home_currency,
                      d.properties_hs_date_entered_closedwon.member0 AS date_won,
                      d.properties_hs_date_entered_37336401.member0 AS date_churned,
                      d.properties [ 'hs_date_entered_presentationscheduled' ] . member0 AS date_entered_trial,
                      FLATTEN(d.companies) companies_aggd,
                      d.properties_hs_object_id AS deal_id
            FROM      "hubspot_data"."deals_deduped" d
            LEFT JOIN hubspot_data.deal_pipelines_deduped dp
            ON        d.properties_dealstage = dp.stageId
            WHERE     dp.pipeline_name = 'Sales Pipeline')
          -- dp.label NOT IN (
          --             'Closed lost',
          --             'Churned',
          --             'Parking lot') AND
SELECT    c.id AS company_id,
          c.properties_name AS company_name,
          MIN(deal_createdat) AS earliest_deal_createdat,
          SUM(deals_cte.properties_amount_in_home_currency) AS total_amount,
          ARRAY_AGG(deal_stage) AS all_deal_stages,
          ARRAY_AGG(deals_cte.deal_name) AS deal_names,
          LISTAGG(deals_cte.date_won,',') AS dates_won,
          MIN(deals_cte.date_won) AS earliest_won,
          LISTAGG(deals_cte.date_churned, ',') AS dates_churned,
          LISTAGG(deals_cte.date_entered_trial, ',') AS dates_entered_trial,
          MIN(deals_cte.date_entered_trial) AS earliest_trial,
          LISTAGG(deals_cte.deal_id, ',') AS deal_ids
FROM      deals_cte
LEFT JOIN "hubspot_data"."companies_deduped" c
ON        c.id = deals_cte.companies_aggd
GROUP BY  c.id,
          c.properties_name
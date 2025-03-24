SELECT CAST(createdat AS DATE) as createdat,
       deal_name,
       deal_stage,
       pipeline_name,
       deal_amount,
       deal_amount_usd,
       bdr_email,
       CAST(date_entered_disco1 AS DATE) as date_entered_disco1,
       CAST(date_entered_disco2 AS DATE) as date_entered_disco2,
       CAST(date_entered_disco3 AS DATE) as date_entered_disco3,
       CAST(date_entered_contracting AS DATE) as date_entered_contracting,
       CAST(date_entered_trial AS DATE) as date_entered_trial,
       CAST(date_entered_closedwon AS DATE) as date_entered_closedwon
FROM   (SELECT createdat,
               deal_name,
               deal_stage,
               pipeline_name,
               deal_amount,
               deal_amount_usd,
               bdr_email,
               date_entered_disco1,
               date_entered_disco2,
               date_entered_disco3,
               date_entered_contracting,
               date_entered_trial,
               date_entered_closedwon,
               date_entered_closedlost
        FROM   hubspot_data.reports.opps_by_person AS opps_by_person
       ) nested_0
WHERE  createdat >= DATE_SUB(DATE_TRUNC('quarter', CURRENT_DATE()), CAST(3 AS INTERVAL MONTH)) AND
       createdat < DATE_TRUNC('quarter', CURRENT_DATE()) AND
       bdr_email IN (
         'aman@shakudo.io',
         'daniel1@shakudo.io',
         'ethan@shakudo.io',
         'david@shakudo.io',
         'kenneth@shakudo.io')
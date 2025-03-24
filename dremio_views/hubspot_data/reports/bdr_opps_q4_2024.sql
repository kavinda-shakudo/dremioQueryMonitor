SELECT DATE_TRUNC('day', "createdat") AS createdat,
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
       date_entered_closedwon
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
WHERE  createdat >= '2024-10-01' AND
       createdat < '2025-01-01' AND
       bdr_email IN (
         'jacob@shakudo.io',
         'aman@shakudo.io',
         'gabe@shakudo.io')
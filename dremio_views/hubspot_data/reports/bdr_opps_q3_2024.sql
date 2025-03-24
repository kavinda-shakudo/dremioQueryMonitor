SELECT DATE_TRUNC('day', "createdat") AS createdat,
       deal_name,
       deal_stage,
       pipeline_name,
       deal_amount,
       deal_amount_usd,
       firstname
FROM   (SELECT createdat,
               deal_name,
               deal_stage,
               pipeline_name,
               deal_amount,
               deal_amount_usd,
               firstname
        FROM   hubspot_data.reports.opps_by_person AS opps_by_person
       ) nested_0
WHERE  createdat >= '2024-07-01' AND
       createdat < '2024-10-01' AND
       firstname IN (
         'Jacob',
         'Aman',
         'Gabe')
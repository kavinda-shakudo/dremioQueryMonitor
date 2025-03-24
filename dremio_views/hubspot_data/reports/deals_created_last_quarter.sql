SELECT *
FROM   "hubspot_data".reports."opps_by_person" d
WHERE  DATE_TRUNC('Quarter', d.createdat) < DATE_TRUNC('Quarter', CURRENT_DATE()) AND
       DATE_TRUNC('Quarter', d.createdat) >= DATE_TRUNC('Quarter', DATE_SUB(DATE_TRUNC('Quarter', CURRENT_DATE()), 90)) AND
       pipeline_name = 'Sales Pipeline'
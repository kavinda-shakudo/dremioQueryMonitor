SELECT 
    email AS bdr_email, 
    SUM(CASE WHEN duration > 30 THEN 1 ELSE 0 END) AS num_connects, 
    COUNT(*) AS total_dials 
FROM nessie.crm."twilio_call_records" AS t
LEFT JOIN hubspot_data.owners o 
    ON t.owner_id = o.id
WHERE 
    DATE_TRUNC('DAY', TIMESTAMPADD(HOUR, -5, date_created)) = DATE_TRUNC('DAY', TIMESTAMPADD(HOUR, -5, CURRENT_TIMESTAMP))
    AND call_from NOT LIKE 'client%'
    AND call_to NOT LIKE 'client%'
    AND call_to NOT LIKE '+1800%'
    AND call_to NOT LIKE '%9840735%'
    AND call_to NOT LIKE '%5530562%'
    AND call_to NOT LIKE '%7835683%'
    AND call_to LIKE '+1%'
    AND owner_id IS NOT NULL
    AND owner_id <> ''
    AND contact_id <> '82763660106'
    AND teams[0].id = '38063404'
GROUP BY bdr_email
ORDER BY bdr_email
SELECT  
    CAST(e.activitydate AS DATE) AS activity_date,
    e.bdr_email,
    e.num_linkedin_touches,
    e.num_calls,
    e.num_emails,
    SUM(e.num_linkedin_touches+e.num_calls+e.num_emails) AS Total_touches,
    e.contact_id,
    c."properties_firstname",
    c."properties_lastname",
    c."properties_email",
    c."properties_createdate".member0 AS create_date,
    c."properties_hs_analytics_source"
FROM (
    SELECT  
        DATE_TRUNC('day', CAST(e.createdAt AS TIMESTAMP)) AS activitydate,
        o.email AS bdr_email,
        SUM(CASE WHEN e.type = 'LINKEDIN_MESSAGE' THEN 1 ELSE 0 END) AS num_linkedin_touches,
        SUM(CASE WHEN e.type = 'CALL' THEN 1 ELSE 0 END) AS num_calls,
        SUM(CASE WHEN e.type = 'EMAIL' THEN 1 ELSE 0 END) AS num_emails,
        e.associations_contactIds[0] AS contact_id
    FROM  
        hubspot_data.engagements_deduped e
    LEFT JOIN 
        hubspot_data.owners o ON e.ownerId = o.id
    WHERE  
   
        activitydate > DATE '2024-09-30' AND
        e.type IN ('CALL', 'EMAIL', 'LINKEDIN_MESSAGE') AND
        o.email IN ('aman@shakudo.io', 'gabe@shakudo.io')
    GROUP BY  
        DATE_TRUNC('day', CAST(e.createdAt AS TIMESTAMP)), 
        o.email,
        contact_id
) e
LEFT JOIN 
    hubspot_data.owners o ON e.bdr_email = o.email
LEFT JOIN 
    hubspot_data.reports.opps_by_person op ON op.firstname = o.firstName 
                                            AND DATE_TRUNC('day', CAST(op.createdat AS TIMESTAMP)) = e.activitydate
                                            AND op.pipeline_name = 'Sales Pipeline'
JOIN "hubspot_data"."contacts_deduped" c ON e.contact_id = c."properties_hs_object_id"
GROUP BY  
    activitydate,
    e.bdr_email,
    e.num_linkedin_touches,
    e.num_calls,
    e.num_emails,
    e.contact_id,
    c."properties_firstname",
    c."properties_lastname",
    c."properties_email",
    create_date,
    c."properties_hs_analytics_source"
ORDER BY 
    activity_date DESC;
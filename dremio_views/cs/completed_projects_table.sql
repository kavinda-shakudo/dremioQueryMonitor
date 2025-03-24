SELECT 
    client, 
    project,
    min(created_date) as beggining_date,
    max(deadline) as end_date
FROM 
    "minio"."customer-success"
WHERE 
    today_date = CURRENT_DATE
    AND project != 'No Project'
    AND status != 'Abandoned'
    AND status != 'Backlog'
GROUP BY 
    client, project
HAVING 
    COUNT(CASE WHEN status != 'Done' THEN 1 END) = 0;

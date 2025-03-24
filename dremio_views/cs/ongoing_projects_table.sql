SELECT DISTINCT
    client, 
    project AS ongoing_projects
FROM 
    "minio"."customer-success"
WHERE 
    today_date = CURRENT_DATE
    AND status NOT IN ('Done', 'Abandoned', 'Backlog')
    AND project NOT IN ('No Project')



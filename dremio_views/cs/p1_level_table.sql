SELECT * 
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
AND labels = 'p1'
AND deadline < DATE_ADD(CURRENT_DATE, 2)
AND status not in ('Done','Abandoned','Backlog')
ORDER BY deadline ASC;
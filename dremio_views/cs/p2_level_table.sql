SELECT * 
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
AND labels = 'p2'
AND deadline < DATE_ADD(CURRENT_DATE, 3)
AND status not in ('Done','Abandoned','Backlog')
ORDER BY deadline ASC;
SELECT * 
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
AND labels = 'p0'
AND deadline < DATE_ADD(CURRENT_DATE, 1)
AND status not in ('Done','Abandoned','Backlog')
ORDER BY deadline ASC;
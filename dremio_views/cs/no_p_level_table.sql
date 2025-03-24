SELECT * 
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
AND labels not in ('p0','p1','p2')
AND deadline < DATE_ADD(CURRENT_DATE, 10)
AND support <> 'support and solution engineering'
AND status not in ('Done','Abandoned','Backlog')
ORDER BY deadline ASC;
SELECT * 
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
  AND status NOT IN ('Done', 'Abandoned', 'Backlog')
  AND DATEDIFF(CURRENT_DATE, created_date) >= 45;
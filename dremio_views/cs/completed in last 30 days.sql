SELECT *
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
  AND deadline <= CURRENT_DATE
  AND status in ('Done')
  AND deadline >= DATE_SUB(CURRENT_DATE, 30)
  
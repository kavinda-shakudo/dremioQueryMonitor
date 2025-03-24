SELECT *
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE()
  
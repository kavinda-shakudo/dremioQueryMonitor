SELECT *
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
AND created_date >= DATE_SUB(CURRENT_DATE, 30)



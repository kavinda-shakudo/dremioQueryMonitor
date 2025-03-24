SELECT count(*) as tickets
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
  AND deadline <= CURRENT_DATE
  AND status NOT in ('Done', 'Abandoned', 'Backlog')
  
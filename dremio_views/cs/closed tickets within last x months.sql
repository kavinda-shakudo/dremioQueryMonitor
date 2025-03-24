SELECT lower(client), 
    COUNT(CASE 
              WHEN deadline >= DATE_SUB(CURRENT_DATE, 90) 
                   AND deadline <= CURRENT_DATE THEN 1 
          END) AS within_3_months,
    COUNT(CASE 
              WHEN deadline >= DATE_SUB(CURRENT_DATE, 180) 
                   AND deadline <= CURRENT_DATE THEN 1 
          END) AS within_6_months
FROM "minio"."customer-success"
WHERE today_date = CURRENT_DATE
  AND status IN ('Done')
  AND labels NOT IN ('p1 p2')
  GROUP BY lower(client);



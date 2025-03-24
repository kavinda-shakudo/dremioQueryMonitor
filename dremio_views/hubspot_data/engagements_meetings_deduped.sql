SELECT *
FROM   (SELECT *,
               ROW_NUMBER() OVER(PARTITION BY id) AS row_num
        FROM   minio."airbyte-hubspot-v2"."hubspot_engagements_meetings" co
       ) sub
WHERE  row_num = 1;
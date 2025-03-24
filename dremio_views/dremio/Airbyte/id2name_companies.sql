WITH   LatestRecords AS (
         SELECT rc._airbyte_ab_id,
                rc.id,
                ROW_NUMBER() OVER(PARTITION BY rc.id ORDER BY rc._airbyte_emitted_at DESC) AS row_num
         FROM   minio.airbyte."id2name_companies" as rc)
SELECT rc.*
FROM  minio.airbyte."id2name_companies"  rc
JOIN   (SELECT _airbyte_ab_id
        FROM   LatestRecords
        WHERE  row_num = 1
       ) lr
ON     rc._airbyte_ab_id = lr._airbyte_ab_id
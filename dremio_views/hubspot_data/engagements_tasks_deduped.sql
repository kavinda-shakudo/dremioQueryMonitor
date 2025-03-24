WITH   LatestRecords AS (
         SELECT rc._airbyte_ab_id,
                rc.properties_hs_object_id,
                RANK() OVER(PARTITION BY rc.properties_hs_object_id ORDER BY rc._airbyte_emitted_at DESC) AS row_num
         FROM   minio.airbyte.engagements_tasks rc)
SELECT rc.*
FROM   minio.airbyte.engagements_tasks rc
JOIN   (SELECT _airbyte_ab_id
        FROM   LatestRecords
        WHERE  row_num = 1
       ) lr
ON     rc._airbyte_ab_id = lr._airbyte_ab_id;
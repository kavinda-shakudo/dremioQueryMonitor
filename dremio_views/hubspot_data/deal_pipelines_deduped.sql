WITH            LatestRecords AS (
                  SELECT rc._airbyte_ab_id,
                         rc.label,
                         RANK() OVER(PARTITION BY rc.label ORDER BY rc._airbyte_emitted_at DESC) AS row_num
                  FROM   minio."airbyte-hubspot-v2"."hubspot_deal_pipelines" rc),
                LatestPipes AS (
                  SELECT rc.*
                  FROM   minio."airbyte-hubspot-v2"."hubspot_deal_pipelines" rc
                  JOIN   (SELECT _airbyte_ab_id
                          FROM   LatestRecords
                          WHERE  row_num = 1
                         ) lr
                  ON     rc._airbyte_ab_id = lr._airbyte_ab_id)
SELECT DISTINCT fdp.stage.label,
                fdp.stage.stageId,
                fdp.pipeline_name
FROM            (SELECT FLATTEN(dp.stages) AS stage,
                        label as pipeline_name
                 FROM   LatestPipes dp
                ) fdp
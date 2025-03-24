WITH   LatestRecords AS (
         SELECT rc._airbyte_ab_id,
                rc.start_date_adj,
                rc.pivotValue_adj,
                RANK() OVER(PARTITION BY rc.start_date_adj, rc.pivotValue_adj ORDER BY rc._airbyte_emitted_at DESC) AS row_num
         FROM   (SELECT da.pivotValues[0] as pivotValue_adj,
                        da.start_date.member0 as start_date_adj,
                        *
                 FROM   minio.airbyte.linkedin_ads_v2_ad_campaign_analytics da
                ) rc)
SELECT rc.*
FROM   minio.airbyte.linkedin_ads_v2_ad_campaign_analytics rc
JOIN   (SELECT _airbyte_ab_id
        FROM   LatestRecords
        WHERE  row_num = 1
       ) lr
ON     rc._airbyte_ab_id = lr._airbyte_ab_id;
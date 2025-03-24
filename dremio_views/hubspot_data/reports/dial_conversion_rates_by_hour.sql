SELECT time_segment_start, total_calls, calls_30s_to_1min, calls_1min_or_more, percentage_calls_30s_to_1min, percentage_calls_1min_or_more
FROM (
  SELECT
      sub.time_segment_start,
      sub.total_calls,
      sub.calls_30s_to_1min,
      sub.calls_1min_or_more,
      CASE
          WHEN sub.total_calls > 0 THEN (sub.calls_30s_to_1min * 1.0) / sub.total_calls
          ELSE NULL
      END AS percentage_calls_30s_to_1min,
      CASE
          WHEN sub.total_calls > 0 THEN (sub.calls_1min_or_more * 1.0) / sub.total_calls
          ELSE NULL
      END AS percentage_calls_1min_or_more
  FROM (
      SELECT
          FLOOR(EXTRACT(HOUR FROM CONVERT_TIMEZONE('UTC', 'America/New_York', c.createdat))) AS time_segment_start,
          COUNT(*) AS total_calls,
          COUNT(
              CASE
                  WHEN c.properties_hs_call_duration > 30000
                       AND c.properties_hs_call_duration < 60000
                       AND d.event IN ('connected', 'connected meeting booked', 'wrong timing', 'low priority', 'no budget')
                  THEN 1
              END
          ) AS calls_30s_to_1min,
          COUNT(
              CASE
                  WHEN c.properties_hs_call_duration >= 60000
                       AND d.event IN ('connected', 'connected meeting booked', 'wrong timing', 'low priority', 'no budget')
                  THEN 1
              END
          ) AS calls_1min_or_more
      FROM hubspot_data.derived_views.calls_by_bdr_non_active_deal_v1 AS c
      JOIN minio.generateddata."hubspot_dispositions" d
          ON c.properties_hs_call_disposition = d."id"
      WHERE c.firstname IN ('Aman', 'Jacob', 'Abdul')
      GROUP BY
          time_segment_start
  ) AS sub
  ORDER BY
      sub.time_segment_start ASC
) nested_0
ORDER BY percentage_calls_1min_or_more DESC
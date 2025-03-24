SELECT    c.firstname,
          DATE_TRUNC('day', c.createdat) AS work_day,
          COUNT(c.engagement_id) AS total_calls,
          COUNT(CASE WHEN c.properties_hs_call_duration > 30000 AND c.properties_hs_call_duration < 60000 AND d.event IN('connected', 'connected meeting booked', 'wrong timing', 'low priority', 'no budget') THEN 1 END) AS calls_30s_to_1min,
          COUNT(CASE WHEN c.properties_hs_call_duration >= 60000 AND d.event IN('connected', 'connected meeting booked', 'wrong timing', 'low priority', 'no budget') THEN 1 END) AS calls_1min_or_more
FROM      hubspot_data.derived_views.calls_by_bdr_all AS c
LEFT JOIN minio.generateddata."hubspot_dispositions" d
ON        c.properties_hs_call_disposition = d."id"
WHERE     firstname in (
            'Aman',
            'Jacob',
            'Abdul',
            'Gabe')
GROUP BY  firstname,
          DATE_TRUNC('day', c.createdat)
ORDER BY  work_day DESC,
          firstname ASC
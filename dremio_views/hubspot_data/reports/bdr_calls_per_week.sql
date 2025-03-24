SELECT   c.firstname,
         DATE_TRUNC('week', c.createdat) AS week,
         COUNT(*) AS total_calls,
         COUNT(CASE WHEN c.properties_hs_call_duration > 30000 AND c.properties_hs_call_duration < 60000 AND d.event IN('connected', 'connected meeting booked', 'wrong timing', 'low priority', 'no budget') THEN 1 END) AS calls_30s_to_1min,
         COUNT(CASE WHEN c.properties_hs_call_duration >= 60000 AND d.event IN('connected', 'connected meeting booked', 'wrong timing', 'low priority', 'no budget') THEN 1 END) AS calls_1min_or_more
FROM     hubspot_data.derived_views.calls_by_bdr_non_active_deal_v1 AS c
JOIN     minio.generateddata."hubspot_dispositions" d
ON       c.properties_hs_call_disposition = d."id"
WHERE    email in (
           'aman@shakudo.io',
           'david@shakudo.io',
           'kenneth@shakudo.io',
           'ethan@shakudo.io',
           'drew@shakudo.io',
           'daniel1@shakudo.io')
GROUP BY firstname,
         DATE_TRUNC('week', c.createdat)
ORDER BY week DESC,
         firstname ASC
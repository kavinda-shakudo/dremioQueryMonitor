SELECT    DATE_TRUNC('DAY', CAST(ed.createdAt AS TIMESTAMP)) as date_ts,
          o.email,
          ed.type,
          COUNT(ed.id) as num_engagements
FROM      hubspot_data.engagements_deduped ed
LEFT JOIN hubspot_data.owners o
ON        ed.ownerId = o.id
WHERE     ownerId IN (
            '1538647770',
            '96502188') AND
          type IN (
            'CALL',
            'EMAIL')
GROUP BY  o.email,
          ed.type,
          date_ts
ORDER BY  date_ts DESC;
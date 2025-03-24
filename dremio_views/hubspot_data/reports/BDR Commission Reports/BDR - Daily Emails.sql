SELECT    c.firstname,
          DATE_TRUNC('day', c.createdat) AS work_day,
          COUNT(c.engagement_id) AS total_emails
FROM      hubspot_data.derived_views.bdr_engagements_email AS c
WHERE     firstname in (
            'Aman',
            'Jacob',
            'Abdul',
            'Gabe')
GROUP BY  firstname,
          DATE_TRUNC('day', c.createdat)
ORDER BY  work_day DESC,
          firstname ASC
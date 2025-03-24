SELECT    activity_date,
          e.bdr_email,
          num_linkedin_touches,
          num_calls,
          num_emails,
          daily_activity_bonus_achieved,
          SUM(CASE WHEN op.date_entered_disco1 IS NOT NULL THEN 150 ELSE 0 END + CASE WHEN op.date_entered_disco2 IS NOT NULL THEN 250 ELSE 0 END + CASE WHEN op.date_entered_closedwon IS NOT NULL THEN 2000 ELSE 0 END) as opps_commission
FROM      (SELECT    DATE_TRUNC('day', CAST(e.createdAt AS TIMESTAMP)) as activity_date,
                     o.email as bdr_email,
                     SUM(CASE type WHEN 'LINKEDIN_MESSAGE' THEN 1 ELSE 0 END) as num_linkedin_touches,
                     SUM(CASE type WHEN 'CALL' THEN 1 ELSE 0 END) as num_calls,
                     SUM(CASE type WHEN 'EMAIL' THEN 1 ELSE 0 END) as num_emails,
                     num_calls > 100 AND
                     num_linkedin_touches + num_emails > 50 AS daily_activity_bonus_achieved
           FROM      hubspot_data.engagements_deduped e
           LEFT JOIN hubspot_data.owners o
           ON        e.ownerId = o.id
           WHERE     CAST(e.createdAt AS TIMESTAMP) >= '2024-07-01' AND
                     CAST(e.createdAt AS TIMESTAMP) < '2024-10-01' AND
                     e.type IN (
                       'CALL',
                       'EMAIL',
                       'LINKEDIN_MESSAGE') AND
                     o.email IN (
                       'aman@shakudo.io',
                       'jacob@shakudo.io',
                       'gabe@shakudo.io')
           GROUP BY  bdr_email,
                     activity_date
           ORDER BY  activity_date DESC
          ) e
LEFT JOIN hubspot_data.owners o
ON        e.bdr_email = o.email
LEFT JOIN "hubspot_data".reports."opps_by_person" op
ON        op.firstname = o.firstName AND
          DATE_TRUNC('day', op.createdat) = activity_date AND
          op.pipeline_name = 'Sales Pipeline'
GROUP BY  activity_date,
          bdr_email,
          num_linkedin_touches,
          num_calls,
          num_emails,
          daily_activity_bonus_achieved
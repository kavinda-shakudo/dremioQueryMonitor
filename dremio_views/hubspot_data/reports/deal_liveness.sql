SELECT   deals.id,
         deals.properties_dealname,
         dp.label,
         deals.createdAt.member0 as createdat,
         MIN(c.properties_notes_next_activity_date.member0) as next_activity_date,
         ARRAY_AGG(c.properties_notes_next_activity_date.member0) as next_activity_dates,
         MAX(c.properties_notes_last_contacted.member0) as last_contacted_date,
         MIN(CAST(CAST(DATE_DIFF(c.properties_notes_next_activity_date.member0, CURRENT_DATE()) AS INTERVAL DAY) AS INT)) as days_until_next_activity,
         CAST(CAST(DATE_DIFF(CURRENT_DATE(), MAX(c.properties_notes_last_contacted.member0)) AS INTERVAL DAY) AS INT) as days_since_last_contact,
         ARRAY_AGG(c.id) as contact_ids
FROM     (SELECT *,
                 FLATTEN(deals.contacts) as contact_id
          FROM   hubspot_data.deals_deduped deals
         ) deals
JOIN     deal_pipelines_deduped dp
ON       deals.properties_dealstage = dp.stageId
JOIN     contacts_deduped c
ON       deals.contact_id = c.id
WHERE    properties_dealname = 'MongoDB Inc - Reseller'
GROUP BY deals.id,
         deals.properties_dealname,
         dp.label,
         deals.createdAt.member0
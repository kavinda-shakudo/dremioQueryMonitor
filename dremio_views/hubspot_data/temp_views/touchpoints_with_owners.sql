SELECT    e.id as engagement_id,
          CAST(e.createdAt AS TIMESTAMP) as createdat,
          e.metadata_title,
          e.type,
          FLATTEN(e.associations_contactIds) as contact_id,
          o.email
FROM      hubspot_data.engagements_deduped e
LEFT JOIN hubspot_data.owners o
ON        e.ownerId = o.id
WHERE     e.type NOT IN ('TASK')
SELECT    c.id as contact_id,
          co.id as company_id,
          c.properties_firstname,
          c.properties_lastname,
          c.properties_jobtitle,
          co.properties_name,
          c.properties_hs_latest_source_timestamp.member0 as latest_source_ts,
          c.createdAt.member0 as createdat,
          c.properties_hs_object_source,
          c.properties_hs_analytics_source,
          c.properties_hs_object_source_id,
          c.properties_hs_object_source_label,
          c.properties_hs_latest_source_data_1,
          c.properties_hs_latest_source_data_2,
          c.properties_hs_object_source_detail_1
FROM      hubspot_data.contacts_deduped c
LEFT JOIN hubspot_data.companies_deduped co
ON        c.properties_associatedcompanyid = co.id
WHERE     DATE_TRUNC('HOUR', latest_source_ts) <> DATE_TRUNC('HOUR', c.createdAt.member0)
ORDER BY  latest_source_ts DESC;
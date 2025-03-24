SELECT    d.id,
          d.properties_dealname as dealname,
          dp.pipeline_name,
          dp.label as dealstage,
          co.properties_name as company_name,
          co.id as company_id,
          o.email as owner_email,
          -- Convert to snake case here
          lower(regexp_replace(regexp_replace(co.properties_name, '[^a-zA-Z0-9]', ''), '([a-z])([A-Z])', '$1_$2')) || '_deal_channel' AS mm_channel_name
FROM      hubspot_data.deals_deduped d
LEFT JOIN hubspot_data.deal_pipelines_deduped dp
ON        d.properties_dealstage = dp.stageId
LEFT JOIN hubspot_data.companies_deduped co
ON        d.companies[0] = co.id
LEFT JOIN hubspot_data.owners o
ON        o.id = d.properties_hubspot_owner_id
WHERE     dealstage NOT IN (
            'Closed lost',
            'Parking lot',
            'Churned') and
          pipeline_name = 'Sales Pipeline';
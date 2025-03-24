SELECT    id as contact_id,
          mqls.createdAt,
          mqls.updatedAt,
          properties_lastname as lastname,
          properties_firstname as firstname,
          properties_hs_analytics_source as hs_analytics_source,
          properties_hs_analytics_source_data_1 as hs_analytics_source_data_1,
          properties_hs_analytics_source_data_2 as hs_analytics_source_data_2,
          properties_hs_object_source_detail_1 as hs_object_source_detail_1,
          properties_lead_source as lead_source,
          properties_lead_source_detail as lead_source_detail,
          properties_jobtitle as jobtitle,
          properties_role_seniority as role_seniority,
          properties_linkedin_profile_link as linkedin_profile_link,
          hs_latest_source_timestamp,
          engagement_id,
          touches.createdat as engagement_at,
          type,
          email as owner_email
FROM      "hubspot_data"."derived_views"."all_mqls_all_dates" mqls
LEFT JOIN "hubspot_data"."temp_views"."touchpoints_with_owners" touches
ON        mqls.id = touches.contact_id
WHERE     touches.engagement_id IS NOT NULL
ORDER BY  mqls.createdat DESC,
          engagement_at ASC;
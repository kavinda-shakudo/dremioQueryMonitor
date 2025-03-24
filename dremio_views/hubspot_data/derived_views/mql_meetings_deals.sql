SELECT   contact_id,
         createdat as contact_create_date,
         MIN(hs_analytics_source) as hs_analytics_source,
         MIN(hs_analytics_source_data_1) as hs_analytics_source_data_1,
         MIN(hs_analytics_source_data_2) as hs_analytics_source_data_2,
         MIN(meeting_start_time) as first_meeting_start_time,
         MIN(meeting_created_date) as first_meeting_created_date
         --  ARRAY_AGG(DISTINCT deal_id) as associated_deals,
         --  ARRAY_AGG(DISTINCT label) as deal_stages,
         --  ARRAY_CONTAINS(ARRAY_AGG(DISTINCT label), 'Closed won') as won_deal_exists,
         --  ARRAY_CONTAINS(ARRAY_AGG(DISTINCT label), 'Evaluating') as trial_deal_exists,
         --  ARRAY_LENGTH(ARRAY_AGG(DISTINCT label)) > 0 AS deal_exists
FROM     derived_views.enhanced_contacts_v2
WHERE    meeting_calendar_url IS NOT NULL AND
         hs_analytics_source IS NOT NULL
GROUP BY contact_id,
         contact_create_date
SELECT 
    id AS contact_id,
    properties_hs_analytics_source AS hs_analytics_source,
    properties_hs_analytics_source_data_1 AS hs_analytics_source_data_1,
    properties_hs_analytics_source_data_2 AS hs_analytics_source_data_2,
    properties_lead_source AS lead_source,
    properties_lead_source_detail AS lead_source_detail,
    properties_city AS city,
    properties_state AS state
FROM hubspot_data.derived_views.all_mqls_all_dates
SELECT 
    COUNT("properties_email"), 
    CAST(nested_0.properties_hs_latest_source_timestamp.member0 AS DATE) AS hs_latest_source, 
    "properties_hs_latest_source_data_2", 
    latest_source_date,
    CAST(CAST("properties_hs_object_id" AS BIGINT) AS VARCHAR) AS hs_record_id, 
    "properties_company",
    "properties_demo_request_vs_non_demo",
    "properties_paid_social_attribution"
FROM (
    SELECT 
        "properties_email",
        "properties_hs_latest_source_timestamp", 
        "properties_hs_latest_source_data_2", 
        "properties_company", 
        "properties_hs_object_id",
        "properties_demo_request_vs_non_demo",
        "properties_paid_social_attribution",
        c."properties_hs_latest_source_timestamp".MEMBER0 AS latest_source_date
    FROM 
        hubspot_data.contacts_deduped c
    WHERE 
        "properties_paid_social_attribution" IN ('true')
) nested_0
GROUP BY 
    hs_latest_source, 
    "properties_hs_latest_source_data_2", 
    "properties_hs_object_id", 
    "properties_company",
    "properties_demo_request_vs_non_demo",
    "properties_paid_social_attribution",
    latest_source_date
ORDER BY 
    hs_latest_source DESC
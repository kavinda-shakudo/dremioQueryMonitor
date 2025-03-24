WITH data_with_id AS (
  SELECT 
    campaigns.name AS campaign_name,
    SUBSTRING(creatives.campaign, LENGTH('urn:li:sponsoredCampaign:') + 1) AS campaign_id,
    analytics.sponsoredCreative AS creative,
    analytics.likes AS ad_likes,
    analytics.clicks AS ad_clicks,
    analytics.costInUsd AS cost_USD,
    analytics.start_date.member0 AS start_date,
    analytics.impressions AS impressions,
    analytics.totalEngagements AS total_engagements,
    analytics.OneClickLeadFormOpens AS form_clicks,
    analytics.oneClickLeads AS leads,
    -- Create unique identifier
    CONCAT(
      SUBSTRING(creatives.campaign, LENGTH('urn:li:sponsoredCampaign:') + 1),
      '_',
      analytics.sponsoredCreative,
      '_',
      CAST(analytics.start_date.member0 AS VARCHAR)
    ) AS unique_id
  FROM 
    minio."partnership-apps"."deals_history"."ad_creative_analytics" analytics
  JOIN 
    minio."partnership-apps"."deals_history".creatives creatives
    ON analytics.sponsoredCreative = SUBSTRING(creatives.id, LENGTH('urn:li:sponsoredCreative:') + 1)
  JOIN
    minio."partnership-apps"."deals_history".campaigns campaigns
    ON SUBSTRING(creatives.campaign, LENGTH('urn:li:sponsoredCampaign:') + 1) = campaigns.id
),

-- Get distinct rows using ROW_NUMBER
distinct_data AS (
  SELECT
    campaign_name,
    campaign_id,
    creative,
    ad_likes,
    ad_clicks,
    cost_USD,
    start_date,
    impressions,
    total_engagements,
    form_clicks,
    leads
  FROM (
    SELECT 
      *,
      ROW_NUMBER() OVER (PARTITION BY unique_id ORDER BY unique_id) as row_num
    FROM data_with_id
  ) ranked
  WHERE row_num = 1
)

-- The rest remains the same
SELECT
    campaign_name,
    campaign_id,
    creative,
    ad_likes,
    ad_clicks,
    cost_USD,
    start_date,
    impressions,
    total_engagements,
    form_clicks,
    leads,
    SUM(form_clicks)/NULLIF(SUM(impressions), 0) AS impression_conversion,
    SUM(leads)/NULLIF(SUM(form_clicks), 0) AS click_conversion,
    (SUM(cost_USD)/NULLIF(SUM(impressions), 0))*1000 AS cpm,
    SUM(cost_USD)/NULLIF(SUM(leads), 0) AS cost_per_lead
FROM 
    distinct_data
GROUP BY
    campaign_name,
    campaign_id,
    creative,
    ad_likes,
    ad_clicks,
    cost_USD,
    start_date,
    impressions,
    total_engagements,
    form_clicks,
    leads
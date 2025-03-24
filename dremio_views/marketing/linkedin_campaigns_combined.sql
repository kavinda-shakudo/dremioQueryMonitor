-- SELECT   DATE_TRUNC('MONTH', first_meeting_created_date) as first_meeting_month,
--          COUNT(DISTINCT contact_id) as num_meetings,
--          hs_analytics_source_data_2
-- FROM     "hubspot_data"."derived_views"."mql_meetings_deals"
-- GROUP BY DATE_TRUNC('MONTH', first_meeting_created_date), hs_analytics_source_data_2
-- ORDER BY DATE_TRUNC('MONTH', first_meeting_created_date) DESC, COUNT(DISTINCT contact_id) DESC
-- SELECT *
-- FROM   hubspot_data.linkedin_ads_campaigns
select   c.name,
         c.id as campaign_id,
         c.created.member0 as created_ts,
         a_1.start_date.member0 as start_ts,
         a_1.end_date.member0 as end_ts,
         SUM(a_1.impressions) as impressions,
         SUM(a_1.clicks) as clicks,
         SUM(a_1.likes) as likes,
         SUM(a_1.sends) as sends,
         SUM(a_1.shares) as shares,
         SUM(a_1.follows) as follows,
         SUM(a_1.comments) as comments,
         SUM(a_1.costInUsd) as costInUsd,
         SUM(a_1.reactions) as reactions,
         SUM(a_1.oneClickLeads) as oneClickLeads,
         SUM(a_1.totalEngagements) as totalEngagements,
         SUM(a_1.viralImpressions) as viralImpressions
FROM     (hubspot_data.linkedin_ads_campaigns c
          LEFT JOIN hubspot_data.linkedin_ads_ad_campaign_analytics a_1
          ON        c.id = a_1.sponsoredCampaign)
WHERE    start_ts IS NOT NULL
GROUP BY c.name,
         c.id,
         c.created.member0,
         a_1.start_date.member0,
         a_1.end_date.member0
ORDER BY start_ts DESC
SELECT COUNT(*) as num_meetings, owner_firstname, ARRAY_AGG(DISTINCT meeting_title)
FROM   "hubspot_data"."derived_views"."upcoming_meetings_no_deal_bdrs"
GROUP BY owner_firstname
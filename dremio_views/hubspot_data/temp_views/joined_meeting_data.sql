SELECT 
    ff.meeting_id AS firefly_meeting_id,
    ff.organizer_email,
    ff.total_shakudo_talk_time,
    ff.total_non_shakudo_talk_time,
    ff.title,
    ec.contact_id,
    ec.createdat AS contact_created_date,
    ec.meeting_created_date as meeting_created_date,
    ec.meeting_start_time,
    ec.meeting_end_time,
    ec.meeting_id AS hubspot_meeting_id,
    ec.meeting_calendar_url,
    ec.owner_id,
    ec.owner_firstname,
    ec.hs_analytics_source,
    ec.hs_analytics_source_data_1,
    ec.hs_analytics_source_data_2,
    ec.deal_id,
    ec.dealname,
    ec.label,
    REGEXP_REPLACE(ec.meeting_title, '[^a-zA-Z0-9 ]', '') AS cleaned_meeting_title
FROM 
    yr_sub_views.performance_improve.ff_talk_improved AS ff
LEFT JOIN 
    hubspot_data.derived_views.enhanced_contacts AS ec
ON 
    ff.title = ec.meeting_title OR ff.title = cleaned_meeting_title
WHERE 
    ec.meeting_calendar_url IS NOT NULL 
    AND ec.meeting_id IS NOT NULL
ORDER BY meeting_start_time DESC
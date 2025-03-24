SELECT 
    id AS meeting_id,
    properties_hs_meeting_external_url AS meeting_calendar_url,
    m.properties_hs_meeting_start_time.member0 AS meeting_start_time,
    m.properties_hs_meeting_end_time.member0 AS meeting_end_time,
    properties_hs_meeting_title AS meeting_title,
    m.createdat.member0 AS meeting_created_date,
    FLATTEN(contacts) AS contact
FROM hubspot_data.engagements_meetings_deduped m
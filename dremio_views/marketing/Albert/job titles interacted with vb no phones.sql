SELECT   role_seniority,
         COUNT(contact_id)
FROM     "hubspot_data"."derived_views"."enhanced_contacts_v2" c
WHERE    c.hs_analytics_source_data_2 = 'vector databases blog' AND
         meeting_calendar_url IS NOT NULL
GROUP BY role_seniority
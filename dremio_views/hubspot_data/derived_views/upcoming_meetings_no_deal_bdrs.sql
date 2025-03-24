SELECT *
FROM   "hubspot_data"."derived_views"."upcoming_meetings_no_deal"
WHERE  owner_firstname not in (
         'Mark',
         'Yevgeniy',
         'Stella',
         'Hannah',
         'Christine') AND
       meeting_title not in ('Sales Training') AND
       meeting_start_time < DATE_ADD(CURRENT_DATE(), 14) AND
       company_id IS NOT NULL
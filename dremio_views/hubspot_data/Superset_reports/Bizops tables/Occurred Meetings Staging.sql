SELECT
title,
contact_ids,
SUM(total_non_shakudo_talk_time) AS total_non_shakudo_talk_time,
SUM(total_shakudo_talk_time) AS total_shakudo_talk_time,
meeting_start_time
FROM
"hubspot_data"."derived_views"."fireflies_hubspot_merged"
WHERE
title NOT IN ('Sales Training', 'Sales training [ Sat ]')
AND total_non_shakudo_talk_time > 0
AND organizer_email IN (
'abdul@shakudo.io',
'gabe@shakudo.io',
'aman@shakudo.io',
'jacob@shakudo.io',
'tuby@shakudo.io',
'ethan@shakudo.io',
'david@shakud.io',
'kenneth@shakudo.io')
GROUP BY
contact_ids,
title,
meeting_start_time
ORDER BY
meeting_start_time DESC

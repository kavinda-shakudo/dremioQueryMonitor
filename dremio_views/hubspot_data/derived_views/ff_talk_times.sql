SELECT id AS meeting_id,
       index as sentence_index,
       speaker_name,
       organizer_email,
       start_time,
       title,
       LAG(start_time) OVER(PARTITION BY id ORDER BY start_time) AS prev_start_time,
       COALESCE(start_time - LAG(start_time) OVER(PARTITION BY id ORDER BY start_time), 0) AS talk_time_seconds
FROM   "hubspot_data"."derived_views"."exploded_sentences_no_active_deals"
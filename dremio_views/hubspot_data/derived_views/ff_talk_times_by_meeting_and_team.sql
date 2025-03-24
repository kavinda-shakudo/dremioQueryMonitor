SELECT    meeting_id,
          title,
          organizer_email,
          ARRAY_AGG(DISTINCT ff_talk_times.speaker_name) AS shakudo_speakers,
          ARRAY_AGG(DISTINCT CASE WHEN shakudo_names.name IS NULL OR shakudo_names.name = '' THEN ff_talk_times.speaker_name ELSE NULL END) AS non_shakudo_speakers,
          SUM(CASE WHEN shakudo_names.name IS NOT NULL AND shakudo_names.name <> '' THEN talk_time_seconds ELSE 0 END) AS total_shakudo_talk_time,
          SUM(CASE WHEN shakudo_names.name IS NULL OR shakudo_names.name = '' THEN talk_time_seconds ELSE 0 END) AS total_non_shakudo_talk_time
FROM      derived_views.ff_talk_times
LEFT JOIN minio.generateddata.shakudo_names
ON        ff_talk_times.speaker_name = shakudo_names.name AND
          shakudo_names.name <> ''
WHERE     TRIM(ff_talk_times.speaker_name) <> ''
GROUP BY  meeting_id,
          title,
          organizer_email
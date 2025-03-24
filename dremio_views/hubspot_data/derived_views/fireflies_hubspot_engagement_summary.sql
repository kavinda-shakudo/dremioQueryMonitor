WITH shakudo_owners AS (
  SELECT LOWER(TRIM(firstName || ' ' || lastName)) AS owner_name
  FROM "hubspot_data".owners
),
raw_data AS (
  SELECT
    id,
    title,
    host_email,
    organizer_email,
    callDate,
    calendar_id,
    transcript_ts,
    start_time,
    speaker_name,
    LAG(start_time) OVER (PARTITION BY id ORDER BY start_time) AS prev_start_time
  FROM minio.generateddata."fireflies_raw_v2"
),
deltas AS (
  SELECT
    id,
    title,
    host_email,
    organizer_email,
    callDate,
    calendar_id,
    transcript_ts,
    start_time,
    speaker_name,
    CASE 
      WHEN prev_start_time IS NOT NULL THEN start_time - prev_start_time 
      ELSE 0
    END AS delta_time
  FROM raw_data
),
classified AS (
  SELECT
    id,
    title,
    host_email,
    organizer_email,
    callDate,
    calendar_id,
    transcript_ts,
    speaker_name,
    delta_time,
    LOWER(TRIM(speaker_name)) AS speaker_lower,
    CASE 
      WHEN LOWER(TRIM(speaker_name)) IN (SELECT owner_name FROM shakudo_owners)
      THEN delta_time
      ELSE 0
    END AS shakudo_talk_time,
    CASE 
      WHEN LOWER(TRIM(speaker_name)) NOT IN (SELECT owner_name FROM shakudo_owners)
      THEN delta_time
      ELSE 0
    END AS non_shakudo_talk_time
  FROM deltas
),
aggregated AS (
  SELECT
    id,
    MAX(title) AS title,
    MAX(host_email) AS host_email,
    MAX(organizer_email) AS organizer_email,
    MAX(callDate) AS callDate,
    MAX(calendar_id) AS calendar_id,
    MAX(transcript_ts) AS transcript_ts,
    SUM(shakudo_talk_time) AS shakudo_talk_time,
    SUM(non_shakudo_talk_time) AS non_shakudo_talk_time
  FROM classified
  GROUP BY id
)
SELECT
  a.id,
  a.title,
  a.host_email,
  a.organizer_email,
  CASE 
    WHEN own.teams[0].id = '38063404' THEN 'BDR'
    WHEN own.teams[0].id = '33963927' THEN 'Sales'
    ELSE own.teams[0].id
  END AS Team,
  a.calendar_id,
  a.transcript_ts,
  CAST(a.shakudo_talk_time AS INTEGER) AS shakudo_talk_time,
  CAST(a.non_shakudo_talk_time AS INTEGER) AS non_shakudo_talk_time,
  COALESCE(CAST(a.shakudo_talk_time AS INTEGER), 0) + COALESCE(CAST(a.non_shakudo_talk_time AS INTEGER), 0) AS total_talk_time,
  e.id AS engagement_id,
  e.properties_hubspot_owner_id,
  e.properties_hubspot_team_id,
  e.deals,
  e.contacts,
  e.companies,
  e.createdAt.member0 AS createdAt_member0,
  e.properties_hs_timestamp.member0 AS properties_hs_timestamp_member0,
  e.properties_hs_activity_type,
  e.properties_hs_meeting_external_url
FROM aggregated a
LEFT JOIN "hubspot_data".owners AS own 
    ON a.organizer_email = own.email
LEFT JOIN "hubspot_data"."engagements_meetings_deduped" AS e 
    ON a.calendar_id = e.properties_hs_unique_id
WHERE own.teams[0].id IN ('38063404','33963927')
ORDER BY a.id
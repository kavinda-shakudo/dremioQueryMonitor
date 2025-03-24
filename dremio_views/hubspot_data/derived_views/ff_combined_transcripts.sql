WITH ordered_transcripts AS (
    SELECT 
        id,
        title,
        host_email,
        organizer_email,
        privacy,
        callDate,
        transcript_url,
        calendar_id,
        CONCAT(speaker_name, ': ', text) AS speaker_name_and_text,
        start_time,
        duration,
        "index"
    FROM 
        minio.generateddata."fireflies_raw_v2"
    -- Order the rows based on 'id' and 'index'
    ORDER BY id, "index"
)
SELECT 
    id,
    title,
    host_email,
    organizer_email,
    privacy,
    callDate,
    transcript_url,
    calendar_id,
    LISTAGG(speaker_name_and_text, ' ') AS text,
    MIN(start_time) AS start_time,  -- Keeping the earliest start time
    SUM(duration) AS total_duration  -- Summing the duration for the entire conversation
FROM 
    ordered_transcripts
GROUP BY 
    id,
    title,
    host_email,
    organizer_email,
    privacy,
    callDate,
    transcript_url,
    calendar_id;


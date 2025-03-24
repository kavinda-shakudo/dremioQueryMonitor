SELECT *
FROM minio.generateddata."fireflies_raw_v2" es
LEFT JOIN "hubspot_data"."derived_views"."ff_active_deals" ad ON es.id = ad.transcript_id
WHERE ad.transcript_id IS NULL;

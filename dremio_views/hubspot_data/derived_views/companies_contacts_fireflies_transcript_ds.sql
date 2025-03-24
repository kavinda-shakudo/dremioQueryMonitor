SELECT hfn.companies,
       hfn.contacts,
       REGEXP_EXTRACT(hfn.properties_hs_note_body, '::([a-zA-Z0-9]+)', 1) AS transcript_id,
       REGEXP_EXTRACT(hfn.properties_hs_note_body, 'href="([^"]+)"', 1) AS full_url,
       hfn.properties_hs_note_body AS full_note,
       hfn.createdat.member0 as createdat
FROM   "hubspot_data"."derived_views"."hubspot_fireflies_notes" hfn
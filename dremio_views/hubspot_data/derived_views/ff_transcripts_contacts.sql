SELECT transcript_id,
    FLATTEN(cc.contacts) as contact_id,
    createdat
FROM "hubspot_data"."derived_views"."companies_contacts_fireflies_transcript_ds" cc
SELECT DISTINCT transcript_id
FROM            "hubspot_data"."derived_views"."ff_transcripts_contacts"
JOIN            "hubspot_data"."derived_views"."contacts_in_active_deals"
ON              "hubspot_data"."derived_views"."ff_transcripts_contacts".contact_id = "hubspot_data"."derived_views"."contacts_in_active_deals".contact_id AND
                ff_transcripts_contacts.createdat > contacts_in_active_deals.createdat.member0
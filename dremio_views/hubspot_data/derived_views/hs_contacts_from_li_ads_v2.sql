SELECT 
    sub.*,
    LEAST(sub.min_ec_createdat, sub.min_emc_createdat) AS first_touchpoint,
    DATEDIFF(sub.createdat, LEAST(sub.min_ec_createdat, sub.min_emc_createdat)) AS days_difference
FROM (
    SELECT 
        corrected_contacts.createdat.member0 AS createdat,
        corrected_contacts.properties_firstname,
        corrected_contacts.properties_lastname,
        corrected_contacts.properties_jobtitle,
        corrected_contacts.properties_company,
        corrected_contacts.properties_linkedin_profile_link,
        corrected_contacts.properties_hs_object_id,
        linkedin_ads_campaigns_considered.name AS li_as_campaign_name,
        MIN(ec.createdat) AS min_ec_createdat,
        MIN(emc.createdat) AS min_emc_createdat,
        corrected_contacts.properties_hubspot_owner_id AS owner_id,
        owners.firstname,
        corrected_contacts.properties_hs_lead_status,
        corrected_contacts.properties_lifecyclestage,
        COUNT(DISTINCT en.createdat) AS total_engagements,
        corrected_contacts.properties_hs_v2_date_entered_198298537.member0 AS date_entered_re_mql,
        corrected_contacts.properties_hs_v2_date_entered_marketingqualifiedlead.member0 AS date_entered_mql
        -- Assuming the columns function is used to extract certain fields. Replace with appropriate Dremio syntax if needed.
        -- columns('.*source.*')
    FROM 
        "hubspot_data"."contacts_deduped" corrected_contacts
    JOIN 
        minio.generateddata."linkedin_ads_campaigns_considered" linkedin_ads_campaigns_considered
    ON 
        LOWER(corrected_contacts.properties_hs_analytics_source_data_2) = LOWER(linkedin_ads_campaigns_considered.name)
    LEFT JOIN "hubspot_data".owners owners
    ON corrected_contacts.properties_hubspot_owner_id = owners.id
    LEFT JOIN LATERAL (
        SELECT ec.createdat.member0 as createdat
        FROM "hubspot_data"."engagements_calls_deduped" ec
        WHERE ec.contacts[0] = corrected_contacts.properties_hs_object_id
    ) ec ON true
    LEFT JOIN LATERAL (
        SELECT emc.createdat.member0 as createdat
        FROM "hubspot_data"."engagements_emails_deduped" emc
        WHERE emc.contacts[0] = corrected_contacts.properties_hs_object_id
    ) emc ON true
    LEFT JOIN LATERAL (
        SELECT en.createdat
        FROM "hubspot_data"."engagements_deduped" en
        WHERE en.associations_contactids[0] = corrected_contacts.properties_hs_object_id
    ) en ON true
    WHERE 
        corrected_contacts.properties_lead_source = 'Shakudo-internal-auto-contact-creation'
        OR corrected_contacts.properties_hs_analytics_source_data_2 != '2674917'
    GROUP BY 
        corrected_contacts.createdat.member0,
        corrected_contacts.properties_firstname,
        corrected_contacts.properties_lastname,
        corrected_contacts.properties_jobtitle,
        corrected_contacts.properties_company,
        corrected_contacts.properties_linkedin_profile_link,
        corrected_contacts.properties_hs_object_id,
        linkedin_ads_campaigns_considered.name,
        corrected_contacts.properties_hubspot_owner_id,
        owners.firstname,
        corrected_contacts.properties_hs_lead_status,
        corrected_contacts.properties_lifecyclestage,
        corrected_contacts.properties_hs_v2_date_entered_198298537.member0,
        corrected_contacts.properties_hs_v2_date_entered_marketingqualifiedlead.member0
        -- columns('.*source.*')
) AS sub
ORDER BY createdat DESC;

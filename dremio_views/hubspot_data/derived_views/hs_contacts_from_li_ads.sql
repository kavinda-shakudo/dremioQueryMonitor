SELECT 
    contacts.createdat.member0 AS createdat,
    contacts.properties_firstname,
    contacts.properties_lastname,
    contacts.properties_jobtitle,
    contacts.properties_company,
    contacts.properties_linkedin_profile_link,
    contacts.properties_hs_object_id,
    linkedin_ads_campaigns.name AS li_as_campaign_name
FROM 
    "hubspot_data"."contacts_deduped" contacts
JOIN 
    "hubspot_data"."linkedin_ads_campaigns" linkedin_ads_campaigns
ON 
    LOWER(contacts.properties_hs_analytics_source_data_2) = LOWER(linkedin_ads_campaigns.name)
WHERE 
    contacts.properties_linkedin_profile_link IS NOT NULL
GROUP BY 
    contacts.createdat.member0,
    contacts.properties_firstname,
    contacts.properties_lastname,
    contacts.properties_jobtitle,
    contacts.properties_company,
    contacts.properties_linkedin_profile_link,
    contacts.properties_hs_object_id,
    linkedin_ads_campaigns.name;
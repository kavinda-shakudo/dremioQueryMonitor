SELECT   *
FROM     "hubspot_data"."derived_views"."enhanced_contacts_v2"
WHERE    dealname IS NOT NULL AND
         LOWER(label) NOT LIKE '%lost%' AND
         LOWER(label) NOT LIKE '%churn%' AND 
         LOWER(label) NOT LIKE '%parking%'
ORDER BY state
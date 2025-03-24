SELECT DISTINCT company_id,
                company_name,
                dates_churned,
                dates_entered_trial,
                dates_won,
                earliest_trial,
                earliest_won,
                total_amount,
                contact_id,
                contact_firstname,
                contact_lastname,
                contact_createdat,
                hs_analytics_source,
                hs_analytics_source_data_1,
                hs_analytics_source_data_2
FROM            (SELECT    cdc.company_id,
                           cdc.company_name,
                           cdc.dates_churned,
                           cdc.dates_entered_trial,
                           cdc.dates_won,
                           cdc.earliest_trial,
                           cdc.earliest_won,
                           cdc.total_amount,
                           cdc.contact_id,
                           RANK() OVER(PARTITION BY cdc.company_id ORDER BY co.createdAt.member0 ASC) as contact_rank,
                           co.properties_firstname as contact_firstname,
                           co.properties_lastname as contact_lastname,
                           co.createdAt.member0 as contact_createdat,
                           co.properties_hs_analytics_source AS hs_analytics_source,
                           co.properties_hs_analytics_source_data_1 AS hs_analytics_source_data_1,
                           co.properties_hs_analytics_source_data_2 AS hs_analytics_source_data_2
                 FROM      (SELECT    cc.company_id,
                                      cc.company_name,
                                      cc.dates_churned,
                                      cc.dates_entered_trial,
                                      cc.dates_won,
                                      cc.earliest_trial,
                                      cc.earliest_won,
                                      cc.total_amount,
                                      FLATTEN(c.contacts) as contact_id
                            FROM      "hubspot_data".reports."all_live_deals" cc
                            LEFT JOIN companies_deduped c
                            ON        cc.company_id = c.id
                           ) cdc
                 LEFT JOIN contacts_deduped co
                 ON        co.id = cdc.contact_id)
WHERE           contact_rank = 1 AND
                hs_analytics_source NOT IN ('OFFLINE')
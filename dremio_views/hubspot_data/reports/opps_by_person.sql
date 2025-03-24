SELECT    deals.createdat.member0 as createdat,
          deals.properties_dealname as deal_name,
          ds.label as deal_stage,
          ds.pipeline_name,
          deals.properties_amount as deal_amount,
          deals.properties_amount_in_home_currency as deal_amount_usd,
          owners.firstname,
          owners.email as bdr_email,
          deals.properties_hs_date_entered_14960226.member0 as date_entered_disco1,
          deals.properties_hs_date_entered_appointmentscheduled.member0 as date_entered_disco2,
          deals.properties_hs_date_entered_qualifiedtobuy.member0 as date_entered_disco3,
          deals.properties_hs_date_entered_contractsent.member0 as date_entered_contracting,
          deals.properties_hs_date_entered_presentationscheduled.member0 as date_entered_trial,
          deals.properties_hs_date_entered_closedwon.member0 as date_entered_closedwon,
          deals.properties_hs_date_entered_closedlost.member0 as date_entered_closedlost
FROM      deals_deduped deals
LEFT JOIN deal_pipelines_deduped ds
ON        deals.properties_dealstage = ds.stageId
LEFT JOIN owners
ON        owners.userId = deals.properties_hs_created_by_user_id
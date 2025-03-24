CREATE OR REPLACE VIEW dremio.generated.task_view AS 
SELECT     nested_0.task_id AS task_id,
           nested_0.contacts AS contacts,
           join_id2name_contacts.properties_firstname AS contact_firstname,
           join_id2name_contacts.properties_lastname AS contact_lastname,
           nested_0.properties_hs_timestamp AS properties_hs_timestamp,
           nested_0.properties_hs_createdate AS properties_hs_createdate,
           nested_0.properties_hs_task_subject AS properties_hs_task_subject,
           nested_0.properties_hs_task_status AS properties_hs_task_status,
           nested_0.properties_hs_all_owner_ids AS properties_hs_all_owner_ids,
           nested_0.properties_hs_task_priority AS properties_hs_task_priority,
           nested_0.duedate AS duedate,
           nested_0.properties_hs_object_source_label AS properties_hs_object_source_label,
           nested_0.company AS company,
           join_id2name_companies.properties_name AS company_name
FROM       (SELECT id AS task_id,
                   LIST_TO_DELIMITED_STRING("t"."companies", ',') AS company,
                   LIST_TO_DELIMITED_STRING("t"."contacts", ',') AS contacts,
                   "t"."properties_hs_timestamp" [ 'member0' ] AS properties_hs_timestamp,
                   "t"."properties_hs_createdate" [ 'member0' ] AS properties_hs_createdate,
                   properties_hs_task_subject,
                   properties_hs_task_status,
                   properties_hs_all_owner_ids,
                   properties_hs_task_priority,
                   "t"."properties_hs_timestamp" [ 'member0' ] AS duedate,
                   properties_hs_object_source_label
            FROM   dremio.Airbyte.tasks AS t
            WHERE t.properties_hs_object_source_label = 'INTEGRATION'
                  AND t.properties_hs_task_subject LIKE '[BDR Outbound]%'
           ) nested_0
LEFT JOIN dremio.Airbyte.id2name_companies AS join_id2name_companies
ON         nested_0.company = join_id2name_companies.id
LEFT JOIN dremio.Airbyte.contacts AS join_id2name_contacts
ON         nested_0.contacts = join_id2name_contacts.id;
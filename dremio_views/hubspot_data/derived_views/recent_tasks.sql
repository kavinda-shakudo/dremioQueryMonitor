SELECT   id,
         t.createdAt.member0 as createdAt,
         FLATTEN(contacts) as contact_id,
         properties_hubspot_owner_id,
         properties_hs_task_subject,
         properties_hs_object_source,
         t."properties_hs_timestamp".member0 as due_date,
         "properties_hs_task_completion_date",
         "properties_hs_task_is_completed",
         "properties_hs_task_is_overdue",
         "properties_hs_task_is_past_due_date",
         "properties_hs_task_priority",
         "properties_hs_task_status"
FROM     hubspot_data.engagements_tasks_deduped t
ORDER BY createdAt DESC
SELECT    LISTAGG(em.id, ',') as meeting_ids,
          LISTAGG(properties_hs_meeting_title, ',') as meeting_titles,
          LISTAGG(em.properties_hs_meeting_start_time.member0, ',') as meeting_start_time,
          LISTAGG(o.email, ',') as owner_email,
          c.properties_name as company_name
FROM      hubspot_data.engagements_meetings_deduped em
LEFT JOIN hubspot_data.owners o
ON        em.properties_hubspot_owner_id = o.id
LEFT JOIN hubspot_data.companies_deduped c
ON        c.id = em.companies[0]
WHERE     DATE_TRUNC('day', em.createdAt.member0) = DATE_TRUNC('day', CURRENT_DATE())
GROUP BY  company_name;
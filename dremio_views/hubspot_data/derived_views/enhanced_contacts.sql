SELECT DISTINCT 
    c.contact_id,
    c.createdAt,
    m.meeting_id,
    m.meeting_calendar_url,
    c.firstname,
    c.lastname,
    c.jobtitle,
    c.company_id,
    co.company_name,
    c.owner_id,
    o.owner_firstname,
    o.owner_lastname,
    m.meeting_start_time,
    m.meeting_end_time,
    m.meeting_title,
    m.meeting_created_date,
    mq.hs_analytics_source,
    mq.hs_analytics_source_data_1,
    mq.hs_analytics_source_data_2,
    mq.lead_source,
    mq.lead_source_detail,
    mq.city,
    mq.state,
    d.deal_id,
    d.dealname,
    dp.label
FROM hubspot_data.temp_views.temp_contacts c
LEFT JOIN hubspot_data.temp_views.temp_companies co ON c.company_id = co.company_id
LEFT JOIN hubspot_data.temp_views.temp_owners o ON c.owner_id = o.owner_id
LEFT JOIN hubspot_data.temp_views.temp_meetings m ON m.contact = c.contact_id
LEFT JOIN hubspot_data.temp_views.temp_deals d ON d.contact = c.contact_id OR d.company = c.company_id
LEFT JOIN hubspot_data.temp_views.temp_deal_pipelines dp ON dp.dealstage = d.dealstage
LEFT JOIN hubspot_data.temp_views.temp_mqls mq ON mq.contact_id = c.contact_id;
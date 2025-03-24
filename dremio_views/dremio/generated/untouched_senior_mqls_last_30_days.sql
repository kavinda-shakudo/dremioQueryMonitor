CREATE TABLE minio.dremio.output.untouched_senior_mqls_last_30_days AS
SELECT 
    all_mqls.*,
    contacts.properties_jobtitle AS title,
    contacts.properties_numemployees AS num_employees_contacts,
    contacts.properties_notes_last_contacted.member0 AS last_contact,
    companies.properties_numberofemployees AS num_employees_companies,
    contacts.properties_role_seniority AS seniority
FROM 
    dremio.generated."all_mqls" as all_mqls
JOIN 
    dremio.Airbyte.contacts AS contacts 
    ON all_mqls.id = contacts.properties_hs_object_id
JOIN 
    dremio.Airbyte.companies AS companies 
    ON contacts.properties_associatedcompanyid = companies.properties_hs_object_id
WHERE 
    contacts.properties_notes_last_contacted.member0 < CURRENT_DATE - INTERVAL '1' MONTH
    AND contacts.properties_notes_last_contacted.member0 IS NOT NULL
    AND companies.properties_numberofemployees > 100
    AND contacts.properties_role_seniority IN ('L1 - C-Suite', 'L2 - Director/VP');

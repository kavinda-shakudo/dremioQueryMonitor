SELECT
    ce.contact_id,
    ce.email,
    sc.email as stripe_email,
    sc.id AS customer_id,
    ROW_NUMBER() OVER (
        PARTITION BY ce.email 
        ORDER BY sc.created DESC NULLS LAST
    ) AS customer_row
FROM "operations.billing-project"."ContactEmails" AS ce
LEFT JOIN minio.airbyte."stripe_customers" AS sc 
    ON LOWER(ce.email) = LOWER(sc.email)
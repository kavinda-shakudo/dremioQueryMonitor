SELECT CAST(txndate AS TIMESTAMP) as txndate,
    hometotalamt,
    docnumber,
    duedate,
    id,
    balance,
    customerref__name as customerref,
    CASE 
        WHEN billemail__address IS NULL AND customerref__name = 'Waste Vision, LLC' THEN 'barry@wastevision.ai'
        WHEN billemail__address IS NULL AND customerref__name = 'Shaksham Jaiswal' THEN 'famousfoxfederation@pm.me' 
        ELSE billemail__address 
    END as customer_email_address
FROM minio.generateddata.n8n.quickbooks."quickbooks_latest.json"
ORDER BY txndate DESC;

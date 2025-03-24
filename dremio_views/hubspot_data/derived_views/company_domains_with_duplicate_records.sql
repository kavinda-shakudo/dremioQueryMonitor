SELECT   *
FROM     (SELECT   properties_domain,
                   ARRAY_AGG(ALL id),
                   COUNT(DISTINCT id) as num_records
          FROM     hubspot_data.companies_deduped
          WHERE    properties_domain IS NOT NULL
          GROUP BY properties_domain)
WHERE    num_records > 1
ORDER BY properties_domain
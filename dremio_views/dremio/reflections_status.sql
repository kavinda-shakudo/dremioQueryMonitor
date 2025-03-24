SELECT 
    dataset_name,
    dataset_type,
    status,
    refresh_status,
    acceleration_status,
    updated_at,
    last_refresh_from_table
FROM (
    SELECT 
        dataset_name,
        dataset_type,
        status,
        refresh_status,
        acceleration_status,
        updated_at,
        last_refresh_from_table,
        ROW_NUMBER() OVER (PARTITION BY dataset_name ORDER BY last_refresh_from_table DESC) as rn
    FROM sys.reflections
) t
WHERE rn = 1
ORDER BY dataset_name
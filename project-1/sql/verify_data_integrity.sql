-- Check total record counts
SELECT 'dim_time' AS table_name, COUNT(*) FROM dim_time
UNION ALL
SELECT 'dim_region', COUNT(*) FROM dim_region
UNION ALL
SELECT 'dim_energy_source', COUNT(*) FROM dim_energy_source
UNION ALL
SELECT 'fact_grid_data', COUNT(*) FROM fact_grid_data;

-- Sample Join Query: Average hourly generation/load by country (in MW)
SELECT 
    r.region_name,
    s.source_name,
    ROUND(AVG(f.value_mw), 2) AS avg_mw
FROM fact_grid_data f
JOIN dim_region r ON f.region_id = r.region_id
JOIN dim_energy_source s ON f.source_id = s.source_id
GROUP BY r.region_name, s.source_name
ORDER BY r.region_name, avg_mw DESC;
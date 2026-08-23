-- ====================================================================
-- ANALYTICAL SQL PORTFOLIO QUERIES: OPSD ENERGY DATA
-- ====================================================================

-- 1. RENEWABLE VS. LOAD SUMMARY (Pivot/Aggregations)
-- Calculates total energy generated/consumed (in GWh) per country and source category.
SELECT 
    r.region_name,
    s.source_category,
    s.source_name,
    ROUND(SUM(f.value_mw) / 1000.0, 2) AS total_energy_gwh
FROM fact_grid_data f
JOIN dim_region r ON f.region_id = r.region_id
JOIN dim_energy_source s ON f.source_id = s.source_id
GROUP BY r.region_name, s.source_category, s.source_name
ORDER BY r.region_name, total_energy_gwh DESC;


-- 2. RENEWABLE PENETRATION RATE (%) BY COUNTRY
-- Uses conditional aggregation to compute renewable generation as a percentage of total grid load.
SELECT 
    r.region_name,
    ROUND(
        SUM(CASE WHEN s.is_renewable THEN f.value_mw ELSE 0 END) * 100.0 / 
        NULLIF(SUM(CASE WHEN f.source_id = 'load' THEN f.value_mw ELSE 0 END), 0), 2
    ) AS renewable_penetration_pct
FROM fact_grid_data f
JOIN dim_region r ON f.region_id = r.region_id
JOIN dim_energy_source s ON f.source_id = s.source_id
GROUP BY r.region_name
ORDER BY renewable_penetration_pct DESC;


-- 3. PEAK LOAD HOURS IDENTIFICATION (Window Functions: DENSE_RANK)
-- Ranks the top 3 peak electricity demand hours for each country per year.
WITH hourly_load AS (
    SELECT 
        r.region_name,
        t.year_val,
        t.date_val,
        t.hour_of_day,
        f.value_mw AS peak_load_mw,
        DENSE_RANK() OVER (
            PARTITION BY r.region_name, t.year_val 
            ORDER BY f.value_mw DESC
        ) AS rank_in_year
    FROM fact_grid_data f
    JOIN dim_region r ON f.region_id = r.region_id
    JOIN dim_time t ON f.time_id = t.time_id
    WHERE f.source_id = 'load'
)
SELECT 
    region_name,
    year_val,
    date_val,
    hour_of_day,
    peak_load_mw
FROM hourly_load
WHERE rank_in_year <= 3
ORDER BY region_name, year_val, rank_in_year;


-- 4. MONTH-OVER-MONTH (MoM) SOLAR GENERATION GROWTH (Window Functions: LAG)
-- Tracks Germany's monthly solar output and calculates percentage growth vs. previous month.
WITH monthly_solar AS (
    SELECT 
        t.year_val,
        t.month_val,
        t.month_name,
        ROUND(SUM(f.value_mw) / 1000.0, 2) AS solar_gwh
    FROM fact_grid_data f
    JOIN dim_time t ON f.time_id = t.time_id
    WHERE f.region_id = 'DE' AND f.source_id = 'solar'
    GROUP BY t.year_val, t.month_val, t.month_name
)
SELECT 
    year_val,
    month_name,
    solar_gwh,
    LAG(solar_gwh, 1) OVER (ORDER BY year_val, month_val) AS prev_month_gwh,
    ROUND(
        (solar_gwh - LAG(solar_gwh, 1) OVER (ORDER BY year_val, month_val)) * 100.0 / 
        NULLIF(LAG(solar_gwh, 1) OVER (ORDER BY year_val, month_val), 0), 2
    ) AS mom_growth_pct
FROM monthly_solar
ORDER BY year_val, month_val;


-- 5. AVERAGE DAILY LOAD PROFILE: WEEKDAY VS. WEEKEND
-- Compares hourly demand curves to analyze peak shifts between business days and weekends.
SELECT 
    r.region_name,
    t.hour_of_day,
    ROUND(AVG(CASE WHEN t.is_weekend = FALSE THEN f.value_mw END), 2) AS avg_weekday_mw,
    ROUND(AVG(CASE WHEN t.is_weekend = TRUE THEN f.value_mw END), 2) AS avg_weekend_mw
FROM fact_grid_data f
JOIN dim_region r ON f.region_id = r.region_id
JOIN dim_time t ON f.time_id = t.time_id
WHERE f.source_id = 'load'
GROUP BY r.region_name, t.hour_of_day
ORDER BY r.region_name, t.hour_of_day;
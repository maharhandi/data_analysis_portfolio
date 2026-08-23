-- ==============================================================================
-- PROJECT DATA CLEANING & REFINEMENT SCRIPT
-- Purpose: Clean orphaned records, map energy sources, and generate synthetic 
-- baseline generation records for comprehensive mix visualization in Power BI.
-- ==============================================================================

-- STEP 1: Eliminate Orphaned/Blank Records (Removes "(Vide)" from Slicers)
-- Power BI creates a default "(Vide)" blank option when fact records refer to a 
-- region_id/source_id/time_id that doesn't exist in the dimension table or contains NULL values.
DELETE FROM fact_grid_data 
WHERE region_id IS NULL 
   OR region_id NOT IN (SELECT region_id FROM dim_region);

DELETE FROM fact_grid_data 
WHERE source_id IS NULL 
   OR source_id NOT IN (SELECT source_id FROM dim_energy_source);

DELETE FROM fact_grid_data 
WHERE time_id IS NULL 
   OR time_id NOT IN (SELECT time_id FROM dim_time);

-- Clean up blank entry rows inside dimension tables if any exist
DELETE FROM dim_region WHERE region_id IS NULL OR country_code IS NULL;
DELETE FROM dim_energy_source WHERE source_id IS NULL OR source_name IS NULL;
DELETE FROM dim_time WHERE time_id IS NULL OR date_val IS NULL;

-- STEP 2: Register New Fuel Sources in the Dimension Table
-- Ensures foreign key integrity for non-renewable and additional generation sources 
-- (Hydro, Nuclear, Gas) so Power BI can categorize and label them correctly in visuals.
INSERT INTO dim_energy_source (source_id, source_name, source_category, is_renewable)
VALUES 
    ('hydro',   'Hydro Generation',  'Hydro',   true),
    ('nuclear', 'Nuclear Power',     'Thermal', false),
    ('gas',     'Fossil Gas',        'Thermal', false)
ON CONFLICT (source_id) DO NOTHING;


-- STEP 3: Populate Hydro Generation Baseline Data
-- Uses existing solar timestamps and region keys to derive proportional Hydro 
-- generation records, populating missing hydro metrics across all grid regions.
INSERT INTO fact_grid_data (time_id, region_id, source_id, value_mw)
SELECT 
    time_id, 
    region_id, 
    'hydro' AS source_id, 
    value_mw * 1.5 AS value_mw
FROM fact_grid_data 
WHERE source_id = 'solar'
ON CONFLICT DO NOTHING;


-- STEP 4: Populate Nuclear Power Baseline Data
-- Derives steady baseline nuclear production from existing wind profile timestamps
-- to model baseline nuclear output for phase-out and replacement analysis.
INSERT INTO fact_grid_data (time_id, region_id, source_id, value_mw)
SELECT 
    time_id, 
    region_id, 
    'nuclear' AS source_id, 
    value_mw * 0.9 AS value_mw
FROM fact_grid_data 
WHERE source_id = 'wind'
ON CONFLICT DO NOTHING;


-- STEP 5: Populate Fossil Gas Generation Baseline Data
-- Adds dispatchable peak-load gas production records to complete the energy mix, 
-- enabling comparisons between renewables, nuclear, and flexible fossil sources.
INSERT INTO fact_grid_data (time_id, region_id, source_id, value_mw)
SELECT 
    time_id, 
    region_id, 
    'gas' AS source_id, 
    value_mw * 0.4 AS value_mw
FROM fact_grid_data 
WHERE source_id = 'wind'
ON CONFLICT DO NOTHING;
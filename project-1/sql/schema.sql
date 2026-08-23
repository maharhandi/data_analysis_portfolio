-- Drop existing tables for idempotent execution
DROP TABLE IF EXISTS fact_grid_data CASCADE;
DROP TABLE IF EXISTS dim_region CASCADE;
DROP TABLE IF EXISTS dim_energy_source CASCADE;
DROP TABLE IF EXISTS dim_time CASCADE;

-- 1. Region Dimension
CREATE TABLE dim_region (
    region_id VARCHAR(10) PRIMARY KEY,
    country_code CHAR(2) NOT NULL,
    region_name VARCHAR(100) NOT NULL,
    time_zone VARCHAR(50) DEFAULT 'UTC'
);

-- 2. Energy Source Dimension
CREATE TABLE dim_energy_source (
    source_id VARCHAR(20) PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL,
    source_category VARCHAR(50) NOT NULL, -- 'Renewable', 'Conventional', 'Market', 'Load'
    is_renewable BOOLEAN NOT NULL
);

-- 3. Time Dimension (Generated or Populated)
CREATE TABLE dim_time (
    time_id TIMESTAMP PRIMARY KEY,
    date_val DATE NOT NULL,
    year_val INT NOT NULL,
    month_val INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    day_of_week INT NOT NULL,
    day_name VARCHAR(15) NOT NULL,
    hour_of_day INT NOT NULL,
    quarter_val INT NOT NULL,
    is_weekend BOOLEAN NOT NULL
);

-- 4. Central Grid Fact Table (Hourly resolution)
CREATE TABLE fact_grid_data (
    fact_id BIGSERIAL PRIMARY KEY,
    time_id TIMESTAMP NOT NULL REFERENCES dim_time(time_id),
    region_id VARCHAR(10) NOT NULL REFERENCES dim_region(region_id),
    source_id VARCHAR(20) NOT NULL REFERENCES dim_energy_source(source_id),
    value_mw DECIMAL(12,2),
    price_eur_mwh DECIMAL(8,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Composite unique constraint to prevent duplicate ingestion entries
    CONSTRAINT uq_time_region_source UNIQUE (time_id, region_id, source_id)
);

-- Seed Energy Sources
INSERT INTO dim_energy_source (source_id, source_name, source_category, is_renewable) VALUES
('load', 'Grid Electricity Load', 'Load', false),
('solar', 'Solar Photovoltaic', 'Renewable', true),
('wind', 'Wind Generation', 'Renewable', true),
('hydro', 'Hydro Generation', 'Renewable', true),
('nuclear', 'Nuclear Generation', 'Conventional', false),
('gas', 'Gas Generation', 'Conventional', false),
('coal', 'Coal Generation', 'Conventional', false),
('price', 'Day-Ahead Price', 'Market', false)
ON CONFLICT (source_id) DO NOTHING;

-- Seed Common OPSD Regions (Lowercase to match cleaning.py)
INSERT INTO dim_region (region_id, country_code, region_name) VALUES
('at', 'AT', 'Austria'),
('be', 'BE', 'Belgium'),
('ch', 'CH', 'Switzerland'),
('de', 'DE', 'Germany'),
('fr', 'FR', 'France'),
('nl', 'NL', 'Netherlands')
ON CONFLICT (region_id) DO NOTHING;

-- B-Tree Performance Indexes for Dashboard Queries
CREATE INDEX idx_fact_grid_time ON fact_grid_data(time_id);
CREATE INDEX idx_fact_grid_region ON fact_grid_data(region_id);
CREATE INDEX idx_fact_grid_source ON fact_grid_data(source_id);
CREATE INDEX idx_fact_composite ON fact_grid_data(region_id, source_id, time_id);
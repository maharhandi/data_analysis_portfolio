import os
import pandas as pd
from sqlalchemy import create_engine

# ==========================================
# 1. CONFIGURATION & PATHS
# ==========================================
RAW_DATA_URL = "https://data.open-power-system-data.org/time_series/2020-10-06/time_series_60min_singleindex.csv" # change the datset url here 
CLEAN_DATA_PATH = "/Users/*****/cleaned_energy_data.csv" # path in your pc

DB_USER = "postgres"
DB_PASS = "******" # put you postgres password here
DB_HOST = "localhost"
DB_PORT = "******" # put you postgres password here
DB_NAME = "energy_db"

# ==========================================
# 2. LOAD RAW DATA
# ==========================================
print("🚀 Loading raw wide dataset...")
df_raw = pd.read_csv(RAW_DATA_URL, low_memory=False)

# Identify timestamp column
time_col = "utc_timestamp" if "utc_timestamp" in df_raw.columns else "timestamp"
df_raw.rename(columns={time_col: "time_id"}, inplace=True)
df_raw["time_id"] = pd.to_datetime(df_raw["time_id"], errors="coerce")

# ==========================================
# 3. UNPIVOT (MELT) WIDE COLUMNS INTO STAR SCHEMA
# ==========================================
print("🔄 Unpivoting OPSD columns into normalized schema...")

# Filter value columns (e.g., 'at_solar_generation_actual', 'de_price_day_ahead')
value_cols = [c for c in df_raw.columns if c not in ["time_id", "cet_cest_timestamp"]]

# Melt wide dataframe into long dataframe
df_long = pd.melt(
    df_raw,
    id_vars=["time_id"],
    value_vars=value_cols,
    var_name="raw_metric",
    value_name="raw_value"
).dropna(subset=["time_id", "raw_value"])

# Extract region_id (first 2 characters, e.g., 'at', 'be', 'de')
df_long["region_id"] = df_long["raw_metric"].str.slice(0, 2).str.upper()

# Map raw metrics to clean source_id and separate values vs prices
def classify_metric(metric_name):
    m = metric_name.lower()
    if "price" in m:
        return "price"
    elif "solar" in m:
        return "solar"
    elif "wind" in m:
        return "wind"
    elif "hydro" in m or "water" in m:
        return "hydro"
    elif "nuclear" in m:
        return "nuclear"
    elif "gas" in m or "fossil_gas" in m:
        return "gas"
    elif "coal" in m or "lignite" in m or "fossil" in m:
        return "coal"
    elif "load" in m:
        return "load"
    return "other"

df_long["source_id"] = df_long["raw_metric"].apply(classify_metric)

# Separate MW generation/load values from Market Price (€/MWh)
df_long["value_mw"] = df_long.apply(lambda r: r["raw_value"] if r["source_id"] != "price" else None, axis=1)
df_long["price_eur_mwh"] = df_long.apply(lambda r: r["raw_value"] if r["source_id"] == "price" else None, axis=1)

# Clean final schema structure
fact_grid_data = df_long[["time_id", "region_id", "source_id", "value_mw", "price_eur_mwh"]].copy()

# Ensure lowercase keys matching dimension tables
fact_grid_data["region_id"] = fact_grid_data["region_id"].str.lower()
fact_grid_data["source_id"] = fact_grid_data["source_id"].str.lower()

# ==========================================
# 4. SAVE & RELOAD POSTGRESQL
# ==========================================
os.makedirs(os.path.dirname(CLEAN_DATA_PATH), exist_ok=True)
fact_grid_data.to_csv(CLEAN_DATA_PATH, index=False)
print(f"💾 Saved clean melted dataset to: {CLEAN_DATA_PATH}")

print("🐘 Overwriting PostgreSQL 'fact_grid_data'...")
engine = create_engine(f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")
fact_grid_data.to_sql("fact_grid_data", engine, if_exists="replace", index=False)
print("✅ Unpivoted star-schema facts successfully reloaded into PostgreSQL!")
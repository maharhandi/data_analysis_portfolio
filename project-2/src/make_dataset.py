import os
import pandas as pd

def process_cmapss_data(raw_dir="***/data_analysis_portfolio/project-2/data/raw", processed_dir="***/data_analysis_portfolio/project-2/data/processed"):
    """Loads raw C-MAPSS FD001 text files, assigns feature names, computes RUL,

    drops zero-variance flatline sensors, and exports clean CSVs.
    """
    os.makedirs(processed_dir, exist_ok=True)

    # 1. Define Column Names based on Feature Dictionary
    index_cols = ["unit_nr", "time_cycles"]
    setting_cols = ["setting_1", "setting_2", "setting_3"]
    sensor_cols = [f"s_{i}" for i in range(1, 22)]
    all_cols = index_cols + setting_cols + sensor_cols

    # Flatline zero-variance sensors identified in EDA
    flatline_sensors = ["s_1", "s_5", "s_6", "s_10", "s_16", "s_18", "s_19"]

    # 2. Process Training Set
    train_path = os.path.join(raw_dir, "train_FD001.txt")
    if not os.path.exists(train_path):
        train_path = os.path.join(raw_dir, "train_FD001.txt")

    train_df = pd.read_csv(train_path, sep=r"\s+", header=None, names=all_cols)

    # Calculate Target Variable (RUL) for Training Data
    # Maximum flight cycle reached per unit represents engine failure point
    max_cycles = (
        train_df.groupby("unit_nr")["time_cycles"]
        .max()
        .reset_index()
        .rename(columns={"time_cycles": "max_cycles"})
    )

    train_df = train_df.merge(max_cycles, on="unit_nr", how="left")
    train_df["RUL"] = train_df["max_cycles"] - train_df["time_cycles"]
    train_df.drop(columns=["max_cycles"], inplace=True)

    # Drop flatline sensors
    train_cleaned = train_df.drop(columns=flatline_sensors)

    # 3. Process Test Set & Load RUL Ground Truth
    test_path = os.path.join(raw_dir, "test_FD001.txt")
    rul_path = os.path.join(raw_dir, "RUL_FD001.txt")

    test_df = pd.read_csv(test_path, sep=r"\s+", header=None, names=all_cols)
    rul_df = pd.read_csv(rul_path, header=None, names=["RUL_end"])
    rul_df["unit_nr"] = rul_df.index + 1

    # Calculate exact RUL at each operational time step for test set
    test_max = (
        test_df.groupby("unit_nr")["time_cycles"]
        .max()
        .reset_index()
        .rename(columns={"time_cycles": "max_observed_cycles"})
    )

    test_df = test_df.merge(test_max, on="unit_nr", how="left")
    test_df = test_df.merge(rul_df, on="unit_nr", how="left")

    # True total life = max observed cycles in test set + remaining cycles in RUL ground truth file
    test_df["RUL"] = (
        test_df["max_observed_cycles"]
        + test_df["RUL_end"]
        - test_df["time_cycles"]
    )
    test_df.drop(columns=["max_observed_cycles", "RUL_end"], inplace=True)

    # Drop flatline sensors from test set
    test_cleaned = test_df.drop(columns=flatline_sensors)

    # 4. Save Processed Datasets
    train_out = os.path.join(processed_dir, "train_cleaned.csv")
    test_out = os.path.join(processed_dir, "test_cleaned.csv")
    full_out = os.path.join(processed_dir, "cmapss_cleaned.csv")

    train_cleaned.to_csv(train_out, index=False)
    test_cleaned.to_csv(test_out, index=False)
    train_cleaned.to_csv(
        full_out, index=False
    )  # Default target for EDA notebooks

    print(
        f"Data Pipeline Executed Successfully:\n"
        f" - Cleaned Train Set Saved: {train_out} ({train_cleaned.shape})\n"
        f" - Cleaned Test Set Saved:  {test_out} ({test_cleaned.shape})\n"
        f" - Retained Features: {list(train_cleaned.columns)}"
    )


if __name__ == "__main__":
    process_cmapss_data()
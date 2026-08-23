# ✈️ Industrial Turbofan Predictive Maintenance & RUL Optimization

## 📊 Executive Overview

This is an end-to-end **predictive maintenance and machine learning solution** built using NASA's **C-MAPSS (Commercial Modular Aero-Propulsion System Simulation)** turbofan engine telemetry dataset (FD001).

By combining **thermodynamic sensor degradation analysis**, **group-aware machine learning**, temporal feature engineering, and **business cost modeling**, this project forecasts **Remaining Useful Life (RUL)** and identifies an optimal maintenance intervention threshold to minimize fleet operational expenditure.

---

## 🎯 Executive Summary — SCIP Framework

### 📍 Situation

Sensor telemetry from **100 turbofan engine units** across **20,631 operational cycles** was analyzed to track progressive mechanical degradation, covering key parameters:

- High-Pressure Compressor (HPC) Outlet Static Pressure ($P_{s30}$)
- Low-Pressure Turbine (LPT) Outlet Temperature ($T_{50}$)
- Corrected Core Speed ($NR_c$) and Fuel Flow Ratio ($\phi$)


### ⚠️ Constraint

Fleet operators face a strict dual-cost trade-off between premature servicing and catastrophic failure:

| Cost Component | Operational Impact | Cost Value |
|---|---|---:|
| 🚨 **Unplanned Failure Penalty** ($C_{\text{unplanned}}$) | In-flight failure, grounding & safety risk | **$50,000 / event** |
| 🔧 **Scheduled Overhaul Cost** ($C_{\text{preventive}}$) | Fixed standard shop visit & replacement | **$5,000 / maintenance** |
| ⏱️ **Premature Maintenance Waste** ($C_{\text{waste}}$) | Discarded remaining component life | **$50 / unused cycle** |


### 💥 Impact

Pure ML performance metrics (RMSE) do not account for financial exposure. Arbitrary maintenance intervals lead to either excessive premature parts replacement or high-risk unscheduled in-flight groundings.

### 🚀 Path Forward

A **LightGBM Regressor** was deployed using 5-cycle rolling temporal features and grouped cross-validation, integrated directly with a business cost-curve simulation.

> 💡 **Optimal Decision Rule:** Trigger maintenance when predicted **$\text{RUL} \le 10$ cycles**.  
> 💰 **Financial Impact:** Reduces total fleet operational expenditure to **$543.6K** while eliminating unscheduled in-flight failures.


---

# 📈 Key Results & Figures

| Metric / Artifact | Result |
|---|---|
| **Best Model** | LightGBM Regressor |
| **Validation Strategy** | GroupKFold Cross-Validation |
| **Validation RMSE** | **16.2 cycles** |
| **Optimal Maintenance Threshold** | **RUL ≤ 10 cycles** |
| **Minimum Fleet Expenditure** | **$543,600** |
| **Emergency Failures** | **0 under optimized policy** |
| **Primary Risk Drivers** | Corrected Core Speed ($NR_{c}$), Bleed Enthalpy ($s_{17}$), HPC Outlet Pressure ($P_{s30}$) |

---

## 🔬 End-to-End Analytical Pipeline

```text
NASA C-MAPSS Telemetry Ingestion
        ↓
Operational Settings & Variance Filtering (Drop s_1, s_5, s_10, s_16, s_18, s_19)
        ↓
Piece-wise RUL Target Capping (RUL = min(RUL, 125))
        ↓
Exploratory Data Analysis & VIF Collinearity Checks
        ↓
5-Cycle Rolling Feature Engineering (Mean & Standard Deviation)
        ↓
GroupKFold Cross-Validation (Unit-Aware Leakage Prevention)
        ↓
Model Benchmarking (Ridge vs XGBoost vs LightGBM)
        ↓
Out-of-Fold RUL Predictions
        ↓
Financial Exposure Cost Matrix Simulation
        ↓
Operational Threshold Optimization (RUL ≤ 10)

```

---

# 🧠 Machine Learning Methodology

### Target Transformation
To account for early-life engine stability where degradation is negligible, a piece-wise linear target cap is applied:
$$\text{RUL}_{\text{target}} = \min(\text{Actual RUL}, 125)$$

### Feature Engineering
- **Temporal Windows:** 5-cycle rolling mean and standard deviation to capture degradation trend acceleration and signal variance.
- **Multicollinearity Control:** Variance Inflation Factor (VIF) and Pearson correlation filtering to eliminate redundant telemetry channels.

### Model Evaluation & Validation
- **Engine-Aware Validation:** Standard k-fold leaks temporal profiles. Validation is strictly conducted using `GroupKFold` on `unit_nr`.
- **Architectures Evaluated:** Ridge Regression, XGBoost, and LightGBM.

---

# 💰 Operational Cost Optimization

Model predictions are translated into financial decisions via cost-curve evaluation across thresholds $5 \le \text{Threshold} \le 50$ cycles:

$$\text{Total Cost} = \sum C_{\text{preventive}} + \sum C_{\text{waste}} \times (\text{Actual RUL} - \text{Threshold}) + \sum C_{\text{unplanned}}$$

### 🏆 Results
The minimum of the cost curve occurs at **$\text{RUL} \le 10$ cycles**, yielding **$543,600** total fleet cost.

---

# 🔎 Primary Degradation Indicators

Decision-split analysis highlights three dominant thermodynamic drivers of engine wear:
1. **Corrected Core Speed (`NR_c`)** — Primary indicator of rotational mechanical resistance.
2. **Bleed Enthalpy (`s_17`)** — Key marker of thermal efficiency loss.
3. **HPC Outlet Static Pressure (`P_s30`)** — Primary metric for compressor aerodynamic degradation.

---

# 📊 Visual Artifacts

All high-resolution figures are generated and stored in `reports/figures/`:

| Figure | Description |
|---|---|
| `degradation_curves.png` | Single-unit thermodynamic sensor degradation trajectories prior to failure |
| `degradation_trajectories.png` | Fleet-wide telemetry drift trajectories relative to ground truth RUL |
| `sensor_drift_correlations.png` | Pearson correlation matrix mapping telemetry features against target RUL |
| `rul_prediction_trajectory.png` | LightGBM predicted RUL trajectory vs. ground truth for Engine Unit #10 |
| `feature_importance.png` | Top 15 physical sensor indicators ranked by decision split counts |
| `operational_cost_impact.png` | Operational cost minimization curve balancing failure risk vs. replacement waste |

---

# 📁 Project Structure

```text
project-2-predictive-maintenance/
│
├── data/
│   ├── raw/
│   │   ├── train_FD001.txt
│   │   ├── test_FD001.txt
│   │   └── RUL_FD001.txt
│   │
│   └── processed/
│       ├── cmapss_cleaned.csv
│       ├── cmapss_engineered.csv
│       ├── test_cleaned.csv
│       ├── train_cleaned.csv
│       └── feature_dictionary.md
│
├── notebooks/
│   ├── 01_data_acquisition_cleaning.ipynb
│   ├── 02_exploratory_data_analysis.ipynb
│   ├── 03_rul_modeling.ipynb
│   └── 04_operational_thresholds.ipynb
│
├── reports/
│   ├── Predictive_Maintenance_Executive_Report.pdf
│   │
│   └── figures/
│       ├── degradation_curves.png
│       ├── degradation_trajectories.png
│       ├── sensor_drift_correlations.png
│       ├── rul_prediction_trajectory.png
│       ├── feature_importance.png
│       └── operational_cost_impact.png
│
├── requirements.txt
└── README.md
```

---

# 🛠️ Technology Stack

| Category | Technologies |
|---|---|
| **Language** | Python |
| **Data Processing** | Pandas, NumPy |
| **Scientific Computing** | SciPy |
| **Machine Learning** | Scikit-learn |
| **Gradient Boosting** | LightGBM, XGBoost |
| **Statistics** | Pearson Correlation, VIF |
| **Feature Engineering** | Rolling Statistics, Normalization |
| **Validation** | GroupKFold Cross-Validation |
| **Visualization** | Matplotlib, Seaborn |
| **Data Source** | NASA C-MAPSS |
| **Domain** | Aerospace / Predictive Maintenance |

---

## 📌 Project Objective

This project demonstrates an end-to-end approach to **industrial predictive maintenance**, combining:

**Engineering Domain Knowledge + Scientific Data Analysis + Machine Learning + Business Cost Modeling**

The ultimate objective is to transform complex turbofan telemetry into **actionable maintenance decisions that reduce operational risk and cost**.
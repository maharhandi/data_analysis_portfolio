# 🌍 Global $\text{CO}_2$ Emissions & Planetary Surface Temperature Trajectories (1880–2024)

## 📊 Executive Overview

This repository contains an end-to-end **empirical climate telemetry analysis and statistical modeling system** evaluating global surface temperature anomalies and industrial greenhouse gas emissions over a continuous **145-year historical horizon (1880–2024)**.

By combining **NASA GISTEMP v4 land-ocean thermal records**, **Our World in Data (OWID) industrial emissions**, non-parametric hypothesis testing, rolling correlation dynamics, and **machine learning anomaly detection**, this project quantifies the structural acceleration of anthropogenic climate drift.

---

## 🎯 Executive Summary — SCIP Framework

### 📍 Situation

Global surface temperature anomalies measured relative to the standard 1951–1980 baseline ($0.00\ ^\circ\text{C}$) were combined with global fossil fuel combustion, population growth, GDP, and primary energy consumption records across 145 continuous observation years (1880–2024).

### ⚠️ Constraint

Climate analysis must separate natural inter-annual variability (volcanic cooling, El Niño/La Niña oscillations) from non-random, long-term systematic trends without assuming underlying linear Gaussian distribution profiles.

### 💥 Impact

Unquantified climate drift introduces severe systemic operational and macroeconomic risks. Evaluating planetary thermal trajectories without testing for **structural regime shifts** underestimates modern warming acceleration rates.

### 🚀 Path Forward

Applied non-parametric **Mann-Kendall trend tests**, **Sen's slope estimation**, **OLS regression**, **20-year rolling Pearson correlations**, and an **Isolation Forest** machine learning model to isolate climate outliers and verify trend acceleration.

> 💡 **Key Conclusion:** Non-parametric testing confirms a statistically significant upward trend ($Z = 16.892, p < 10^{-15}$). Modern warming post-1975 ($0.204\ ^\circ\text{C}/\text{decade}$) has accelerated **$5.5\times$ faster** than the pre-1975 historical baseline ($0.037\ ^\circ\text{C}/\text{decade}$).

---

# 📈 Key Scientific Results

| Metric / Feature | Pre-1975 | Post-1975 | Full Range (1880–2024) |
|---|:---:|:---:|:---:|
| **Mann-Kendall Trend ($Z$)** | $5.120$ | $10.432$ | **$16.892$** ($p < 10^{-15}$) |
| **Warming Rate (Sen's Slope)** | $0.037\ ^\circ\text{C}/\text{dec}$ | $0.204\ ^\circ\text{C}/\text{dec}$ | **$0.071\ ^\circ\text{C}/\text{dec}$** |
| **Emissions Coupling ($R^2$)** | $0.342$ | $0.885$ | **$0.873$** |
| **Energy Correlation ($r$)** | — | — | **$0.94$** |
| **Population Correlation ($r$)** | — | — | **$0.93$** |

---

## 🔬 End-to-End Analytical Pipeline

```text
Raw Data Ingestion (NOAA Global Temp & OWID CO2 Telemetry)
        ↓
Data Acquisition, Cleaning & Baseline Normalization (1951–1980 Baseline = 0.00°C)
        ↓
Exploratory Statistical Analysis & Seasonal Decomposition
        ↓
Non-Parametric Mann-Kendall Trend Testing & Sen's Slope Estimation
        ↓
OLS Linear Regression & Energy Source Mix Analysis
        ↓
Multi-Variable Correlation Matrix (CO2, Temp, Population, GDP, Energy)
        ↓
Isolation Forest Anomaly Detection & Regime Shift Acceleration Modeling
```

---

# 🧠 Statistical & Machine Learning Methodology

### Non-Parametric Hypothesis Testing
To test for monotonic trends without assuming normality, the Mann-Kendall statistic $S$ is computed:
$$S = \sum_{k=1}^{N-1} \sum_{j=k+1}^{N} \text{sgn}(x_j - x_k)$$

Median annual warming velocity is quantified using **Sen's Slope Estimator**:
$$\beta_{\text{Sen}} = \text{median}\left( \frac{x_j - x_k}{j - k} \right) \quad \forall \, k < j$$

### Temporal Dynamics & Outlier Detection
* **Rolling Correlations & Decomposition:** Captures time-varying coupling dynamics between energy sources, emissions, and land-ocean temperature anomalies.
* **Isolation Forest:** Tree-based unsupervised machine learning isolated short-term extreme meteorological perturbations from the multi-decadal baseline trend.

---

# 📊 Visual Artifacts

All high-resolution figures are generated during analysis and stored in `reports/figures/`:

| Figure | File Name | Description |
|---|---|---|
| **Fig 1** | `fig1_global_temp_anomaly.png` | Global land-ocean surface temperature anomalies with 10-year moving average |
| **Fig 2** | `fig2_co2_emissions_trajectory.png` | Historical $\text{CO}_2$ emissions trajectories across key global economic regions |
| **Fig 3** | `fig3_seasonal_decomposition.png` | Seasonal trend decomposition isolating long-term drift from annual cycles |
| **Fig 4** | `fig4_mann_kendall_trend.png` | Mann-Kendall trend statistic visualization and Sen's slope regression trajectory |
| **Fig 5** | `fig5_energy_source_mix.png` | Global primary energy consumption mix breakdown over time |
| **Fig 6** | `fig6_correlation_matrix.png` | Correlation heatmap of emissions, temperature, population, GDP, and energy |
| **Fig 7** | `fig7_regime_shift_acceleration.png` | Pre-1975 vs Post-1975 linear trend comparison demonstrating warming acceleration |

---

# 📁 Project Structure

```text
project-3/
│
├── notebooks/
│   ├── 01_data_acquisition_cleaning.ipynb
│   ├── 02_exploratory_statistical_analysis.ipynb
│   └── 03_trend_and_anomaly_detection.ipynb
│
├── reports/
│   ├── Climate_Energy_Research_Report.tex
│   ├── Climate_Energy_Research_Report.pdf
│   │
│   └── figures/
│       ├── fig1_global_temp_anomaly.png
│       ├── fig2_co2_emissions_trajectory.png
│       ├── fig3_seasonal_decomposition.png
│       ├── fig4_mann_kendall_trend.png
│       ├── fig5_energy_source_mix.png
│       ├── fig6_correlation_matrix.png
│       └── fig7_regime_shift_acceleration.png
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
| **Scientific & Stats** | SciPy, Statsmodels |
| **Machine Learning** | Scikit-learn (Isolation Forest) |
| **Visualization** | Matplotlib, Seaborn |
| **Typesetting** | LaTeX, pdfTeX |
| **Data Sources** | NOAA, Our World in Data (OWID) |
| **Domain** | Climate Analytics / Environmental Data Science |

---

## 📌 Project Objective

This project demonstrates an end-to-end scientific workflow combining:

**Climate Telemetry Ingestion + Non-Parametric Statistics + Unsupervised Machine Learning + LaTeX Document Publishing**

The ultimate objective is to provide an empirical, reproducible framework for analyzing global thermal dynamics and environmental indicators.

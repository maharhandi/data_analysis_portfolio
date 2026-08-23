# 📘 NASA C-MAPSS FD001 Feature Dictionary & Master Glossary

## 📌 Dataset Overview
* **Dataset Name:** C-MAPSS Turbofan Engine Degradation Simulation (FD001)
* **Operational Conditions:** 1 (Sea Level Baseline)
* **Fault Modes:** High-Pressure Compressor (HPC) Degradation
* **Engine Fleet Size:** 100 Run-to-Failure Units
* **Primary Dataset Source:** [NASA Prognostics Data Repository - C-MAPSS Dataset](https://data.nasa.gov/dataset/cmapss-jet-engine-simulated-data)
* **Primary Academic Publication:** [Saxena et al., 2008 / NASA NTRS PDF Citation](https://ntrs.nasa.gov/api/citations/20090029214/downloads/20090029214.pdf)
---

## 🖼️ Engine Architecture & Sensor Placement


<div align="center">
  <img src="https://www.researchgate.net/profile/Soumik-Sarkar-4/publication/270759372/figure/fig2/AS:669164704387072@1536552706002/Schematic-diagram-of-the-C-MAPSS-engine-model-with-sensors-LPC-low-pressure-compressor_W640.jpg" alt="C-MAPSS Sensor Diagram" width="80%">
  <p><em>Figure 1: Schematic diagram of the C-MAPSS engine model detailing station locations and sensor placements (T2, T24, T30, T50, P30, Ps30, etc.).</em></p>
</div>

* **Source Article:** *Multi-sensor Information Fusion for Fault Detection in Aircraft Gas Turbine Engines*
* **Publication DOI:** [10.1177/0954410012468391](https://doi.org/10.1177/0954410012468391)

---
## 📖 Master Acronym & Notation Glossary

### 1. Subsystem & Component Acronyms
| Acronym | Full Name / Subsystem | Engineering Description |
|---|---|---|
| **LPC** | Low-Pressure Compressor | First compression stage driven by the LPT shaft |
| **HPC** | High-Pressure Compressor | Core compression stage prior to the combustion chamber |
| **LPT** | Low-Pressure Turbine | Turbine stage driving the front fan and LPC |
| **HPT** | High-Pressure Turbine | Turbine stage driving the core HPC shaft |
| **TRA** | Throttle Lever Angle | Pilot thrust command setting |
| **EPR** | Engine Pressure Ratio | Overall total pressure ratio across turbine/inlet ($P_{50}/P_2$) |
| **BPR** | Bypass Ratio | Mass flow ratio of bypass air vs. engine core air |
| **BTU** | British Thermal Unit | Imperial unit of thermal energy |

---

### 2. Physical Sensor Variables & Station Codes
| Acronym | Technical Designation | Physical Description | Native / SI Units |
|---|---|---|---|
| **T2** | Inlet Total Temp. | Total air temperature at fan intake (`s_1`) | $^\circ\text{R}$ / $\text{K}$ |
| **T24** | LPC Outlet Temp. | Total temperature after LPC compression (`s_2`) | $^\circ\text{R}$ / $\text{K}$ |
| **T30** | HPC Outlet Temp. | Total temperature after HPC compression (`s_3`) | $^\circ\text{R}$ / $\text{K}$ |
| **T50** | LPT Outlet Temp. | Total temperature after LPT expansion (`s_4`) | $^\circ\text{R}$ / $\text{K}$ |
| **P2** | Fan Inlet Pressure | Total air pressure at intake (`s_5`) | $\text{psia}$ / $\text{bar}$ |
| **P15** | Bypass Duct Pressure | Total pressure in outer fan bypass duct (`s_6`) | $\text{psia}$ / $\text{bar}$ |
| **P30** | HPC Outlet Total Press. | Total pressure at combustion inlet (`s_7`) | $\text{psia}$ / $\text{bar}$ |
| **Nf** | Physical Fan Speed | Rotational speed of low-pressure spool (`s_8`) | $\text{rpm}$ |
| **Nc** | Physical Core Speed | Rotational speed of high-pressure spool (`s_9`) | $\text{rpm}$ |
| **Ps30** | HPC Outlet Static Press. | Static air pressure at HPC discharge (`s_11`) | $\text{psia}$ / $\text{bar}$ |
| **phi** | Fuel Flow Ratio | Ratio of burner fuel flow to $P_{s30}$ (`s_12`) | $\text{pps/psia}$ |
| **NRf** | Corrected Fan Speed | Fan speed corrected for inlet ambient temp (`s_13`) | $\text{rpm}$ |
| **NRc** | Corrected Core Speed | Core speed corrected for inlet ambient temp (`s_14`) | $\text{rpm}$ |

---

### 3. Analytics, Modeling & Reliability Terms
| Acronym | Term | Operational / Analytical Definition |
|---|---|---|
| **RUL** | Remaining Useful Life | Target variable ($T_{\text{failure}} - t$) representing cycles left before functional breakdown |
| **OLS** | Ordinary Least Squares | Linear statistical modeling method used for interpretable trend fitting |
| **LOWESS** | Locally Weighted Scatterplot Smoothing | Non-parametric regression method used to visualize non-linear degradation paths |
| **VIF** | Variance Inflation Factor | Diagnostic metric used to test for multi-collinearity among sensor features |
| **RMSE** | Root Mean Squared Error | Standard regression evaluation metric for engine $RUL$ predictions |
| **PF-Interval** | Potential-to-Functional Failure | Time window between initial anomaly detection ($P$) and total functional failure ($F$) |
| **MTBF** | Mean Time Between Failures | Average operating cycles expected between unscheduled engine removals |
| **SCIP** | Situation, Context, Impact, Proposal | Executive business framing methodology for maintenance recommendations |

---

## 🇪🇺 Unit Conversion Reference (Imperial $\rightarrow$ SI Standard)

| Measurement Dimension | Raw Unit (NASA C-MAPSS) | SI / European Metric Unit | Exact Conversion Formula |
|---|---|---|---|
| **Temperature** | Rankine ($^\circ\text{R}$) | Kelvin ($\text{K}$) | $T(\text{K}) = T(^\circ\text{R}) \times \frac{5}{9}$ |
| **Temperature (Relative)** | Rankine ($^\circ\text{R}$) | Celsius ($^\circ\text{C}$) | $T(^\circ\text{C}) = (T(^\circ\text{R}) - 491.67) \times \frac{5}{9}$ |
| **Pressure** | Pounds per Sq. Inch Absolute ($\text{psia}$) | Bar ($\text{bar}$) | $1\text{ psia} = 0.0689476\text{ bar}$ |
| **Pressure** | Pounds per Sq. Inch Absolute ($\text{psia}$) | Kilopascal ($\text{kPa}$) | $1\text{ psia} = 6.89476\text{ kPa}$ |
| **Mass Flow Rate** | Pounds Mass per Second ($\text{lbm/s}$) | Kilograms per Second ($\text{kg/s}$) | $1\text{ lbm/s} = 0.453592\text{ kg/s}$ |
| **Specific Enthalpy** | BTU per Pound ($\text{BTU/lb}$) | Kilojoules per Kilogram ($\text{kJ/kg}$) | $1\text{ BTU/lb} = 2.326\text{ kJ/kg}$ |

---

## 🛠️ Complete Variable Schema

| Variable Name | Data Type | Physical / Station Code | Raw Unit | SI Metric Unit | Status |
|---|---|---|---|---|---|
| `unit_nr` | Integer | Engine Identification | Dimensionless | Dimensionless | **Kept** |
| `time_cycles` | Integer | Operational Life Counter | Cycles | Cycles | **Kept** |
| `setting_1` | Float | Flight Setting 1 (Altitude) | Standardized | Standardized | **Kept** |
| `setting_2` | Float | Flight Setting 2 (Mach Number) | Standardized | Standardized | **Kept** |
| `setting_3` | Float | Flight Setting 3 (TRA) | Standardized | Standardized | **Kept** |
| `s_1` | Float | T2 (Fan Inlet Temp) | $^\circ\text{R}$ | $\text{K}$ | ❌ **Dropped (Flatline)** |
| `s_2` | Float | T24 (LPC Outlet Temp) | $^\circ\text{R}$ | $\text{K}$ / $^\circ\text{C}$ | ✅ **Kept** |
| `s_3` | Float | T30 (HPC Outlet Temp) | $^\circ\text{R}$ | $\text{K}$ / $^\circ\text{C}$ | ✅ **Kept** |
| `s_4` | Float | T50 (LPT Outlet Temp) | $^\circ\text{R}$ | $\text{K}$ / $^\circ\text{C}$ | ✅ **Kept** |
| `s_5` | Float | P2 (Fan Inlet Press) | $\text{psia}$ | $\text{bar}$ | ❌ **Dropped (Flatline)** |
| `s_6` | Float | P15 (Bypass Duct Press) | $\text{psia}$ | $\text{bar}$ | ❌ **Dropped (Flatline)** |
| `s_7` | Float | P30 (HPC Outlet Total Press) | $\text{psia}$ | $\text{bar}$ | ✅ **Kept** |
| `s_8` | Float | Nf (Physical Fan Speed) | $\text{rpm}$ | $\text{rpm}$ | ✅ **Kept** |
| `s_9` | Float | Nc (Physical Core Speed) | $\text{rpm}$ | $\text{rpm}$ | ✅ **Kept** |
| `s_10` | Float | epr (Engine Pressure Ratio) | Ratio | Ratio | ❌ **Dropped (Flatline)** |
| `s_11` | Float | Ps30 (HPC Outlet Static Press) | $\text{psia}$ | $\text{bar}$ | ✅ **Kept** |
| `s_12` | Float | phi (Fuel Flow Ratio) | $\text{pps/psia}$ | $\text{kg/(s}\cdot\text{bar)}$ | ✅ **Kept** |
| `s_13` | Float | NRf (Corrected Fan Speed) | $\text{rpm}$ | $\text{rpm}$ | ✅ **Kept** |
| `s_14` | Float | NRc (Corrected Core Speed) | $\text{rpm}$ | $\text{rpm}$ | ✅ **Kept** |
| `s_15` | Float | BPR (Bypass Ratio) | Ratio | Ratio | ✅ **Kept** |
| `s_16` | Float | burn_opt (Burner Fuel-Air Ratio)| Ratio | Ratio | ❌ **Dropped (Flatline)** |
| `s_17` | Float | Bleed (Bleed Enthalpy) | $\text{BTU/lb}$ | $\text{kJ/kg}$ | ✅ **Kept** |
| `s_18` | Float | BCI (Demanded Fan Speed) | $\text{rpm}$ | $\text{rpm}$ | ❌ **Dropped (Flatline)** |
| `s_19` | Float | BCI_cor (Demanded Corr. Fan) | $\text{rpm}$ | $\text{rpm}$ | ❌ **Dropped (Flatline)** |
| `s_20` | Float | HPT_bleed (HPT Coolant Bleed)| $\text{lbm/s}$ | $\text{kg/s}$ | ✅ **Kept** |
| `s_21` | Float | LPT_bleed (LPT Coolant Bleed)| $\text{lbm/s}$ | $\text{kg/s}$ | ✅ **Kept** |
| `RUL` | Integer | Target Life Remaining | Cycles | Cycles | **Target Variable** |

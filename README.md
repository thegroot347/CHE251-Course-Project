# Comparative Process Simulation of Leblanc and Solvay Soda Ash Manufacturing Processes

**Course:** CHE251 — Chemical Process Calculations
**Institution:** Indian Institute of Technology Kanpur
**Project Type:** Process Modeling + Material & Energy Balance Simulation

---

## Project Overview

This project develops steady-state process simulation models for the two major historical industrial routes used for the production of soda ash (Na₂CO₃):

1. **Leblanc Process**
2. **Solvay Process**

Both processes involve multiple reaction stages, separation units, recycle loops, and energy-intensive operations. The objective of this work was to formulate complete material and energy balance models for each process and evaluate their relative process efficiency, raw material utilization, and energy requirements.

The models were implemented in MATLAB and solved using nonlinear equation solvers to obtain process-wide stream flowrates, compositions, reaction extents, recycle rates, and unit energy duties.

---

## Scientific Background

Soda ash is one of the most important inorganic chemicals used in:

* Glass manufacturing
* Detergent production
* Water treatment
* Chemical synthesis
* Metallurgical processing

Historically, soda ash was manufactured using the **Leblanc Process**, which was eventually replaced by the more efficient **Solvay Process** due to lower energy consumption and reduced environmental impact.

Both routes involve extensive reaction networks and recycle streams, making them suitable case studies for large-scale process calculation and flowsheet analysis.

---

## Methodology

### Leblanc Process

The Leblanc model includes:

* Salt Cake Furnace
* Black Ash Furnace
* Leaching Unit
* Solid-Liquid Separation
* Recycle Streams

Major reactions:

[
2NaCl + H_2SO_4 \rightarrow Na_2SO_4 + 2HCl
]

[
Na_2SO_4 + CaCO_3 + 2C \rightarrow Na_2CO_3 + CaS + 2CO_2
]

Material balance equations were formulated for all process units and solved simultaneously using nonlinear optimization methods.

---

### Solvay Process

The Solvay model includes:

* Lime Kiln
* Lime Dissolver
* NH₃ Absorber
* CO₂ Absorber
* Carbonation Tower
* Filter
* Calciner
* Distiller
* Recycle Network

Major reactions:

[
CaCO_3 \rightarrow CaO + CO_2
]

[
CaO + H_2O \rightarrow Ca(OH)_2
]

[
NaCl + NH_3 + CO_2 + H_2O
\rightarrow
NaHCO_3 + NH_4Cl
]

[
2NaHCO_3
\rightarrow
Na_2CO_3 + CO_2 + H_2O
]

The complete flowsheet was modeled through coupled nonlinear material balance equations and solved numerically in MATLAB.

---

## Computational Approach

The process simulations were developed using MATLAB.

### Material Balance

For each process:

* Stream flowrates were treated as unknown variables.
* Component compositions were represented using mole-fraction variables.
* Reaction extents were introduced for each reaction stage.
* Process-wide balance equations were assembled and solved simultaneously.

### Energy Balance

Energy calculations were performed for all major units using:

* Standard heats of reaction
* Heat-capacity correlations
* Temperature corrections via Kirchhoff’s Law

Unit duties were aggregated to estimate total process energy consumption and specific energy requirements per tonne of soda ash produced.

---

## Key Results

### Process Simulation

The developed models successfully generated:

* Process stream flowrates
* Component compositions
* Reaction extents
* Recycle stream requirements
* Product generation rates

### Comparative Analysis

The simulations demonstrate the major advantages of the Solvay Process:

* Reduced raw material consumption
* Lower overall energy demand
* Improved recycle utilization
* Reduced waste generation

compared to the historical Leblanc route.

### Engineering Insights

The project illustrates how large industrial flowsheets can be modeled using first-principles conservation laws and solved computationally through nonlinear equation systems.

---

## Repository Structure

```text
.
├── Calculations
│   ├── Lablanc.m
│   └── Solvay.m
├── Docs
│   ├── End_Eval_Report.pdf
│   └── Mid_Eval_Report.pdf
└── Results
    ├── Lablanc.txt
    └── Solvay.txt
```

---

## Technical Skills Demonstrated

* Process Simulation
* Material Balance Modeling
* Energy Balance Analysis
* Recycle Stream Calculations
* Nonlinear Equation Solving
* MATLAB Programming
* Chemical Process Flowsheet Analysis
* Industrial Process Evaluation

---

## Academic Documentation

Detailed derivations, assumptions, process flowsheets, balance equations, and simulation methodology are available in:

* `Docs/Mid_Eval_Report.pdf`
* `Docs/End_Eval_Report.pdf`

The repository contains the complete MATLAB implementations and simulation outputs used for process evaluation and comparison.

---

## Future Improvements

Potential extensions include:

* Aspen Plus validation of both flowsheets
* Rigorous thermodynamic property packages
* Equipment sizing calculations
* Economic analysis
* Environmental impact assessment
* Dynamic process simulation

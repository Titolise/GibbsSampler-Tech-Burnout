# Gibbs Sampler: Tech Worker Burnout & Depression Analysis

This repository contains an R-based implementation of a custom Gibbs Sampler to perform a Bivariate Gaussian Mixture Model (GMM) clustering analysis. The model is applied to a 2026 dataset of tech workers to discover latent classes based on their Burnout and Depression (PHQ-9) scores.

In addition to the Bayesian MCMC approach, the repository includes scripts for Exploratory Data Analysis (EDA) and MCMC chain diagnostics.

[Read the full research paper (PDF)](/PDF/Tito_TechMentalB_GibbsSampler.pdf)

## 📂 Repository Structure

The project is modularized into the following R scripts:

- **`libraries.R`**: Loads all required R packages to ensure the environment is configured correctly.
- **`data.R`**: Ingests the `mental_health_burnout_tech_2026.csv` dataset. It handles data wrangling, such as creating sleep duration categories, preparing continuous variables for correlation matrices, and isolating the `burnout_score` and `phq9_score` variables for the MCMC algorithm. It also formats the resulting weight matrix for visualization.
- **`plots_descreptive.R`**: Generates baseline univariate distribution histograms and bivariate density contour plots to visualize the relationship between Burnout and Depression (PHQ-9).
- **`Gibbs_Sampler.R`**: The core algorithm script. It draws a random sample of 5,000 observations and runs a Gibbs sampler for 3 distinct classes. It initializes starting values using robust K-means, iterates to update weights (using a non-informative Dirichlet prior), means, and class assignments, and handles label-switching by ordering the means based on the Burnout score.
- **`plots.R`**: Creates general exploratory plots, such as "Burnout Level by Hours of Sleep" and "Depression Levels by Work Arrangement". Furthermore, it plots the Gibbs Sampler outputs, including traceplots, posterior densities, autocorrelation (ACF), and a final cluster scatterplot showing the bivariate classification.
- **`diagnostic.R`**: Uses the `coda` library to calculate MCMC diagnostics. It outputs 95% Equal-Tailed Credibility Intervals, Highest Posterior Density (HPD) intervals, Effective Sample Size (ESS), and Monte Carlo Standard Error (MCSE) for the cluster means and weights.

------------------------------------------------------------------------

## 📊 Data Overview

The analysis is built on the `mental_health_burnout_tech_2026.csv` dataset, which contains demographic, professional, and psychological data for tech industry employees.

Key tracked features include: \* **Demographics & Roles**: Age, gender, country, job role, and seniority level. \* **Work & Lifestyle**: Work arrangement (Remote, Hybrid, On-site), sleep hours per night, work hours per week, and meetings per day. \* **Mental Health Metrics**: Aggregated scores for Burnout (`burnout_score`), Depression (`phq9_score`), and Anxiety (`gad7_score`), along with categorized severity levels.

------------------------------------------------------------------------

## 🛠 Prerequisites & Dependencies

To execute the scripts, you must have R installed along with the following packages:

- `ggplot2`
- `dplyr`
- `ggcorrplot`
- `mvtnorm`
- `MCMCpack`
- `tidyr`
- `patchwork`
- `coda`

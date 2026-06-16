source("data.R")

# Convert the Lambda weight matrix
mcmc_lambda = mcmc(La[valid, ])
colnames(mcmc_lambda) = paste0("Class_Weight_", 1:3)

# Flatten the array of means (Mu) into a 2D matrix 
Mu_flat = cbind(
  Mu[1, 1, valid], Mu[1, 2, valid], # Class 1: Burnout, PHQ9
  Mu[2, 1, valid], Mu[2, 2, valid], # Class 2: Burnout, PHQ9
  Mu[3, 1, valid], Mu[3, 2, valid]  # Class 3: Burnout, PHQ9
)
colnames(Mu_flat) = c("Mu_C1_Burnout", "Mu_C1_PHQ9", 
                      "Mu_C2_Burnout", "Mu_C2_PHQ9", 
                      "Mu_C3_Burnout", "Mu_C3_PHQ9")
mcmc_mu = mcmc(Mu_flat)

# CREDIBILITY INTERVALS
cat("\n=== CREDIBILITY INTERVALS (95% Equal-Tailed) ===\n")
cat("Class weights (Lambda):\n")
print(summary(mcmc_lambda)$quantiles[, c("2.5%", "97.5%")])
cat("\nCluster Means (Mu):\n")
print(summary(mcmc_mu)$quantiles[, c("2.5%", "97.5%")])


# Highest Posterior Density
cat("\n=== 95% HPD (Highest Posterior Density) INTERVALS ===\n")
cat("Class weights (Lambda):\n")
print(HPDinterval(mcmc_lambda))
cat("\nCluster Means (Mu):\n")
print(HPDinterval(mcmc_mu))


# ESS
cat("\n=== EFFECTIVE SAMPLE SIZE (ESS) ===\n")
cat("ESS Weights (Lambda):\n")
print(effectiveSize(mcmc_lambda))
cat("\nESS Means (Mu):\n")
print(effectiveSize(mcmc_mu))


# MONTE CARLO STANDARD ERROR 
cat("\n=== MONTE CARLO STANDARD ERROR (MCSE) ===\n")
cat("MCSE Means (Mu):\n")
print(summary(mcmc_mu)$statistics[, "Time-series SE"])
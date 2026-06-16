source("data.R")

df_eda <- data %>%
  dplyr::select(burnout_score, phq9_score, work_mode, gender) %>%
  na.omit()

# Basic Summary Statistics
cat("Descriptive Statistics for Burnout and PHQ-9:\n")
summary(df_eda[, c("burnout_score", "phq9_score")])

# Univariate Distributions
# Plot 1: Burnout Distribution
p1 <- ggplot(df_eda, aes(x = burnout_score)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "steelblue", color = "white", alpha = 0.7) +
  geom_density(color = "darkblue", linewidth = 1) +
  theme_minimal() +
  labs(title = "Burnout Score Distribution",
       x = "Burnout Score (0-10)",
       y = "Density")

# Plot 2: Depression Distribution (PHQ-9)
p2 <- ggplot(df_eda, aes(x = phq9_score)) +
  geom_histogram(aes(y = after_stat(density)), bins = 28, fill = "salmon", color = "white", alpha = 0.7) +
  geom_density(color = "darkred", linewidth = 1) +
  theme_minimal() +
  labs(title = "PHQ-9 Score Distribution",
       x = "PHQ-9 Score (0-27)",
       y = "Density")


# Bivariate Distribution 
p3 <- ggplot(df_eda, aes(x = burnout_score, y = phq9_score)) +
  geom_point(alpha = 0.05, color = "grey30", size = 0.5) +  # Semi-transparent points
  geom_density_2d(color = "blue", linewidth = 0.8) +        # Contour lines
  theme_minimal() +
  labs(title = "Relationship Between Burnout and Depression",
       subtitle = "Bivariate Density",
       x = "Burnout Score",
       y = "PHQ-9 Score")
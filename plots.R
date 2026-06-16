source("data.R")

#---- Descriptive data plots ----
# Burnout distribution
ggplot(data, aes(x = burnout_score, fill = burnout_level)) + 
  geom_histogram(binwidth = 1, color = "black", alpha = .7) +
  theme_minimal() +
  labs(
    title = "Distribution of Burnout",
    x = "Burnout Score",
    y = "Frequency (# workers)",
    fill = "Burnout Levels")

# The Impact of Sleep Duration on Burnout
ggplot(df, aes(x = sleep_category, y = burnout_score, fill = sleep_category)) + 
  geom_boxplot(alpha = .8) +
  scale_fill_brewer(palette = "Reds") + 
  theme_minimal() +
  labs(
    title = "Burnout Level by Hours of Sleep",      
    x = "Sleep Category",
    y = "Burnout Score") +
  theme(legend.position = "none")

# Remote vs in-office paradox
ggplot(df, aes(x = work_mode, y = phq9_score, fill = work_mode)) + 
  geom_violin(trim = F, alpha = .6) +
  geom_boxplot(width = .1, fill = "white", color = "black") +
  theme_minimal() +
  labs(title = "Depression Levels (PHQ-9) by Work Arrangement",
       x = "Work Arrangement",
       y = "PHQ-9 Score (Depression)")

# Correlation plot
ggcorrplot(corr_matrix,
           lab = TRUE,
           digits = 2,
           show.legend = TRUE,
           type = "lower",
           tl.cex = 6)

#---- Gibbs Sampler plots ---- 
ggplot(df_La, aes(x = Iteration, y = Weight)) +
  geom_line(color = "black", alpha = 0.7) +
  geom_hline(data = df_mla, aes(yintercept = Mean), color = "red", linetype = "dashed") +
  facet_wrap(~ Class, nrow = 3, scales = "free_y") +
  theme_minimal() +
  labs(title = "Class Weights Traceplot (Lambda)", x = "Iteration", y = "Weight")

ggplot(df_Mu_burnout, aes(x = Iteration, y = Mean, color = Class)) +
  geom_line(alpha = 0.8) +
  theme_minimal() +
  labs(title = "Burnout Means Traceplot", x = "Iteration", y = "Mean Burnout") +
  theme(legend.position = "bottom", legend.title = element_blank())


# Define burn-in for subsequent plots (discard the first 500 iterations)
burn_in = 500
valid = (burn_in + 1):R

# POSTERIOR DENSITIES 
par(mfrow=c(1,2))

# Burnout density for the 3 classes
plot(density(Mu[1, 1, valid]), col=1, lwd=2, xlim=range(Mu[, 1, valid]),
     main="Posterior Density (Burnout)", xlab="Score", ylab="Density")
lines(density(Mu[2, 1, valid]), col=2, lwd=2)
lines(density(Mu[3, 1, valid]), col=3, lwd=2)
legend("topright", legend=paste("Class", 1:k), col=1:k, lwd=2, cex=0.8)

# Depression density (PHQ-9) for the 3 classes
plot(density(Mu[1, 2, valid]), col=1, lwd=2, xlim=range(Mu[, 2, valid]),
     main="Posterior Density (PHQ-9)", xlab="Score", ylab="Density")
lines(density(Mu[2, 2, valid]), col=2, lwd=2)
lines(density(Mu[3, 2, valid]), col=3, lwd=2)

# AUTOCORRELATION (ACF)
par(mfrow=c(3,1))
acf(La[valid, 1], main = "")
acf(La[valid, 2], main = "")
acf(La[valid, 3], main = "")
par(mfrow=c(1,1))

# CLUSTER SCATTERPLOT
par(mfrow=c(1,1), mar=c(5,4,4,2))
# Plot points colored by majority class assignment (zb)
plot(Y[,1], Y[,2], col = zb, pch = 20, cex = 0.6,
     main = "Final Classification (Bivariate GMM)",
     xlab = "Burnout Score", ylab = "PHQ-9 Score")

# Add centroids (posterior means) as larger points
points(mmu[,1], mmu[,2], col = 1:k, pch = 4, cex = 3, lwd = 3)
legend("topleft", legend = paste("Class", 1:k), col = 1:k, pch = 20, title = "Cluster")
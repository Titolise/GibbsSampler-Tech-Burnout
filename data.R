source("libraries.R")

#---- Row Data ----
data = read.csv("data/mental_health_burnout_tech_2026.csv")
dim(data)
head(data)

summary(data)

#---- Plotting Data ---- 
# Create a class for the sleeping hours 
df = data %>%
  mutate(sleep_category = case_when(
    sleep_hours_per_night < 5 ~ "< 5 Hours",
    sleep_hours_per_night >= 5 & sleep_hours_per_night < 8 ~ "5 - 7 Hours",
    sleep_hours_per_night >= 8 ~ "8+ Hours"
  )) %>%
  mutate(sleep_category = factor(sleep_category, 
    levels = c("< 5 Hours", "5 - 7 Hours", "8+ Hours")))


# Isolate the cont variables
conts = df %>%
  dplyr::select(
    burnout_score,
    phq9_score,
    gad7_score,
    stress_score,
    meetings_per_day,
    sleep_hours_per_night,
    work_hours_per_week,
    salary_usd
)

# Correlation Matrix
corr_matrix = cor(conts, use = "complete.obs")

#---- Data setup for Gibbs Sampler ----
#Select the variables
df_clean = (data[, c("burnout_score", "phq9_score")])

# ---- Data transformation for Gibbs Sampler plotting ---- 
# Let's convert the La matrix into a columnar data frame
df_La <- as.data.frame(La) %>%
  mutate(Iteration = row_number()) %>%
  pivot_longer(cols = -Iteration, names_to = "Class", values_to = "Weight") %>%
  mutate(Class = gsub("V", "Class ", Class)) 

# Let's create a dataframe for the red lines (averages)
df_mla <- data.frame(Class = paste("Class", 1:3), Mean = mla)

# Traceplot of the first dimension (Burnout Score)
df_Mu_burnout <- data.frame(
  Iteration = 1:R,
  `Classe 1` = Mu[1, 1, ],
  `Classe 2` = Mu[2, 1, ],
  `Classe 3` = Mu[3, 1, ],
  check.names = FALSE
) %>%
  pivot_longer(cols = -Iteration, names_to = "Class", values_to = "Mean")


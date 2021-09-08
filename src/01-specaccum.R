# libraries ----
library(here)
library(tidyverse)
library(vegan)
library(janitor)

# import ---
df_raw <- read.csv(
  here("data/original", "Costa_Rica_Species_Accumulation.csv"), 
  stringsAsFactors = FALSE
)

# check packaging ---
str(df_raw)
head(df_raw, n = 10)
tail(df_raw, n = 10)

# clean ----

df_tidy <- df_raw %>%
  janitor::clean_names() %>%
  tibble::column_to_rownames(var = "collection")

# species accumulation curve: interpolation -----

specc <- specaccum(
  comm = df_tidy, 
  method = "rarefaction"
)

# grab maximum expected richness
max(specc$richness)

# plot the SAC
plot(specc)

# species accumulation curve: extrapolation ----
fitspecc <- fitspecaccum(
  specc, "lomolino"
)

coef(fitspecc)
predict(fitspecc)


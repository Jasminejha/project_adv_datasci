# Script to implementing elastic net for feature selection

# ------------------------------------------------------------- #
# Preliminaries ----
# ------------------------------------------------------------- #

## Load packages
library(tidyverse)
library(here)
library(glmnet)
library(ipumsr)
library(rsample)
library(recipes)
library(parsnip)
library(workflows)
library(tidymodels)
library(doParallel)

##  Define path information
if (Sys.getenv("USER") == "maleehameed") {
  box <- file.path('/Users', 'maleehameed', 'Documents', 'adv_data_sci', 'project_adv_datasci')
} else{
  stop('Define machine-specific Box path.')
}

## Define folder path
ipums_path <- file.path(box, 'data', 'nhis_00004')

## Set seed
set.seed(2025)

## Set parallel processing
#registerDoParallel(cores = parallel::detectCores() - 1)

plan(multisession, workers = parallel::detectCores() - 1)  # How can I update this to make the tuning work?
future::plan()

# ------------------------------------------------------------- #
# Load dataset ----
# ------------------------------------------------------------- #

# Load data 
ipums <- read_csv(file.path(ipums_path, "nhis_00004.csv"))

# ------------------------------------------------------------- #
# Split dataset ----
# ------------------------------------------------------------- #

set.seed(2025)

ipums_split <- initial_split(ipums, prop = 0.8)

ipums_train <- training(ipums_split)

# ------------------------------------------------------------- #
# Crossvalidation ----
# ------------------------------------------------------------- #

ipums_folds <- vfold_cv(data = ipums_train, v = 5)

# ------------------------------------------------------------- #
# Elastic Net ----
# ------------------------------------------------------------- #

# Create recipt
enet_rec <- recipe(WLDAYR ~ ., data = ipums_train) |>
  update_role(NHISHID, NHISPID, HHX, FMX, PX, new_role = "ID") |>
  step_zv(all_predictors()) |>                 #Is it fine to remove predictors with zero variance?
  step_normalize(all_numeric_predictors()) |>  #Are there any other step functions to apply?
  step_corr(all_numeric_predictors())

#update_role(var1, var2, var3, new_role = "id") |> # add variables

# Create model
enet_mod <- linear_reg(penalty = tune(), mixture = tune()) |>
  set_mode(mode = "regression") |>
  set_engine(engine = "glmnet")  

# Create workflow
enet_wf <- workflow() |>
  add_recipe(recipe = enet_rec) |>
  add_model(spec = enet_mod)

# Create grid
enet_grid <- grid_regular(
  penalty(), 
  mixture(),
  levels = 5  # Reduced from 20 to 5
)

# Tune grid
enet_tuning <- tune_grid( # Taking forever to run
  enet_wf,
  resamples = ipums_folds, 
  grid = enet_grid
)

# Identify best tuning results
show_best(enet_tuning)

# Visualize tuning results
autoplot(enet_tuning)

# Finalize workflow
enet_tuned_wf <-
  enet_wf |>
  tune::finalize_workflow(tune::select_best(x = enet_tuning, metric = "rmse"))

# Fit final workflow
enet_resamples <- enet_tuned_wf |>
  fit_resamples(resamples = ipums_folds) 

# Collect metrics
enet_resamples |>
  collect_metrics()

# Visualize results from fitted workflow
bind_cols(
  grid,
  enet_tuned_wf |>
    last_fit(pdb_split) |>
    extract_workflow() |>
    predict(new_data = grid)
) |>
  ggplot(aes(var, .pred)) + #replace with variable
  geom_line() +
  labs(title = "Fitted Function for Linear Regression")
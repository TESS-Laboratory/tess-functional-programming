# minimal example targets script

# Load packages required to define the pipeline:
library(targets)

# Set target options:
tar_option_set(
  # Packages that your targets need for their tasks.
  packages = c("tibble", "palmerpenguins", "vroom", "purrr", "dplyr", 
               "tidyr", "ggplot2", "patchwork","gtsummary", "cli"), 
  format = "qs", # Optionally set the default storage format. qs is fast.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Custom Extra functions
# This is the model we're going to fit -  let's wrap it in a function using the shorthand `\`
peng_lm <- \(x)  lm(body_mass_kg ~ sex, data = x)

# Replace the target list below with your own:
list(
  tar_target(
    name = data_files,
    command = list.files("data", full.names = TRUE)
  ),
  tar_target(data_read, read_data(data_files), 
             pattern = map(data_files)),
  tar_target(peng_island, get_island(data_read), 
             pattern = map(data_read)),
  tar_target(peng_ggplot, penguins_viz(data_read), 
             pattern = map(data_read), iteration = "list"),
  tar_target(peng_model, peng_lm(data_read), 
             pattern = map(data_read), iteration = "list"),
  tar_target(peng_mod_tabs, 
             gtsummary::tbl_regression(peng_model, intercept = TRUE), 
             pattern = map(peng_model), iteration = "list"),
  tar_target(set_tab_names, purrr::set_names(peng_mod_tabs, peng_island)),
  tar_target(merge_tables, tbl_merge(set_tab_names, tab_spanner = peng_island)),
  tar_target(peng_multi_ggplot, purrr::reduce(peng_ggplot, `+`))
)

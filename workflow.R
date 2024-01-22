#' @title a function to reload all packages and required functions.
#' @description this is simply a clean way to reload your functions if any are
#' updated or changed. It also creates the data directory needed later on if
#' you haven't already created it.
reload <- function(){
  # load all the packages you need for the project.
  source("packages.R")
  # make the data dir if it doesn't exist.
  if (!file.exists("data")) dir.create("data") 
  # read the functions from our R directory.
  function_files <- list.files("R", pattern = ".R$", full.names = TRUE)
  walk(function_files, source)
}
reload()

# ---------------------- Some silly examples: ----------------------------
# Just to kick things off - here are some very basic functional concepts; why
# change some of them and see what you can create? Go to "R/hello-world.R"

hello_world("Andy") # A simple function that says hello to someone.

walk(c("Hugh", "Andy", "Taps", "Glenn"), hello_world ) # let's say hello to lots of people.

# This is a function factory which returns a function which can differ depending on the arguments provided
todays_day <- days_ago_generator() 
todays_day() # What day is it?

# And now let's create a new function which figures out what day it was 200 days ago.
# Note that function factories or monads are more advanced concepts, the benefits
# of which are not always immediately obvious but they're good to be aware of!
days_200_days_ago <- days_ago_generator(200)
days_200_days_ago()

# ----------------- existing functions: -----------------------

penguins #  this is the penguin dataset from {palmerpenguins} see ?penguins
unique(penguins$island) # what are the unique islands that were surveyed? there are 3...

# let's split the dataframe by island and save as 3 different csv files 
# this is using functional programming and avoids a for - not essential but clean 
# looking and easy to read.
penguins |>
  group_split(island) |> 
  walk(\(x) vroom::vroom_write(x,file.path("data",paste0(unique(x$island), ".csv"))))

# ----------- Example Data processing pipeline. --------------------------
# Okay Now let's build a short example pipeline with these penguin files...

# read the data files and clean them.
penguins_list <- list.files("data", full.names = TRUE) |> 
  purrr::map(read_data) 

# get the names of the islands (we'll use this later.)
island_names <- penguins_list |> 
  map(get_island)

# create ggplots of the data to compare body mass between sex.
penguins_ggplot <- penguins_list |> 
  map(penguins_viz)

# use reduce to combine these into a single plot (uses {patchwork} to combine them)
purrr::reduce(penguins_ggplot, `+`)

# This is the model we're going to fit -  let's wrap it in a function using the shorthand `\`
peng_lm <- \(x)  lm(body_mass_kg ~ sex, data = x)

# Now we have our models, let's create some pretty tables for reporting.
mod_list <- map(penguins_list, peng_lm) |> 
  map(~gtsummary::tbl_regression(.x, intercept = TRUE)) |> 
  purrr::set_names(island_names) # here we use the island names 

# Finally we can now merge all of our tables into one.
tbl_merge(mod_list, tab_spanner = names(mod_list))




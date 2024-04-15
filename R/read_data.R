#' @title read and clean our data.
read_data <- function(fp){
  vroom::vroom(fp) |>
    dplyr::mutate(across(dplyr::ends_with("mm"),
                  list("_m" = \(x) x/1000),
                  .names = "{sub('_mm', '', .col)}{.fn}"),
           across(dplyr::ends_with("mass_g"),
                  list("_kg" = \(x) x/1000),
                  .names = "{sub('_g', '', .col)}{.fn}")
    ) |>
    dplyr::select(!ends_with(c("_g", "_mm"))) |>
    tidyr::drop_na(ends_with(c("_m", "_g"))) |> 
    dplyr::mutate(sex = case_when(is.na(sex) ~ "unknown",
                           TRUE ~ sex))
}

#' @title helper to get the island name from our dataframes.
get_island <- function(x){
  x$island[1]
}
penguins_viz <- function(peng_df){
  ggplot(peng_df) +
    aes(x = sex, y=body_mass_kg, colour=sex) +
    geom_jitter() +
    geom_boxplot(fill=NA)+
    scale_colour_brewer(palette = "Dark2") +
    theme_light() +
    labs(title=unique(peng_df$island))
}
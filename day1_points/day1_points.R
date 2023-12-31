

# Import packages -----------------------------------------------------

library(cowplot)
library(dplyr)
library(ggplot2)
library(sf)
library(showtext)
library(tigris)

# Load Brevard County Shapefile ---------------------------------------

brevard_county <-
  tigris::counties(state = 'FL') %>%
  filter(COUNTYFP == '009')

# Load Historic Bridges Shapefile -------------------------------------

bridges <-
  sf::read_sf('day1_points/data/shpo_bridges_oct23.shp') %>%
  # Match CRS
  sf::st_transform(crs = sf::st_crs(brevard_county)) %>%
  # Filter to bridges in brevard county
  sf::st_filter(brevard_county) %>%
  # Drop geometry to remake from lines to points
  sf::st_drop_geometry() %>%
  sf::st_as_sf(coords = c('LONG_DD',
                          'LAT_DD'),
               crs = sf::st_crs(brevard_county)) %>%
  # Add a column to distinguish the Sebastian Inlet Bridge
  mutate(is_seb = case_when(FDOTNUM == 880005 ~ 'triangle',
                            TRUE ~ 'circle'))

showtext_auto()
font_add_google("Arvo")
plotfont <- "Arvo"

map <-
ggplot() +
  geom_sf(data = brevard_county, color = 'black', fill = '#FFE8D1') +
  geom_sf(
    data = bridges,
    aes(
      group = stringr::str_to_sentence(CONDITION),
      color = stringr::str_to_sentence(CONDITION),
      size = 1,
      shape = is_seb
    )
  ) +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    legend.title.align = 0.25,
    plot.title = element_text(hjust = 0.5,
                              color = 'white',
                              size = 24),
    plot.subtitle = element_text(color = 'white',
                                 hjust = 0.5,
                                 size = 18),
    plot.background = element_rect(fill = "#493C29"),
    legend.text = element_text(color = 'white',
                               lineheight = 0.6),
    legend.title = element_text(color = 'white'),
    legend.position = c(0.95, 0.5),
    plot.caption = element_text(color = 'white',
                                hjust = 0.5,
                                size = 14),
    plot.margin = margin(t = 30,
                         r = 15,
                         b = 30,
                         l = 15),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) +
  guides(size = 'none') +
  guides(shape = 'none') +
  scale_color_manual(
    name = 'Condition',
    values = c('#BA8863',
               '#697791',
               '#596235',
               '#C28686',
               '#7F797B')
  )

ggdraw() +
  draw_plot(map) +
  draw_text('Historic Bridges in Brevard County, Florida',
            x = 0.5,
            y = 0.97,
            size = 36,
            family = plotfont,
            color = 'white') +
  draw_text('2023 30-Day Map Challenge Day 1: Points',
            x = 0.5,
            y = 0.94,
            size = 28,
            family = plotfont,
            color = 'white') +
  draw_text('Alexander Adams',
            x = 0.5,
            y = 0.92,
            size = 28,
            family = plotfont,
            color = 'white') +
  draw_text('Data Source: Florida Geographic Data Library\nTwitter: @alexadams385\nGitHub: AAdams149',
            x = 0.5,
            y = 0.05,
            size = 24,
            family = plotfont,
            color = 'white',
            lineheight = 0.6)

ggsave('day1_points/day1_points.png', width = 2100, height = 2100, units = 'px')

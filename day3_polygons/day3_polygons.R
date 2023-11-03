
# load packages -------------------------------------------------------

library(dplyr)
library(ggplot2)
library(rgeos)
library(sf)
library(showtext)
library(tidyr)
library(tigris)

# establish font ------------------------------------------------------

showtext_auto()
font_add_google("Poly")
plotfont <- "Poly"


# load ward shapefile -------------------------------------------------

wards <-
  sf::st_read('day3_polygons/Wards_from_2022.shp') %>%
  select(NAME, geometry) %>%
  st_transform(crs = 4326)


# load DC demographic data + census tract shapefile -------------------

data <-
  read.csv('day3_polygons/Census_Tracts_in_2020.csv') %>%
  select(GEOID,
         "total_population" = P0010001,
         "total_housing" = H0010001,
         "vacant_housing" = H0010003) %>%
  mutate(GEOID = as.character(GEOID),
         vac_ratio = vacant_housing/total_housing*100,
         vac_ratio_factor = case_when(vac_ratio < 10 ~ '< 10%',
                                      vac_ratio >= 10 & vac_ratio < 20 ~ '10-20%',
                                      vac_ratio >= 20 & vac_ratio < 30 ~ '20-30%',
                                      vac_ratio >= 30 ~ '> 30%'),
         vac_ratio_factor = factor(vac_ratio_factor,
                                      levels = c('< 10%',
                                                 '10-20%',
                                                 '20-30%',
                                                 '> 30%'))) %>%

  left_join(tigris::tracts('DC')) %>%
  st_as_sf() %>%
  st_transform(crs = st_crs(wards))


# plot map ------------------------------------------------------------

data %>%
  ggplot() +
  geom_sf(data = data, aes(fill = vac_ratio_factor,
              geometry = geometry)) +
  geom_sf(data = wards, 
          linewidth = 0.7,aes( 
                            geometry = geometry,
                            alpha = 0)) +
  geom_sf_label(data = wards, aes(label = NAME)) +
  theme_void() +
  ggtitle('Housing Vacancy Rate by Census Tract, Washington, D.C., 2020',
          subtitle = '2023 30-Day Mapping Challenge Day 3: Polygons\nAlexander Adams') +
  labs(caption = 'Data Source: opendata.dc.gov\nTwitter: @alexadams385\nGitHub: AAdams149') +
  scale_fill_manual(values = c('#a4d9f9',
                               '#7ba1b8',
                               '#5c7787',
                               '#3d4d57'),
                    name = 'Housing Vacancy Rate') +
  guides(linewidth = FALSE) +
  guides(alpha = FALSE) +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = 'white',
                                   color = 'white'),
    legend.title.align = 0.5,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'black'),
    legend.title = element_text(color = 'black'),
    legend.position = c(0.2, 0.3),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 14),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 

ggsave('day3_polygons/day3_polygons.png')

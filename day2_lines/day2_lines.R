


# load libraries ------------------------------------------------------
library(dplyr)
library(ggplot2)
library(OpenStreetMap)
library(sf)
library(showtext)
library(tidyr)
library(tigris)
library(tmap)
library(tmaptools)


# load shapefile for rome ---------------------------------------------

rome <-
  tigris::places("GA") %>%
  filter(NAME == 'Rome')

# load shapefile for rome roads ---------------------------------------

roads <-
  sf::read_sf('day2_lines/data/tgr115rds.shp') %>%
  sf::st_set_crs(st_crs(rome)) %>%
  sf::st_filter(rome)


# set font ------------------------------------------------------------

showtext_auto()
font_add_google("Vesper Libre")
plotfont <- "Vesper Libre"


# set tmap plotting mode ----------------------------------------------

tmap_mode('plot')


# expand bounding box -------------------------------------------------

bbox_new <- st_bbox(rome) # current bounding box

xrange <- bbox_new$xmax - bbox_new$xmin # range of x values
yrange <- bbox_new$ymax - bbox_new$ymin # range of y values

bbox_new[1] <- bbox_new[1] - (0.25 * xrange) # xmin - left
bbox_new[3] <- bbox_new[3] + (0.25 * xrange) # xmax - right
bbox_new[2] <- bbox_new[2] - (0.25 * yrange) # ymin - bottom
bbox_new[4] <- bbox_new[4] + (0.25 * yrange) # ymax - top

bbox_new <- bbox_new %>%
  st_as_sfc()


# instantiate basemap -------------------------------------------------

basemap <-
  sf::st_bbox(bbox_new) %>%
  tmaptools::read_osm()


# plot mao ------------------------------------------------------------

tm_shape(basemap) +
  tm_rgb() +
  tm_shape(rome) +
  tm_polygons(alpha = 0.3) +
  tm_shape(roads) +
  tm_lines() +
  tm_layout(
    legend.position = c("right", "top"),
    main.title = 'Roads in Rome, Georgia\n2023 30-Day Mapping Challenge Day 2: Lines\nAlexander Adams',
    main.title.position = c('center', 'top'),
    title.position = c('center', 'top'),
    fontfamily = 'Vesper Libre'
  ) +
  tm_credits('Data Source: Georgia GIS Clearinghouse\nTwitter: @alexadams385\nGitHub: AAdams149')


# save plot -----------------------------------------------------------

tmap::tmap_save(filename = 'day2_lines/day2_lines.png')

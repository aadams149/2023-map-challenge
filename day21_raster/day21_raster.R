
library(cowplot)
library(dplyr)
library(purrr)
library(showtext)
library(terra)
library(tidyterra)

showtext_auto()
font_add_google('Rasa')
plotfont <- 'Rasa'


# preprocess raster data to save memory ----

# raster_names <-
#   list.files('day21_raster/data')
# 
# myrasters <- paste('day21_raster/data/',raster_names, sep = '') %>%
#   map(~ terra::rast(.))
# 
# s <- sprc(myrasters)
# m <- merge(s)
# 
# fl <-
#   rnaturalearth::ne_states(country = 'United States of America',
#                            returnclass = 'sf') %>%
#   filter(name == 'Florida') %>%
#   dplyr::select(name) %>%
#   st_crop(y = c(xmin = -87.6269226499603,
#                 ymin = 24.5425479190001,
#                 xmax = -80.0323787099999,
#                 ymax = 26.5))
# 
# fl_raster <-
#   terra::crop(m, fl)
# 
# writeRaster(fl_raster, 'day21_raster/fl_raster.tif')


# load data and plot --------------------------------------------------

fl_raster <-
  terra::rast('day21_raster/fl_raster.tif')

map <-
ggplot() +
  geom_sf(data = fl, mapping = aes(), fill = "#ffbc30", alpha = 0.4) +
  geom_spatraster(data = fl_raster) +
  # Not plotting NAs of the raster
  scale_fill_continuous(na.value ='transparent',
                    low = '#95a450',
                    high = '#95a450') +
  guides(fill = 'none') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#1c4c69'),
    panel.background = element_rect(fill = '#1c4c69'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24,
                              lineheight = 0.5),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.8, 0.15),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.8),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggdraw() +
  draw_plot(map) +
  draw_text('Mangrove Coverage in South Florida', 
            x = 0.5,
            y = 0.97,
            size = 44,
            family = plotfont,
            color = 'white') +
  draw_text('2023 30-Day Mapping Challenge Day 21: Raster\nAlexander Adams',
            x = 0.78,
            y = 0.1,
            size = 32,
            family = plotfont,
            color = 'white',
            lineheight = 0.3) +
  draw_text('Data: Advanced Land Observing Satellite [ALOS]\nTwitter: @alexadams385\nGitHub: AAdams149',
            x = 0.78,
            y = 0.05,
            size = 28,
            family = plotfont,
            color = 'white',
            lineheight = 0.3)

ggsave('day21_raster/day21_raster.png')

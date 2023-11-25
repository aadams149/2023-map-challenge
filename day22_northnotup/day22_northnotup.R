
library(cowplot)
library(dplyr)
library(ggnewscale)
library(ggplot2)
library(ggspatial)
library(sf)
library(showtext)

showtext_auto()
font_add_google('Domine')
plotfont <- 'Domine'

# Prep shapefile of nile river

# rivers <-
#   st_read('day22_northnotup/rivers_africa_37333.shp') %>%
#   filter(stringr::str_detect(SUB_NAME,'Nile')) %>%
#   mutate(length = st_length(.)) %>%
#   select(SUB_NAME) %>%
#   mutate(sub_color = case_when(stringr::str_detect(SUB_NAME,'Blue') ~ 'Blue Nile',
#                                stringr::str_detect(SUB_NAME, 'White') ~ 'White Nile',
#                                stringr::str_detect(SUB_NAME,'Victoria') ~ 'Victoria Nile',
#                                TRUE ~ 'Nile'))
# 
# st_write(rivers,
#          'day22_northnotup',
#          'nile_river',
#          driver = "ESRI Shapefile")

rivers <-
  st_read('day22_northnotup/nile_river.shp')

countries <-
  rnaturalearth::ne_countries(country = c('Egypt',
                                          'Sudan',
                                          'South Sudan',
                                          'Ethiopia',
                                          'Uganda'),
                              returnclass = 'sf') %>% 
  select(admin)

rivers_main <-
  st_read('day22_northnotup/ne_110m_rivers_lake_centerlines.shp') %>%
  filter(name == 'Nile') %>%
  select(name)


# flip geometries -----------------------------------------------------

rot = function(a) matrix(c(cos(a), sin(a), -sin(a), cos(a)), 2, 2)

countries$geometry <- countries$geometry * rot(pi)

rivers$geometry <- rivers$geometry * rot(pi)

rivers_main$geometry <- rivers_main$geometry * rot(pi)


# plot map ------------------------------------------------------------

map <-
  ggplot() +
  geom_sf(data = countries,
          color = 'black',
          fill = '#ffbc95',
          alpha = 0.8) +
  geom_sf(data = rivers,
          aes(color = factor(sub_color)),
          alpha = 0.5,
          key_glyph = 'rect') +
  scale_color_manual(name = 'Nile Tributaries',
                     values = c('#7c7afe', # Blue Nile
                                '#06047d', # Nile
                                '#293D3E', # Vic Nile
                                '#FFFFFF'),# White Nile
                     labels = c('Blue Nile',
                                'Northern Nile',
                                'Victoria Nile',
                                'White Nile'))+
  #guides(color = guide_legend(override.aes = list(shape = 15, size = 5))) +
  geom_sf(data = rivers_main,
          color = '#38afcd') +
  ggspatial::annotation_north_arrow(rotation = 180,
                                    pad_y = unit(0.65,'in'),
                                    style = north_arrow_nautical(line_col = 'white',
                                                                 text_col = 'white',
                                                                 text_size = 24,
                                                                 text_family = plotfont)) +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#1c4c69',
                                   color = '#1c4c69'),
    panel.background = element_rect(fill = '#1c4c69',
                                    color = '#1c4c69'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'white',
                              size = 24,
                              lineheight = 0.5),
    legend.text = element_text(color = 'white',
                               family = plotfont,
                               size = 28),
    legend.title = element_text(color = 'white',
                                family = plotfont,
                                size = 28),
    legend.box = 'vertical',
    legend.key.size = unit(0.5,'cm'),
    legend.box.margin = margin(0,0,0,0),
    plot.margin = margin(t = 15,
                         r = 15,
                         b = 15,
                         l = 15),
    legend.position = c(0.3, 0.4),
    plot.caption = element_text(color = 'white',
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
  draw_text('The Nile River and its Tributaries', 
            x = 0.4,
            y = 0.97,
            size = 44,
            family = plotfont,
            color = 'white') +
  draw_text('2023 30-Day Mapping Challenge Day 22: \nNorth is not Always Up\nAlexander Adams',
            x = 0.4,
            y = 0.92,
            size = 32,
            family = plotfont,
            color = 'white',
            lineheight = 0.3) +
  draw_text('Data: United Nations Food and Agriculture Organization | naturalearthdata.com\nTwitter: @alexadams385\nGitHub: AAdams149',
            x = 0.5,
            y = 0.03,
            size = 28,
            family = plotfont,
            color = 'white',
            lineheight = 0.3)

ggsave('day22_northnotup/day22_northnotup.png', height = 7, width = 7, units = 'in')

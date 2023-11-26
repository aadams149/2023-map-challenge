
library(cowplot)
library(dplyr)
library(geojsonsf)
library(sf)
library(showtext)

showtext_auto()
font_add_google('Montserrat Alternates')
plotfont <- 'Montserrat Alternates'

monaco <-
  st_read('day26_minimal/kontur_boundaries_MC_20230628.gpkg') %>%
  filter(admin_level == 11)

casino <-
  data.frame(
    lat = 43.7392869,
    lon = 7.4272277
  ) %>%
  st_as_sf(coords = c('lon','lat'),
           crs = st_crs(monaco)) %>%
  mutate(name = 'Monte Carlo Casino')

map <-
  ggplot() +
  geom_sf(data = monaco,
          aes(fill = population)) +
  scale_fill_gradient(low = '#FFFFFF',
                      high = 'red',
                      name = 'Population') +
  geom_sf(data = casino,
          size = 2,
          color = 'black',
          aes(shape = name),
          fill = 'white') +
  scale_shape_manual(name = '',
                     values = 23) +
  geom_sf_label(data = monaco,
             aes(label = name,
                 family = plotfont),
             size = 9) +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#274374',
                                   color = '#274374'),
    panel.background = element_rect(fill = '#274374',
                                    color = '#274374'),
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
    # legend.key.size = unit(0.5,'cm'),
    legend.box.margin = margin(0,0,0,0),
    plot.margin = margin(t = 25,
                         r = 15,
                         b = 25,
                         l = 15),
    legend.position = c(0.3, 0.7),
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
  draw_text('Municipalities in Monaco', 
            x = 0.5,
            y = 0.97,
            size = 44,
            family = plotfont,
            color = 'white') +
  draw_text('2023 30-Day Mapping Challenge Day 26: Minimal\nAlexander Adams',
            x = 0.5,
            y = 0.92,
            size = 32,
            family = plotfont,
            color = 'white',
            lineheight = 0.3) +
  draw_text('Data: Humanitarian Data Exchange\nTwitter: @alexadams385\nGitHub: AAdams149',
            x = 0.5,
            y = 0.03,
            size = 28,
            family = plotfont,
            color = 'white',
            lineheight = 0.3)
  

ggsave('day26_minimal/day26_minimal.png')

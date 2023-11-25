
library(dplyr)
library(gganimate)
library(ggplot2)
library(gifski)
library(readr)
library(sf)
library(showtext)
library(tidyr)
library(tigris)

options(scipen = 999)

#NOTE: NEEDS TO BE THIS VERSION OF TRANSFORMR OR CODE WON;T WORK
#devtools::install_version("transformr", version = "0.1.3")

showtext_auto()
font_add_google('Quattrocento')
plotfont <- 'Quattrocento'

mean_pop <-
  read_csv('day23_3d/mean_pop.csv') %>%
  mutate(lon = -1*lon) %>%
  st_as_sf(coords = c('lon',
                      'lat'),
           crs = 4326) %>%
  select('year' = `US Census`)

states <-
  tigris::states() %>%
  tigris::shift_geometry() %>%
  filter(!(NAME %in% c('Commonwealth of the Northern Mariana Islands',
                       "United States Virgin Islands",
                       'Guam',
                       'American Samoa'))) %>%
  select('Name' = NAME) %>%
  st_transform(crs = 4326)

state_pop <-
  read_csv('day23_3d/state_pop.csv') %>%
  filter(!(Name %in% c('Commonwealth of the Northern Mariana Islands',
                       "U.S. Virgin Islands",
                       'Guam',
                       'American Samoa'))) %>%
  pivot_longer('1790':'2020',names_to = 'year') %>%
  mutate(year = as.numeric(year)) %>%
  left_join(states, by = 'Name') %>%
  st_as_sf() %>%
  st_transform(crs = 4326)

options(gganimate.dev_args = list(width = 5, height = 7, units = 'in', res=320))

static_plot <- 
  ggplot() +
  geom_sf(data = state_pop,
               color = "black",
               aes(fill = value,
                   geometry = geometry)) +
  scale_fill_gradient(low = '#FFFFFF',
                      high = '#002147',
                      name = "Population") +
  guides(fill = 'none') +
  coord_sf(crs = st_crs(state_pop), datum = 'WGS84') +
  geom_sf(data = mean_pop,
          color = '#BF0A30',
          size = 2.5,
          aes(geometry = geometry)) +
  scale_color_manual(name = 'Mean Center of Population',
                     values = '#BF0A30') +
  theme_void() +
  labs(title="State Population in {frame*10+1780}\n2023 30-Day Mapping Challenge Day 23: 3-D\nAlexander Adams",
       caption = 'Data: Wikipedia\nTwitter: @alexadams385\nGithub: AAdams149') +
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
                               size = 18),
    legend.title = element_text(color = 'white',
                                size = 18),
    plot.margin = margin(t = 15,
                         r = 15,
                         b = 15,
                         l = 15),
    legend.position = c(0.85, 0.3),
    plot.caption = element_text(color = 'white',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.8),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

animate_plot <- static_plot +
  transition_manual(frames = year)

animate(animate_plot, nframes = 240)

anim_save('day23_3d/day23_3d.gif')

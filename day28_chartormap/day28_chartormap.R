
library(cowplot)
library(dplyr)
library(ggiraph)
library(ggplot2)
library(patchwork)
library(readr)
library(sf)
library(showtext)
library(tigris)

showtext_auto()
font_add_google('Suravaram')
plotfont <- 'Suravaram'

state_abb_key <-
  cbind.data.frame(state.name,
                   state.abb
  ) %>%
  bind_rows(
    data.frame(
      state.name = c('District of Columbia',
                     'Puerto Rico'),
      state.abb = c('DC',
                    'PR')
    )
  ) %>%
  rename('NAME' = state.name,
         'abbr' = state.abb)

data <-
  read_csv('day28_chartormap/oct_temp.csv') %>%
  select('NAME' = Name,
         Value) %>%
  left_join(state_abb_key)

states <-
  tigris::states() %>%
  shift_geometry() %>%
  select(NAME) %>%
  filter(NAME %in% unique(data$NAME)) %>%
  left_join(data)

map <-
  ggplot() +
  geom_sf_interactive(data = states,
          color = '#000000',
          aes(fill = Value,
              data_id = NAME,
              tooltip = paste0(NAME,
                               ': ',
                               Value,'°F'))) +
  guides(fill = 'none') +
  ggtitle('U.S. States by Average Temperature (°F), October 2023',
          subtitle = '2023 30-Day Mapping Challenge Day 28: Chart or Map?\nAlexander Adams') +
  labs(caption = 'Data: National Centers for Environmental Information |\nNational Weather Service |\nworld-weather.info\nTwitter: @alexadams385\nGitHub: AAdams149') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF',
                                   color = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF',
                                    color = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'white',
      size = 24,
      lineheight = 0.5
    ),
    legend.text = element_text(
      color = 'black',
      family = plotfont,
      size = 18
    ),
    legend.title = element_text(
      color = 'black',
      family = plotfont,
      size = 18,
      lineheight = 0.3
    ),
    legend.direction = 'horizontal',
    legend.box = 'horizontal',
    legend.box.margin = margin(0, 0, 0, 0),
    plot.margin = margin(
      t = 25,
      r = 15,
      b = 25,
      l = 15
    ),
    legend.position = c(0.5, 0.1),
    plot.caption = element_text(
      color = 'black',
      hjust = 0.5,
      size = 10,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

bar <-
  ggplot(data = states) +
  geom_bar_interactive(stat = 'identity',aes(
                           x = Value,
                           y = reorder(NAME,-Value),
                           fill = Value,
                           color = Value,
                           data_id = NAME,
                           tooltip = paste0(NAME,': ',Value,'°F'))) +
  guides(color = 'none') +
  guides(fill = 'none') +
  labs(y = 'State',
       x = 'Average Temperature (F), October 2023') +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF',
                                   color = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF',
                                    color = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'black',
      size = 24,
      lineheight = 0.5
    ),
    legend.text = element_text(
      color = 'black',
      family = plotfont,
      size = 18
    ),
    legend.title = element_text(
      color = 'black',
      family = plotfont,
      size = 18,
      lineheight = 0.3
    ),
    legend.box = 'horizontal',
    legend.box.margin = margin(0, 0, 0, 0),
    plot.margin = margin(
      t = 25,
      r = 15,
      b = 25,
      l = 15
    ),
    legend.position = c(0.92, 0.5),
    plot.caption = element_text(
      color = 'white',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.y = element_text(family = plotfont,
                               size = 3),
    axis.line = element_blank()
  )

output <-
  girafe(ggobj = wrap_plots(bar, map, widths = c(4, 8), heights = c(12, 12),
                          ncol = 2),
       options = list(
         opts_hover(css = ""),
         opts_hover_inv(css = "opacity:0.25;")
       ))

htmlwidgets::saveWidget(output, 'day28_chartormap/day28_chartormap.html')

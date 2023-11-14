
library(cowplot)
library(dplyr)
library(ggplot2)
library(readr)
library(sf)
library(showtext)
library(tigris)

legislature_data <- 
    read_csv('day13_choropleth/state_legislature_data.csv')

showtext_auto()
font_add_google('Shippori Mincho')
plotfont <- 'Shippori Mincho'

state_shapes <-
  tigris::states() %>%
  filter(NAME %in% legislature_data$state) %>%
  left_join(legislature_data,
            by = c('NAME' = 'state')) %>%
  mutate('bills_per' = bills_count_21/Total_Size)

states_bbox <-
  c(xmin = -124.8,
    ymin = -14.59,
    xmax = -63,
    ymax = 50)

lower48 <-
  state_shapes %>%
  filter(!(NAME %in% c('Alaska',
                              'Hawaii'))) %>%
  st_crop(y = states_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = bills_per),
          color = 'black') +
  scale_fill_gradient(name = 'Bills Introduced \nper Legislator',
                      high = '#02730e',
                      low = '#c7d6c9') +
  ggtitle('Bills Introduced per Member of State Legislature, 2021',
          subtitle = '2023 30-Day Mapping Challenge Day 13: Choropleth\nAlexander Adams') +
  labs(caption = "Data Source: FiscalNote | Wikipedia\nTwitter: @alexadams385\nGitHub: AAdams149") +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24,
                              lineheight = 0.5),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(1.02, 0.3),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.5),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

alaska_bbox <-
  c('xmin' = -179.22855,
    'ymin' = 51.17509,
    'xmax' = -129.97665,
    'ymax' = 71.43676)

alaska <-
  state_shapes %>%
  filter(NAME == 'Alaska') %>%
  st_crop(y = alaska_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = bills_per),
          color = 'black') +
  scale_fill_gradient(name = 'Bills Introduced \nper Legislator',
                      high = '#02730e',
                      low = '#c7d6c9') +
  guides(fill = 'none') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24,
                              lineheight = 0.5),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(1.05, 0.3),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.5),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

hawaii_bbox <-
  c('xmin' = -160.59294,
    'ymin' = 18.91924,
    'xmax' = -154.75717,
    'ymax' = 22.28536)

hawaii <-
  state_shapes %>%
  filter(NAME == 'Hawaii') %>%
  st_crop(y = hawaii_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = bills_per),
          color = 'black') +
  scale_fill_gradient(name = 'Bills Introduced \nper Legislator',
                      high = '#02730e',
                      low = '#c7d6c9') +
  guides(fill = 'none') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24,
                              lineheight = 0.5),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(1.05, 0.3),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.5),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggdraw() +
  draw_plot(lower48) +
  draw_plot(alaska, x = -0.41, y = 0.225, height = 0.15) +
  draw_plot(hawaii, x = -0.225, y = 0.225, height = 0.11)

ggsave('day13_choropleth/day13_choropleth.png')

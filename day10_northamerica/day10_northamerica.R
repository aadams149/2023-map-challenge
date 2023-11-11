
library(cowplot)
library(dplyr)
library(ggplot2)
library(readr)
library(sf)
library(showtext)
library(stringr)
library(tigris)

showtext_auto()
font_add_google('Kameron')
plotfont <- 'Kameron'

data <-
  read_csv('https://raw.githubusercontent.com/aadams149/ppol683_fall2021_project/main/data/raw/counties_with_tweets.csv') %>%
  mutate(statefips = str_sub(fips,1,2)) %>%
  select(fips,
         state_full,
         socmed,
         statefips)

counties <-
  tigris::counties() %>%
  st_simplify(dTolerance = 3e3) %>%
  st_crop(y = c(xmin = -179.22855,
                ymin = -14.59707,
                xmax = -63,
                ymax = 71.43676)) %>%
  filter(STATEFP %in% data$statefips) %>%
  left_join(data,
            by = c('GEOID' = 'fips')) %>%
  select(state_full,
         socmed)

states <- state.name
states = states[grep('Alaska|Hawaii',states, invert = TRUE)]

states_bbox <-
  c(xmin = -124.8,
    ymin = -14.59,
    xmax = -63,
    ymax = 50)

lower48 <-
  counties %>%
  filter(!(state_full  %in% c('Alaska',
                              'Hawaii'))) %>%
  st_crop(y = states_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = factor(socmed)),
          color = 'black') +
  scale_fill_manual(name = 'Social Media',
                    values = c('#003cff',
                               '#DAF7A6',
                               '#C70039',
                               '#FFC300')) +
  ggtitle('Social Media Accounts for U.S. County Health Departments as of December 2021',
          subtitle = '2023 30-Day Mapping Challenge Day 10: North America\nAlexander Adams') +
  labs(caption = "Data Source: Alexander Adams\nTwitter: @alexadams385\nGitHub: AAdams149") +
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

alaska_bbox <-
  st_bbox(counties %>% filter(state_full == 'Alaska'))

# alaska --------------------------------------------------------------

alaska <-
  counties %>%
  st_crop(y = alaska_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = factor(socmed))) +
  scale_fill_manual(
                                                        values = c('#003cff',
                                                                   '#DAF7A6',
                                                                   '#C70039',
                                                                   '#FFC300')) +
  guides(fill = 'none') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.5,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.87, 0.5),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )


# hawaii --------------------------------------------------------------



hawaii_bbox <-
  c('xmin' = -160.59294,
    'ymin' = 18.91924,
    'xmax' = -154.75717,
    'ymax' = 22.28536)

hawaii <-
  counties %>%
  filter(state_full == 'Hawaii') %>%
  st_crop(y = hawaii_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = factor(socmed))) +
  scale_fill_manual(
    values = c('#003cff',
               '#DAF7A6',
               '#C70039',
               '#FFC300')) +
  guides(fill = 'none') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.5,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.7, 0.5),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )


# draw and save -------------------------------------------------------

ggdraw() +
  draw_plot(lower48) +
  draw_plot(alaska, x = -0.41, y = 0.225, height = 0.15) +
  draw_plot(hawaii, x = -0.225, y = 0.225, height = 0.11)

ggsave('day10_northamerica/day10_northamerica.png')



library(cowplot)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(sf)
library(showtext)
library(tidycensus)
library(tidyr)
library(tigris)

showtext_auto()
font_add_google('Alice')
plotfont <- 'Alice'

vars <-
  tidycensus::load_variables(2020,
                             dataset = 'dp')

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
  tidycensus::get_decennial(
    geography = 'state',
    year = 2020,
    variables = c('DP1_0116C',
                  'DP1_0118C',
                  'DP1_0001C'),
    sumfile = 'dp'
  ) %>%
  pivot_wider(names_from = variable,
              values_from = value) %>%
  mutate(ss_couples = DP1_0116C + DP1_0118C,
         prop = (ss_couples / DP1_0001C) * 100,
         rank_ss = rank(desc(ss_couples)),
         rank_prop = rank(desc(prop))) %>%
  left_join(state_abb_key) %>%
  mutate(
    label_ss = case_when(rank_ss <= 5 ~ paste0('#',
                                               as.character(as.integer(rank_ss)),
                                               ': ',
                                               abbr,
                                               '\n(',ss_couples,')'),
                         rank_ss >= 48 ~ paste0('#',
                                               as.character(as.integer(rank_ss)),
                                               ': ',
                                               abbr,
                                               '\n(',ss_couples,')'),
                         TRUE ~ NA),
    label_prop = case_when(rank_prop <= 5 ~ paste0('#',
                                               as.character(as.integer(rank_prop)),
                                               ': ',
                                               abbr,
                                               '\n(',as.character(round(prop,3)),'%)'),
                         rank_prop >= 48 ~ paste0('#',
                                                as.character(as.integer(rank_prop)),
                                                ': ',
                                                abbr,
                                                '\n(',as.character(round(prop,3)),'%)'),
                         TRUE ~ NA))

states <-
  tigris::states() %>%
  shift_geometry() %>%
  select(NAME) %>%
  filter(NAME %in% unique(data$NAME)) %>%
  left_join(data)

map_prop <-
  ggplot() +
  geom_sf(data = states,
          color = '#000000',
          aes(fill = prop)) +
  geom_label_repel(data = states, aes(label = label_prop,
                                    lineheight = 0.5,
                                    geometry = geometry,
                                    family = plotfont),
                   size = 4,
                   stat = 'sf_coordinates',
                   min.segment.length = 0) +
  scale_fill_gradient(name = '% in Same-Gender\nRelationships',
                      low = '#FFFFFF',
                      high = '#FF07CF') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#274374',
                                   color = '#274374'),
    panel.background = element_rect(fill = '#274374',
                                    color = '#274374'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'white',
      size = 24,
      lineheight = 0.5
    ),
    legend.text = element_text(
      color = 'white',
      family = plotfont,
      size = 18
    ),
    legend.title = element_text(
      color = 'white',
      family = plotfont,
      size = 18,
      lineheight = 0.3
    ),
    legend.box = 'horizontal',
    legend.key.size = unit(0.2,'cm'),
    legend.key.width = unit(0.2,'cm'),
    legend.box.margin = margin(0, 0, 0, 0),
    plot.margin = margin(
      t = 25,
      r = 15,
      b = 25,
      l = 15
    ),
    legend.position = c(0.2, 0.5),
    plot.caption = element_text(
      color = 'white',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggdraw() +
  draw_plot(map_prop) +
  draw_text(
    'Americans in Same-Gender Partnerships, 2020',
    x = 0.5,
    y = 0.97,
    size = 44,
    family = plotfont,
    color = 'white'
  ) +
  draw_text(
    '2023 30-Day Mapping Challenge Day 29: Population\nAlexander Adams',
    x = 0.5,
    y = 0.90,
    size = 32,
    family = plotfont,
    color = 'white',
    lineheight = 0.3
  ) +
  draw_text(
    'Data: U.S. Census Bureau (2020 Decennial Census)\nTwitter: @alexadams385\nGitHub: AAdams149',
    x = 0.5,
    y = 0.07,
    size = 28,
    family = plotfont,
    color = 'white',
    lineheight = 0.3
  )

ggsave('day29_population/day29_population_proportion.png')

map_count <-
  ggplot() +
  geom_sf(data = states,
          color = '#000000',
          aes(fill = ss_couples)) +
  geom_label_repel(data = states, aes(label = label_ss,
                                      lineheight = 0.3,
                                      geometry = geometry,
                                      family = plotfont),
                   size = 4,
                   stat = 'sf_coordinates',
                   min.segment.length = 0) +
  scale_fill_gradient(name = '# in Same-Gender\nRelationships',
                      low = '#FFFFFF',
                      high = '#FF07CF') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#274374',
                                   color = '#274374'),
    panel.background = element_rect(fill = '#274374',
                                    color = '#274374'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'white',
      size = 24,
      lineheight = 0.5
    ),
    legend.text = element_text(
      color = 'white',
      family = plotfont,
      size = 18
    ),
    legend.title = element_text(
      color = 'white',
      family = plotfont,
      size = 18,
      lineheight = 0.3
    ),
    legend.box = 'horizontal',
    legend.key.size = unit(0.2,'cm'),
    legend.box.margin = margin(0, 0, 0, 0),
    plot.margin = margin(
      t = 25,
      r = 15,
      b = 25,
      l = 15
    ),
    legend.key.width = unit(0.2,'cm'),
    legend.position = c(0.2, 0.5),
    plot.caption = element_text(
      color = 'white',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggdraw() +
  draw_plot(map_count) +
  draw_text(
    'Americans in Same-Gender Partnerships, 2020',
    x = 0.5,
    y = 0.97,
    size = 44,
    family = plotfont,
    color = 'white'
  ) +
  draw_text(
    '2023 30-Day Mapping Challenge Day 29: Population\nAlexander Adams',
    x = 0.5,
    y = 0.90,
    size = 32,
    family = plotfont,
    color = 'white',
    lineheight = 0.3
  ) +
  draw_text(
    'Data: U.S. Census Bureau (2020 Decennial Census)\nTwitter: @alexadams385\nGitHub: AAdams149',
    x = 0.5,
    y = 0.07,
    size = 28,
    family = plotfont,
    color = 'white',
    lineheight = 0.3
  )



ggsave('day29_population/day29_population_count.png')

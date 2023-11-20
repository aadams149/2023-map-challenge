
library(cowplot)
library(dplyr)
library(rnaturalearth)
library(sf)
library(showtext)
library(tidyr)

showtext_auto()
font_add_google('Song Myung')
plotfont <- 'Song Myung'

songwriters <-
  read_csv('day17_flow/esc2023_songwriters.csv') %>%
  mutate('diff' = case_when(Country != Country_Origin ~ 1,
                            TRUE ~ 0))

diff_countries <-
  songwriters %>%
  filter(Country != Country_Origin)

country_list <-
  unique(c(diff_countries$Country,
    diff_countries$Country_Origin))

states <-
  c('California',
    'Québec')

state_shape <-
  rnaturalearth::ne_states(country = c('United States of America',
                                       'Canada'),
                           returnclass = 'sf') %>%
  filter(name %in% states) %>%
  select(name)

shape <-
  rnaturalearth::ne_countries(country = country_list,
                              returnclass = 'sf') %>%
  select(sovereignt) %>%
  filter(!(sovereignt %in% c('Canada',
                          'United States of America'))) %>%
  st_crop(y = c(xmin = -25,
                xmax = 55,
                ymin = 18,
                ymax = 72))

origin_points <-
  st_centroid(shape) %>%
  extract(geometry, c('lon', 'lat'), '\\((.*), (.*)\\)', convert = TRUE)

relationships <-
  diff_countries %>%
  left_join(origin_points %>%
              select('Country_Origin' = sovereignt,
                     'origin_lat' = lat,
                     'origin_lon' = lon),
            by = 'Country_Origin') %>%
  left_join(origin_points %>%
              select('Country' = sovereignt,
                     'result_lat' = lat,
                     'result_lon' = lon),
            by = 'Country') %>%
  filter(!is.na(result_lat) & !is.na(origin_lat))

b = relationships[, c("origin_lon", "origin_lat")]
names(b) = c("long", "lat")
e = relationships[, c("result_lon", "result_lat")]
names(e) = c("long", "lat")

relationships$geometry = do.call(
  "c", 
  lapply(seq(nrow(b)), function(i) {
    st_sfc(
      st_linestring(
        as.matrix(
          rbind(b[i, ], e[i, ])
        )
      ),
      crs = 4326
    )
  }))

relationships = st_as_sf(relationships)

songwriters_grouped <-
  songwriters %>%
  group_by(Country) %>%
  mutate(all_internal = case_when(sum(diff) > 0 ~ 'No',
                                  TRUE ~ 'Yes')) %>%
  select(Country, all_internal) %>%
  distinct()

europe <-
  rnaturalearth::ne_countries(country = songwriters_grouped$Country,
                              returnclass = 'sf') %>%
  st_crop(y = c(xmin = -25,
                xmax = 55,
                ymin = 0,
                ymax = 72)) %>%
  select('name' = sovereignt) %>%
  bind_rows(
  st_read('day4_badmap/world-administrative-boundaries.shp') %>%
  filter(name %in% c('Malta','San Marino')) %>%
    select(name)) %>%
  left_join(songwriters_grouped, by = c('name' = 'Country'))
  
europe_map <-
  ggplot() +
  geom_sf(data = europe, aes(fill = factor(all_internal))) +
  scale_fill_manual(name = 'All Internal?',
                    values = c('#FEF900', '#FF0185')) +
  geom_sf(
    data = relationships,
    size = 2,
    arrow = arrow(angle = 30,
                  ends = "last",
                  type = "open"),
    color = '#0043FE',
    linewidth = 0.4
  ) +ggtitle(
    'Doing Things In-House: National Origins of Songwriters \nfor the 2023 Eurovision Song Contest',
    subtitle = '2023 30-Day Mapping Challenge Day 17: Flow'
  ) +
  labs(caption = "Data Source: @EMursiya (Twitter) | Wikipedia\nTwitter: @alexadams385\nGitHub: AAdams149") +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'black',
      size = 24,
      lineheight = 0.4
    ),
    plot.subtitle = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18
    ),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.9, 0.8),
    plot.caption = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )


# buffer section ------------------------------------------------------


# aus map -------------------------------------------------------------

australia <-
  rnaturalearth::ne_countries(country = 'Australia',
                              returnclass = 'sf') %>%
  select(sovereignt)

australia_map <-
  ggplot() +
  geom_sf(data = australia,
          fill = '#FF0185') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'black',
      size = 24,
      lineheight = 0.5
    ),
    plot.subtitle = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18
    ),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.85, 0.8),
    plot.caption = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )


# cali map ------------------------------------------------------------

cali_map <-
  ggplot() +
  geom_sf(data = state_shape %>% filter(name == 'California'), fill = '#FFFFFF') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'black',
      size = 24,
      lineheight = 0.5
    ),
    plot.subtitle = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18
    ),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.82, 0.8),
    plot.caption = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )


# quebec map ----------------------------------------------------------

quebec_map <-
  ggplot() +
  geom_sf(data = state_shape %>% filter(name != 'California'), fill = '#FFFFFF') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'black',
      size = 24,
      lineheight = 0.5
    ),
    plot.subtitle = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18
    ),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.82, 0.8),
    plot.caption = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )




# san marino map ------------------------------------------------------

sm_map <-
  ggplot() +
  geom_sf(data = europe %>% filter(name == 'San Marino'), fill = '#FEF900') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    legend.title.align = 0.1,
    plot.title = element_text(
      hjust = 0.5,
      color = 'black',
      size = 24,
      lineheight = 0.5
    ),
    plot.subtitle = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18
    ),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.82, 0.8),
    plot.caption = element_text(
      color = 'black',
      hjust = 0.5,
      size = 18,
      lineheight = 0.8
    ),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )


# put it all together -------------------------------------------------


ggdraw() +
  draw_plot(europe_map) +
  draw_plot(sm_map, scale = 0.05, x = 0, y = -0.35) +
  draw_plot(australia_map, scale = 0.15, x = -0.4, y = -0.3) +
  draw_plot(cali_map, scale = 0.15, x = -0.4, y = -0.1) +
  draw_plot(quebec_map, scale = 0.15, x = -0.4, y = 0.1) +
  # arrow from cali to netherlands
  draw_line(x = c(0.12, 0.41), y = c(0.37, 0.55), arrow = arrow(angle = 30,
                                                               ends = "last",
                                                               type = "open"),
            color = '#0043FE',
            linewidth = 0.4) +
  # arrow from quebec to france
  draw_line(x = c(0.07, 0.4), y = c(0.55, 0.42), arrow = arrow(angle = 30,
                                                              ends = "last",
                                                              type = "open"),
            color = '#0043FE',
            linewidth = 0.4) +
  # arrow from italy to san marino
  draw_line(x = c(0.51, 0.5), y = c(0.35, 0.16), arrow = arrow(angle = 30,
                                                                ends = "last",
                                                                type = "open"),
            color = '#0043FE',
            linewidth = 0.4) +
  # draw line for legend
  draw_line(x = c(0.77, 0.87), y = c(0.62, 0.62), arrow = arrow(angle = 30,
                                                               ends = "last",
                                                               type = "open"),
            color = '#0043FE',
            linewidth = 0.4) +
  draw_text('Foreign Songwriter', x = 0.82, y = 0.65, size = 18, family = plotfont)
  

ggsave('day17_flow/day17_flow.png')

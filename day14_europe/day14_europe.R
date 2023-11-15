
library(dplyr)
library(readr)
library(sf)
library(showtext)
library(tmap)
library(tmaptools)

showtext_auto()
font_add_google('Wellfleet')
plotfont <- 'Wellfleet'

esc <-
  read_csv('day14_europe/esc_hostcities.csv') %>%
  mutate(Country = case_when(Country == 'Yugoslavia' ~ 'Croatia',
                             TRUE ~ Country)) %>%
  left_join(tidygeocoder::geo(city = esc$City,
                  country = esc$Country),
            by = c('City' = 'city',
                   'Country' = 'country')) %>%
  st_as_sf(coords = c('long',
                      'lat')) %>%
  distinct()

europe <-
  st_read('day4_badmap/world-administrative-boundaries.shp') %>%
  filter(continent == 'Europe' | name %in% c('Russia',
                                             'Turkey',
                                             'Armenia',
                                             'Georgia',
                                             'Azerbaijan',
                                             'Israel')) %>%
  st_crop(y = c(xmin = -25,
                xmax = 55,
                ymin = 0,
                ymax = 72))

esc1 <-
  esc %>%
  mutate(popup_text = paste0("<a href = ",
                             Winner,
                             "/>",
                             Year,
                             "</a>")) %>%
  group_by(City) %>%
  mutate(popup_grouped = paste0(popup_text, collapse = ', '),
         city_text = paste0(City, ', ', Country),
         'Times Hosted' = n()/10,
         most_recent_decade = case_when(max(Year) < 1960 ~ '1950s',
                                        max(Year) < 1970 & max(Year) >= 1960 ~ '1960s',
                                        max(Year) < 1980 & max(Year) >= 1970 ~ '1970s',
                                        max(Year) < 1990 & max(Year) >= 1980 ~ '1980s',
                                        max(Year) < 2000 & max(Year) >= 1990 ~ '1990s',
                                        max(Year) < 2010 & max(Year) >= 2000 ~ '2000s',
                                        max(Year) < 2020 & max(Year) >= 2010 ~ '2010s',
                                        max(Year) < 2030 & max(Year) >= 2020 ~ '2020s')) %>%
  ungroup()

palette <-
  c('#ffadad', '#ffd6a5', '#fdffb6', '#caffbf', '#9bf6ff', '#a0c4ff', '#bdb2ff','#ffc6ff')

tmap_mode('view')

map <-
  tm_shape(europe) +
  tm_borders('black') +
  tm_shape(esc1) +
  tm_dots(col = 'most_recent_decade',
          palette = palette,
          id = 'City',
          size = 'Times Hosted',
          popup.vars = c('City: ' = 'city_text',
                          'Years Hosted: ' = 'popup_grouped'),
          popup.format = list(html.escape = F),
          title = 'Most Recent Hosting') +
  tm_layout(main.title = 'Eurovision Song Contest Host Cities, 1956-2024\n2023 30-Day Mapping Challenge Day 14: Europe\nAlexander Adams',
            legend.outside = TRUE,
            legend.outside.position = 'right',
            fontfamily = 'Wellfleet') +
  tm_credits('Data: Wikipedia\nTwitter: @alexadams385\nGitHub: AAdams149')

tmap_save(map, 'day14_europe/day14_europe.html')
tmap_save(map, 'day14_europe/day14_europe.png')

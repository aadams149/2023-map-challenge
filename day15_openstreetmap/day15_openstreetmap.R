
library(dplyr)
library(ggspatial)
library(readr)
library(sf)
library(showtext)
library(tidyr)
library(tigris)

showtext_auto()
font_add_google('Castoro')
plotfont <- "Castoro"


dc <-
  tigris::counties('DC')

museums <-
  read_csv('day15_openstreetmap/Museums.csv')

metro <-
  read.csv(
    'https://raw.githubusercontent.com/aadams149/portfolio/main/Coursework/dc_metro_lines.csv'
  ) %>%
  st_as_sf(coords = c('Lon',
                      'Lat'),
           crs = st_crs(dc)) %>%
  st_crop(st_bbox(dc)) %>%
  select(Name,
         LineCode1,
         LineCode2,
         LineCode3,
         LineCode4,
         LineCode5) %>%
  mutate(
    LineCode2 =  case_when(LineCode2 == '---' ~ NA,
                           TRUE ~ LineCode2),
    LineCode3 =  case_when(LineCode3 == '---' ~ NA,
                           TRUE ~ LineCode3),
    LineCode4 =  case_when(LineCode4 == '---' ~ NA,
                           TRUE ~ LineCode4),
    LineCode5 =  case_when(LineCode5 == '---' ~ NA,
                           TRUE ~ LineCode5),
    Type = 'Museum'
  ) %>%
  unite(
    'stations',
    LineCode1,
    LineCode2,
    LineCode3,
    LineCode4,
    LineCode5,
    sep = '|',
    remove = FALSE,
    na.rm = TRUE
  ) %>%
  select(Name,
         stations,
         Type)

museums <-
  museums %>%
  anti_join(museums %>% filter(
    stringr::str_detect(
      DCGISPLACE_NAMES_PTNAME,
      'NATIONAL ZOO |US NATIONAL ARBORETUM [^P]|ART SCULPTURE GARDEN [IC]'
    )
  )) %>%
  distinct(DCGISADDRESSES_PTADDRESS, .keep_all = TRUE) %>%
  st_as_sf(coords = c('X', 'Y'),
           crs = st_crs(dc)) %>%
  mutate('stations' = NA,
         'Type' = 'Metro Stop') %>%
  select('Name' = DCGISPLACE_NAMES_PTNAME,
         stations,
         'Type')

museums <-
  museums %>%
  bind_rows(metro)

ggplot() +
  annotation_map_tile(zoom = 13,
                      cachedir = system.file("rosm.cache", package = "ggspatial")) +
  geom_sf(data = dc,
          alpha = 0,
          color = 'black') +
  geom_sf(data = museums,
          aes(color = factor(Type),
              text = stringr::str_to_title(Name))) +
  scale_color_manual(name = 'Legend',
                     values = c('red',
                                'blue'),
                     labels = c('Museum',
                                'Metro Stop')) +
  ggtitle('Museums and Metro Stops in Washington, D.C.',
          subtitle = '2023 30-Day Mapping Challenge Day 15: OpenStreetMap\nAlexander Adams') +
  labs(caption = 'Data Source: opendata.dc.gov | Washington Metropolitan Transit Authority\nTwitter: @alexadams385\nGitHub: AAdams149') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    legend.title.align = 0.5,
    plot.title = element_text(hjust = 0.5,
                              lineheight = 0.8,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'black',
                               size = 12),
    legend.background = element_rect(fill = '#FFE8D1'),
    legend.title = element_text(color = 'black',
                                size = 14),
    legend.margin = margin(5, 10, 5, 10),
    legend.position = c(0.15, 0.2),
    plot.caption = element_text(color = 'black',
                                lineheight = 0.8,
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 

ggsave('day15_openstreetmap/day15_openstreetmap.png')

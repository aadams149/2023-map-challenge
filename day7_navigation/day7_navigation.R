
library(dplyr)
library(sf)
library(showtext)
library(tidyr)

showtext_auto()
font_add_google("Metrophobic")
plotfont <- "Metrophobic"

bbox <-
  c(xmin = -77.1198,
    ymin = 38.889805,
    xmax = -77.009056,
    ymax = 38.99597)

dc_neighborhoods <-
  st_read('day7_navigation/Neighborhood_Clusters.shp') %>%
  st_crop(y = bbox)

metro <-
  read.csv('https://raw.githubusercontent.com/aadams149/portfolio/main/Coursework/dc_metro_lines.csv') %>%
  st_as_sf(coords = c('Lon',
                      'Lat'),
           crs = st_crs(dc_neighborhoods),
           remove = FALSE) %>%
  mutate(index = rownames(.))

colnames(metro)[1] <- 'code'

dc_neighborhoods$nearest_metro <-
  st_nearest_feature(dc_neighborhoods,
                     metro)

dc_neighborhoods$nearest_metro <-
  as.character(dc_neighborhoods$nearest_metro)

dc_neighborhoods <-
  metro %>%
  st_drop_geometry() %>%
  select(Name,
         LineCode1,
         LineCode2,
         LineCode3,
         LineCode4,
         LineCode5,
         index) %>%
  right_join(dc_neighborhoods,
             by = c('index' = 'nearest_metro'))
metro <-
  metro %>%
  mutate(Name = case_when(Name == 'Woodley Park-Zoo/Adams Morgan' ~ 'Adams Morgan',
                          Name == 'Rhode Island Ave-Brentwood' ~ 'Brentwood',
                          Name == 'U Street/African-Amer Civil War Memorial/Cardozo' ~ 'U Street',
                          Name == 'Georgia Ave-Petworth' ~ 'Petworth',
                          Name == 'Navy Yard-Ballpark' ~ 'Navy Yard',
                          TRUE ~ Name),
         LineCode2 =  case_when(LineCode2 == '---' ~ NA,
                                TRUE ~ LineCode2),
         LineCode3 =  case_when(LineCode3 == '---' ~ NA,
                                TRUE ~ LineCode3),
         LineCode4 =  case_when(LineCode4 == '---' ~ NA,
                                TRUE ~ LineCode4),
         LineCode5 =  case_when(LineCode5 == '---' ~ NA,
                                TRUE ~ LineCode5)
         ) %>%
  unite('stations',
        LineCode1,
        LineCode2,
        LineCode3,
        LineCode4,
        LineCode5,
        sep = '|',
        remove = FALSE,
        na.rm = TRUE)

metrolines <-
  metro %>%
  filter(index %in% dc_neighborhoods$index & !(Name == 'Union Station')) %>%
  mutate(leg = substr(code,1,1)) %>%
  group_by(stations, leg) %>%
  arrange(leg,Order) %>%
  summarize(stations = unique(stations)[1],
            do_union = FALSE) %>%
  filter(leg != 'D') %>%
  st_cast('LINESTRING')

ggplot() +
  geom_sf(data = dc_neighborhoods, aes(geometry = geometry,
                                       fill = factor(LineCode1)),
          color = '#000000') +
  scale_fill_manual(name = 'Metro Line',
                    values = c('#009CDE',
                               '#00B140',
                               '#BF0D3E'),
                    labels = c('Blue|Orange|Silver',
                               'Green|Yellow',
                               'Red')) +
  # geom_label_repel(data = dc_neighborhoods,
  #               aes(label = paste0(NBH_NAMES,
  #                                  '\n(',
  #                                  Name,
  #                                  ': ',
  #                                  stations,
  #                                  ')'),
  #                   geometry = geometry,
  #                   lineheight = 0.7),
  #               stat = 'sf_coordinates') +
  geom_sf(data = metro %>%
            filter(index %in% dc_neighborhoods$index &
                   !(Name == 'Union Station')), aes(geometry = geometry,
                                                           size = 2)) +
  geom_sf(data = metrolines,
          linewidth = 1) +
  geom_label_repel(data = metro %>%
                  filter(index %in% dc_neighborhoods$index),
                aes(label = paste0(Name,
                                   '\n(',
                                   stations,
                                   ')'),
                    x = Lon,
                    y = Lat,
                    lineheight = 0.8)) +
  
  guides(size = FALSE) +
  guides(color = FALSE) +
  ggtitle('Closest Metro Line in Northwest D.C.',
          subtitle = '2023 30-Day Mapping Challenge Day 7: Navigation\nAlexander Adams') +
  labs(caption = 'Data Source: opendata.dc.gov\nTwitter: @alexadams385\nGitHub: AAdams149') +
  
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = 'white',
                                   color = 'white'),
    legend.title.align = 0.5,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'black'),
    legend.title = element_text(color = 'black'),
    legend.position = c(0.2, 0.8),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 14),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 

ggsave('day7_navigation/day7_navigation.png')

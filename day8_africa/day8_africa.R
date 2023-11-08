
library(dplyr)
library(ggnewscale)
library(ggrepel)
library(readr)
library(sf)
library(showtext)
library(tidyr)


showtext_auto()
font_add_google("Comfortaa")
plotfont <- "Comfortaa"


sa <-
  st_read('day8_africa/ZAF_adm0.shp')

sa_mun <-
  st_read('day8_africa/MDB_Local_Municipal_Boundary_2018.shp')

rain <-
  read_csv('day8_africa/Mean_annual_precipitation_across_South_African_municipalities_from_1983_-_2020.csv') %>%
  select(dtr_statio,
    lat,
         lon,
         F1983:F2000) %>%
  mutate(mean = rowMeans(subset(., select = c(F1983:F2000)), na.rm = TRUE)) %>%
  st_as_sf(coords = c('lon',
                      'lat'),
           remove = FALSE,
           crs = st_crs(sa)) 
rain <-
  rain %>%
  mutate(in_bounds = lengths(st_within(rain, sa))) %>%
  filter(in_bounds == 1) %>%
  mutate(
    label = case_when(mean == max(mean) ~ paste0('Max Rainfall: \n',
                                                 round(mean,2),
                                                 ' (',
                                                 stringr::str_to_title(dtr_statio),
                                                 ')'),
                      mean >= sort(mean,TRUE)[5] & mean < max(mean) ~ paste0('High Rainfall: \n',
                                                                             round(mean,2),
                                                                             ' (',
                                                                             stringr::str_to_title(dtr_statio),
                                                                             ')'),
                      mean == min(mean) ~ paste0('Min Rainfall: \n',
                                                 round(mean,2),
                                                 ' (',
                                                 stringr::str_to_title(dtr_statio),
                                                 ')'),
                      mean <= sort(mean,FALSE)[5] ~ paste0('Low Rainfall: \n',
                                                           round(mean,2),
                                                           ' (',
                                                           stringr::str_to_title(dtr_statio),
                                                           ')'),
                      TRUE ~ NA),
    maxmin = case_when(mean >= sort(mean,TRUE)[5] ~ 'max',
                       mean <= sort(mean,FALSE)[5] ~ 'min',
                       TRUE ~ NA))

rm(sa)

sa_mun <-
  sa_mun %>%
  st_join(rain, join = st_intersects)

ggplot() +
  geom_sf(data = sa_mun, aes(fill = mean),
          color = '#FFB612') +
  scale_fill_continuous(low = '#000000', high = '#698cff',
                        name = 'Avg. Annual Rainfall (mm/year)') +
  ggnewscale::new_scale_fill() +
  geom_label_repel(data = rain, aes(label = label,
                                 lineheight = 0.5,
                                 geometry = geometry,
                                 fill = factor(maxmin),
                                 family = plotfont),
                   stat = 'sf_coordinates',
                   min.segment.length = 0) +
  scale_fill_manual(values = c('#007A4D','#DE3831'),
                    guide = 'none') +
  ggtitle('Average Annual Rainfall Across South African Municipalities, 1983-2000',
          subtitle = '2023 30-Day Mapping Challenge Day 8: Africa\nAlexander Adams') +
  labs(caption = 'Data Source: South African Environmental Observation Network (SAEON)\nTwitter: @alexadams385\nGitHub: AAdams149') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFB612'),
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
    legend.position = c(0.25, 0.82),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 

ggsave('day8_africa/day8_africa.png')



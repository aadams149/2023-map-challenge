
library(cowplot)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(readr)
library(rnaturalearth)
library(sf)
library(showtext)
library(tidygeocoder)
library(tidyr)

showtext_auto()
font_add_google('Inika')
plotfont <- 'Inika'

nz_sheep <-
  st_read('day16_oceania/livestock-numbers-grid-aps-2017.shp') %>%
  select(sheep)

nz <-
  rnaturalearth::ne_countries(country = 'New Zealand',
                              returnclass = 'sf')

rams <-
  read_csv('day16_oceania/rams2017.csv')

stadiums <-
  tidygeocoder::geo(rams$stadium) %>%
  drop_na(lat)

ilt_stadium <- data.frame('address' = 'ILT Stadium Southland',
  'lat' = -46.4068822,
                 'long' = 168.3789951)

asb <-
  data.frame('address' = 'ASB Baypark Arena',
    'lat' = -35.1854188,
    'long' = 173.1762046)

stadiums1 <-
  stadiums %>%
  bind_rows(data.frame(ilt_stadium),
             data.frame(asb)) %>%
  distinct() %>%
  right_join(rams,
             by = c('address' = 'stadium')) %>%
  mutate(rams_ratio = rams_score/opponent_score,
         lat = case_when(address == 'Trafalgar Centre' ~ -41.267711,
                         TRUE ~ lat),
         long = case_when(address == 'Trafalgar Centre'~ 173.2794479,
                          TRUE ~ long)) %>%
  group_by(address, .drop = FALSE) %>%
  mutate(mean_ratio = mean(rams_ratio)) %>%
  ungroup() %>%
  st_as_sf(coords = c('long','lat'),
           crs = st_crs(nz)) %>%
  select(address,
         mean_ratio,
         geometry) %>%
  distinct()



sheep_map <-
  ggplot() +
  geom_sf(data = nz_sheep, aes(fill = sheep)) +
  scale_fill_gradient(low = '#FFFFFF',
                      high = '#709efa',
                      name = '# of Sheep') +
  ggtitle('Counts of Sheep in New Zealand, 2017') +
  labs(caption = 'Data: data.mfe.govt.nz')+
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 20),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.title.align = 0.2,
    legend.position = c(0.25, 0.75),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 



rams_map <-
  ggplot() +
  geom_sf(data = nz, aes(alpha = 0),
          fill = 'white',
          color = 'black') +
  geom_sf(data = stadiums1) +
  geom_label_repel(data = stadiums1,
                   aes(label = paste0(address,
                                      '\nAvg Pts. Agnst:',
                                      round(mean_ratio,2)),
                       fill = mean_ratio,
                       lineheight = 0.3,
                       geometry = geometry,
                       family = plotfont),
                   stat = "sf_coordinates",
                   min.segment.length = 0) +
  ggtitle('Avg. Points Scored at Different Stadiums\nby the Canterbury Rams, 2017') +
  labs(caption = 'Data: nznbl.basketball/stats') +
  scale_fill_gradient2(low = '#f1807e',
                       mid = '#FFFFFF',
                       midpoint = 1,
                       high = '#709efa',
                       name = 'Score Ratio') +
  guides(alpha = 'none') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#FFFFFF'),
    panel.background = element_rect(fill = '#FFFFFF'),
    plot.title = element_text(hjust = 0.5,
                              lineheight = 0.3,
                              color = 'black',
                              size = 20),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18,
                               family = plotfont),
    legend.title = element_text(color = 'black',
                                size = 18,
                                family = plotfont),
    legend.title.align = 0.2,
    legend.position = c(0.3, 0.75),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggdraw() +
  draw_plot(sheep_map,
            x = 0.03,
            width = 0.43,
            height = 0.9) +
  draw_plot(rams_map,
            x = 0.52,
            width = 0.43,
            height = 0.90) +
  draw_text('2023 30-Day Mapping Challenge Day 16: Oceania\nAlexander Adams\nTwitter: @alexadams385 | GitHub: AAdams149',
            y = 0.90,
            size = 24,
            family = plotfont,
            lineheight = 0.7) 

ggsave('day16_oceania/day16_oceania.png')



# load libraries ------------------------------------------------------

library(dplyr)
library(ggnewscale)
library(ggplot2)
library(sf)
library(showtext)
library(tidygeocoder)


# Preprocess Han River shapefile -------------------------------------

# Download data from https://data.apps.fao.org/catalog/iso/dc2a5121-0b32-482b-bd9b-64f7a414fa0d

# Click: Download - Rivers of South and East Asia (ESRI shapefile)
# Huge file, so filter to what I want, write that, delete the rest

# rivers <-
#   sf::st_read('day6_asia/rivers_asia_37331.shp')
# 
# han_river <-
#   rivers %>%
#   filter(SUB_NAME == 'Han gang')
# 
# st_write(han_river,
#          'day6_asia',
#          'han_river',
#          driver = "ESRI Shapefile")

# rm(rivers)


# set font ------------------------------------------------------------


showtext_auto()
font_add_google("Single Day")
plotfont <- "Single Day"


# set bbox ------------------------------------------------------------

bbox <- c(xmin = 126.8,
          xmax = 127.2,
          ymin = 37.2,
          ymax = 37.7)


# load shapefiles for Seoul and han river -----------------------------

seoul <-
  st_read('day6_asia/seoul_municipalities.shp') %>%
  st_crop(y = bbox)

han_river <-
  st_read('day6_asia/han_river.shp')%>%
  st_crop(y = c(xmin = 126.8,
                xmax = 127.2,
                ymin = 37.2,
                ymax = 37.7)) 


# create data frame of chaebols ---------------------------------------

chaebols <-
  data.frame(
    'company' = c('Samsung',
                  'Shinsegae Group',
                  'CJ Group',
                  'JoongAng Ilbo',
                  'BGF Group',
                  'Hansol',
                  'Hyundai Motor Group',
                  'Hyundai Heavy Industry Group',
                  'Hyundai Department Store Group',
                  'Hyundai Marine & Fire Insurance',
                  'Halla Group',
                  'HDC Hyundai Development Group',
                  'KCC Corporation',
                  'LG Corporation',
                  'GS Group',
                  'LS Group',
                  'LIG Nex1',
                  'OurHome Corporation',
                  'LF Group',
                  'LT Group',
                  'Heesung Electronics',
                  'Lotte Group',
                  'Nongshim',
                  'SK Group',
                  'Hanwha Group'
                  ),
    'address' = c('Samsung Digital City, Yeongtong-gu, Suwon, South Korea',
                  '63 Sogong-ro, Jung-gu, Seoul, South Korea',
                  '33 Dongho-ro, Jung-gu, Seoul, South Korea',
                  '48-6 Sangamsan-ro, Sangam-dong, Mapo-gu, Seoul, South Korea',
                  '141-32 Samseong-dong, Gangnam-gu, Seoul, South Korea',
                  '100 Eulji-ro, Euljiro 2(i)-ga, Jung-gu, Seoul, South Korea',
                  '12 Heolleung-ro, Yangjae-dong, Seocho-gu, Seoul, South Korea',
                  '1000, Bangeojinsunhwando-ro, Dong-gu, Ulsan, South Korea',
                  '165 Apgujeong-ro, Gangnam-gu, Seoul, South Korea',
                  '163 Sejong-daero, Sejongno, Jongno-gu, Seoul, South Korea',
                  '7-19 Sincheon-dong, Seoul, Seoul, South Korea',
                  '55 Hangang-daero 23-gil, Yongsan-gu, Seoul, South Korea',
                  '344 Sapyeong-daero, Seocho 4(sa)-dong, Seocho-gu, South Korea',
                  '128 Yeoui-daero, Yeouido-dong, Yeongdeungpo-gu, Seoul, South Korea',
                  '508 Nonhyeon-ro, Gangnam-gu, Seoul, South Korea',
                  '92 Hangang-daero, Yongsan-gu, Seoul, South Korea',
                  '333 Pangyo-ro, Bundang-gu, Seongnam-si, Gyeonggi-do, South Korea',
                  '382, Gangnam-daero, Gangnam-gu, Seoul, South Korea',
                  '870 Eonju-ro, Gangnam-Gu, Seoul, South Korea',
                  '13, Gongdan-ro, Chuncheon-si, Gangwon-do, South Korea',
                  '45 Hannam-daero, Yongsan-gu, Seoul, South Korea',
                  '300, Olympic-ro, Songpa-gu, Seoul, South Korea',
                  '112 Yeouidaebang-ro, Dongjak-gu, Seoul, South Korea',
                  '26 Jong-ro, Jongno-gu, Seoul 03188 South Korea',
                  '86 Cheonggyecheon-ro, Jung-gu, Seoul, South Korea'
                  ),
    'industry' = c('Consumer Electronics',
                   'Retail',
                   'Conglomerate',
                   'News and Media',
                   'Retail',
                   'Paper Products',
                   'Vehicles',
                   'Heavy Equipment',
                   'Retail',
                   'Insurance',
                   'Conglomerate',
                   'Real Estate',
                   'Chemical Manufacture',
                   'Consumer Electronics',
                   'Conglomerate',
                   'Electrics',
                   'Aerospace',
                   'Home Goods',
                   'Apparel',
                   'Cosmetics',
                   'Consumer Electronics',
                   'Conglomerate',
                   'Food and Beverage',
                   'Conglomerate',
                   'Energy'
                   ),
    'chaebol_family' = c('Lee Byung-chul Family Group',
                         'Lee Byung-chul Family Group',
                         'Lee Byung-chul Family Group',
                         'Lee Byung-chul Family Group',
                         'Lee Byung-chul Family Group',
                         'Lee Byung-chul Family Group',
                         'Chung Ju-yung Family Group',
                         'Chung Ju-yung Family Group',
                         'Chung Ju-yung Family Group',
                         'Chung Ju-yung Family Group',
                         'Chung Ju-yung Family Group',
                         'Chung Ju-yung Family Group',
                         'Chung Ju-yung Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Koo In-hwoi Family Group',
                         'Shin Kyuk-ho Family Group',
                         'Shin Kyuk-ho Family Group',
                         'Other',
                         'Other')
  )


# geocode addresses ---------------------------------------------------

chaebols_coords <-
  geo(chaebols$address,
      method = 'osm',
      lat = 'latitude',
      long = 'longitude') %>%
   right_join(chaebols) %>%
  sf::st_as_sf(coords = c('longitude',
                          'latitude'),
               remove = FALSE,
               crs = st_crs(han_river)) %>%
  st_crop(y = bbox) %>%
  # these two are outside the boundaries of the seoul shapefile
  filter(!(company %in% c('Samsung',
                          'LIG Nex1')))



# plot map ------------------------------------------------------------

ggplot() +
  geom_sf(data = seoul,
          alpha = 0) +
  # Considered adding municipality labels but it made the plot too busy
  # geom_sf_label(data = seoul, aes(label = paste0(name_eng,
  #                                                ' (',
  #                                                name,
  #                                                ')')),
  #               size = 3) +
  geom_sf(data = han_river,
          aes(color = factor(SUB_NAME)),
          linewidth = 1.5,
          alpha = 0.4) +
  scale_color_manual(name = '',
                     values = c('blue'),
                     labels = c('Han River (한강)')) +
  ggnewscale::new_scale_color() +
  geom_sf(data = chaebols_coords,
             aes(
                 color = factor(chaebol_family))) +
  ggrepel::geom_label_repel(
    data = chaebols_coords,
    aes(label = company,
        fill = factor(chaebol_family),
        geometry = geometry),
    stat = "sf_coordinates",
    min.segment.length = 0
  ) +
  ggtitle('Miracle on the Han River: Selected Chaebols in Seoul, South Korea',
          subtitle = '2023 30-Day Mapping Challenge Day 6: Asia\nAlexander Adams') +
  guides(alpha = FALSE) +
  guides(fill = FALSE) +
  scale_color_manual(name = 'Chaebol Family',
                     values = c('#7a7f43',
                                '#7ba63c',
                                '#a63640',
                                '#7daabe',
                                '#ecac46')) +
  scale_fill_manual(values = c('#7a7f43',
                                          '#7ba63c',
                                          '#a63640',
                                          '#7daabe',
                                          '#ecac46')) +
  labs(caption = 'Data Source: Food and Agriculture Organization of the United Nations | Wikipedia\nTwitter: @alexadams385\nGitHub: AAdams149') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#c8c1d1'),
    panel.background = element_rect(fill = '#c8c1d1'),
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
    legend.position = c(0.19, 0.82),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 

ggsave('day6_asia/day6_asia.png')


library(readr)
library(rnaturalearth)
library(sf)
library(showtext)

showtext_auto()
font_add_google('Junge')
plotfont <- 'Junge'

# Preprocess Orinoco River shapefile -------------------------------------

# Download data from https://data.apps.fao.org/catalog/iso/12d7d96a-b0ea-4aea-aedc-b9c9a80cab7f

# Click: Download - Rivers of South America (ESRI shapefile)
# Huge file, so filter to what I want, write that, delete the rest

# orinoco <-
#   st_read('day12_southamerica/rivers_samerica_37330.shp') %>%
#   filter(str_detect(SUB_NAME, 'Orinoco'))
# 
# st_write(
#   orinoco,
#   'day12_southamerica',
#   'orinoco_river',
#   driver = 'ESRI Shapefile'
# )

# rm(orinoco)



orinoco <-
  st_read('day12_southamerica/orinoco_river.shp')

orinoco$colorvar <- '1'

cv <-
  ne_countries(country = c('Colombia','Venezuela'),
               returnclass = 'sf') %>%
  st_crop(st_bbox(orinoco))

co <-
  read_csv('day12_southamerica/co.csv') %>%
  st_as_sf(coords = c('lng',
                      'lat'),
           crs = st_crs(cv))

ve <-
  read_csv('day12_southamerica/ve.csv') %>%
  st_as_sf(coords = c('lng',
                      'lat'),
           crs = st_crs(cv))

cities <-
  bind_rows(co,
            ve) %>%
  st_crop(st_bbox(orinoco)) %>%
  mutate(pop_bin = case_when(population <= 150000 ~ 1,
                             population > 100000 & population <= 250000 ~ 2,
                             TRUE ~ 3)) %>%
  filter(!(city %in% c("Araure",
                       "Maturín",
                       "San Juan de los Morros",
                       "Calabozo",
                       "Tinaquillo",
                       "San Carlos",
                       "Anaco",
                       "Acarigua")))

ggplot() +
  geom_sf(data = cv, aes(alpha = 0.2),
                         fill = '#8cf78f') +
  geom_sf(data = cities, aes(size = as.factor(pop_bin))) +
  scale_size_manual(labels = c('<150,000',
                              '150-250,000',
                              '>250,000'),
                    values = c(1,2,3),
                    name = 'Population') +
  ggrepel::geom_label_repel(data = cities,
                            aes(label = paste0(city,
                                               '\nPop.',
                                               population),
                                    lineheight = 0.8,
                                    geometry = geometry,
                                    fill = factor(iso2),
                                    family = plotfont),
                   stat = 'sf_coordinates',
                   min.segment.length = 0) +
  scale_fill_manual(name = 'Country',
                    labels = c('Colombia',
                               'Venezuela'),
                    values = c('#FFCD00',
                               '#EF3340')) +
  geom_sf(data = orinoco,
          aes(color = colorvar),
          linewidth = 0.4,
          alpha = 0.4) +
  scale_color_manual(name = '',
                     values = c('blue'),
                     labels = c('Orinoco River')) +
  guides(linewidth = 'none') +
  guides(alpha = 'none') +
  guides(color = 'none') +
  ggtitle('Cities and Towns Along the Orinoco River',
          subtitle = '2023 30-Day Mapping Challenge Day 12: South America') +
  labs(caption = "Data Source: United Nations Food and Agriculture Organization | simplemaps.com\nTwitter: @alexadams385\nGitHub: AAdams149") +
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
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.8, 0.15),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.8),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggsave('day12_southamerica/day12_southamerica.png')

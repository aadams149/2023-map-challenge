
library(cowplot)
library(ggplot2)
library(sf)
library(showtext)

showtext_auto()
font_add_google('Khand')
plotfont <- 'Khand'

# fl_elev <-
#   sf::st_read('day20_outdoors/Elevations_Contours_and_Depression.shp')
# 
# brevard_county <-
#   tigris::counties(state = 'FL') %>%
#   filter(COUNTYFP == '009') %>%
#   st_transform(crs = st_crs(fl_elev))
# 
# fl_elev <-
#   fl_elev %>%
#   st_crop(brevard_county) %>%
#   st_transform(crs = "+proj=longlat +datum=NAD83")
# 
# st_write(fl_elev,
#           'day20_outdoors',
#           'fl_elev',
#           driver = "ESRI Shapefile")

fl_elev <-
  sf::st_read('day20_outdoors/fl_elev.shp')


landmasses <-
  data.frame(
    p1_lat = c(27.825,28.38), 
    p2_lat = c(27.808,28.14),
    p3_lat = c(28.28,28.4),
    p4_lat = c(28.8,28.54),
    p5_lat = c(28.8,28.604),
    p6_lat = c(28.8,28.65),
    p1_lon = c(-81,-80.713),
    p2_lon = c(-80.47,-80.6),
    p3_lon = c(-80.7,-80.601),
    p4_lon = c(-80.865,-80.575),
    p5_lon = c(-80.9,-80.6),
    p6_lon = c(-80.978,-80.713)
  )

lst <- lapply(1:nrow(landmasses), function(x){
  ## create a matrix of coordinates that also 'close' the polygon
  res <- matrix(c(landmasses[x, 'p1_lon'], landmasses[x, 'p1_lat'],
                  landmasses[x, 'p2_lon'], landmasses[x, 'p2_lat'],
                  landmasses[x, 'p3_lon'], landmasses[x, 'p3_lat'],
                  landmasses[x, 'p4_lon'], landmasses[x, 'p4_lat'],
                  landmasses[x, 'p5_lon'], landmasses[x, 'p5_lat'],
                  landmasses[x, 'p6_lon'], landmasses[x, 'p6_lat'],
                  landmasses[x, 'p1_lon'], landmasses[x, 'p1_lat'])  ## need to close the polygon
                , ncol =2, byrow = T
  )
  ## create polygon objects
  st_polygon(list(res))
  
})

landmasses <- 
  st_sf(st_sfc(lst),
        crs = st_crs(fl_elev))

map <-
ggplot() +
  geom_sf(data = landmasses, fill = "#ffbc30", alpha = 0.4) +
  geom_sf(data = fl_elev, aes(color = CONTOUR)) +
  scale_color_gradient(low = '#481516',
                       high = '#f7edd4',
                       name = 'Elevation (m)') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#1c4c69',
                                   color = '#1c4c69'),
    panel.background = element_rect(fill = '#1c4c69',
                                    color = '#1c4c69'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24,
                              lineheight = 0.5),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'white',
                               size = 18),
    legend.title = element_text(color = 'white',
                                size = 18),
    plot.margin = margin(t = 30,
                         r = 15,
                         b = 30,
                         l = 15),
    legend.position = c(1, 0.5),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.8),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

ggdraw() +
  draw_plot(map) +
  draw_text('Elevation Features in Brevard County, Florida', 
            x = 0.5,
            y = 0.97,
            size = 36,
            family = plotfont,
            color = 'white') +
  draw_text('2023 30-Day Mapping Challenge Day 20: Outdoors',
            x = 0.5,
            y = 0.94,
            size = 28,
            family = plotfont,
            color = 'white') +
  draw_text('Alexander Adams',
            x = 0.5,
            y = 0.92,
            size = 28,
            family = plotfont,
            color = 'white') +
  draw_text('Data: Florida Department of Environmental Protection\nTwitter: @alexadams385\nGitHub: AAdams149',
            x = 0.5,
            y = 0.05,
            size = 24,
            family = plotfont,
            color = 'white',
            lineheight = 0.6)

ggsave('day20_outdoors/day20_outdoors.png', width = 2100, height = 2100, units = 'px')


library(cowplot)
library(dplyr)
library(sf)
library(showtext)
library(tigris)

showtext_auto()
font_add_google('Alegreya')
plotfont <- 'Alegreya'

counties <-
  tigris::counties() %>%
  st_simplify(dTolerance = 3e3) %>%
  st_crop(y = c(xmin = -179.22855,
                ymin = -14.59707,
                xmax = -63,
                ymax = 71.43676)) %>%
  filter(STATEFP < 57) %>%
  mutate(
         labels = case_when(stringr::str_detect(NAME, '[Rr]ed') ~ 'red',
                            stringr::str_detect(NAME, '[Oo]range') ~ 'orange',
                            stringr::str_detect(NAME, '[Yy]ellow') ~ 'yellow',
                            stringr::str_detect(NAME, '[Gg]reen') ~ 'green',
                            stringr::str_detect(NAME, '[Bb]lue') ~ 'blue',
                            stringr::str_detect(NAME, '[Pp]urple') ~ 'purple',
                            stringr::str_detect(NAME, '[Pp]ink') ~ 'pink',
                            stringr::str_detect(NAME, '[Bb]rown') ~ 'brown',
                            stringr::str_detect(NAME, '[Bb]lack') ~ 'black',
                            stringr::str_detect(NAME, '[Gg]r[ae]y') ~ 'gray',
                            TRUE ~ NA))

states <- state.name
states = states[grep('Alaska|Hawaii',states, invert = TRUE)]

states_bbox <-
  c(xmin = -124.8,
    ymin = -14.59,
    xmax = -63,
    ymax = 50)

lower48 <-
  counties %>%
  filter(!(STATEFP  %in% c(02,15))) %>%
  st_crop(y = states_bbox) %>%
  ggplot() +
  geom_sf(aes(fill = factor(labels)),
          color = 'black') +
  scale_fill_identity() +
  ggtitle('FIPS Codes and Hex Codes: U.S. Counties with Color Names',
          subtitle = '2023 30-Day Mapping Challenge Day 19: 5-Minute Map\nAlexander Adams') +
  labs(caption = "Data Source: U.S. Census\nTwitter: @alexadams385\nGitHub: AAdams149") +
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
    legend.box = 'horizontal',
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.7, 0.3),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18,
                                lineheight = 0.5),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  )

 alaska_bbox <-
 c('xmin' = -179.22855,
   'ymin' = 51.17509,
   'xmax' = -129.97665,
   'ymax' = 71.43676)
 
 alaska <-
   counties %>%
   st_crop(y = alaska_bbox) %>%
   ggplot() +
   geom_sf(aes(fill = factor(labels)),
           color = 'black') +
   scale_fill_identity() +
   theme_void() +
   theme(
     text = element_text(family = plotfont),
     plot.background = element_rect(fill = '#FFFFFF'),
     panel.background = element_rect(fill = '#FFFFFF'),
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
     legend.position = c(0.87, 0.5),
     plot.caption = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
     axis.text.x = element_blank(),
     axis.text.y = element_blank(),
     axis.line = element_blank(),
     axis.ticks = element_blank()
   )
 
 hawaii_bbox <-
   c('xmin' = -160.59294,
     'ymin' = 18.91924,
     'xmax' = -154.75717,
     'ymax' = 22.28536)
 
 hawaii <-
   counties %>%
   st_crop(y = hawaii_bbox) %>%
   ggplot() +
   geom_sf(aes(fill = factor(labels)),
           color = 'black') +
   scale_fill_identity() +
   guides(fill = 'none') +
   theme_void() +
   theme(
     text = element_text(family = plotfont),
     plot.background = element_rect(fill = '#FFFFFF'),
     panel.background = element_rect(fill = '#FFFFFF'),
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
     legend.position = c(0.7, 0.5),
     plot.caption = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
     axis.text.x = element_blank(),
     axis.text.y = element_blank(),
     axis.line = element_blank(),
     axis.ticks = element_blank()
   )
 
 
 # draw and save -------------------------------------------------------
 
 ggdraw() +
   draw_plot(lower48) +
   draw_plot(alaska, x = -0.41, y = 0.225, height = 0.15) +
   draw_plot(hawaii, x = -0.225, y = 0.225, height = 0.11)
 
 ggsave('day19_5minutemap/day19_5minutemap.png')
 

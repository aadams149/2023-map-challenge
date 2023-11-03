

# load packages -------------------------------------------------------

library(dplyr)
library(sf)
library(showtext)

# instantiate font ----------------------------------------------------

showtext_auto()
font_add_google("Bitter")
plotfont <- "Bitter"

# load shapefile ------------------------------------------------------

europe <-
  st_read('day4_badmap/world-administrative-boundaries.shp') %>%
  filter(continent == 'Europe' | name %in% c('Russia',
                                            'Turkey',
                                            'Armenia',
                                            'Georgia',
                                            'Azerbaijan',
                                            'Morocco'
                                            )) %>%
  st_crop(y = c(xmin = -25,
                xmax = 55,
                ymin = 18,
                ymax = 72)) %>%
  mutate(points = case_when(name == 'Morocco' ~ 'Morocco',
                            name == 'Italy' ~ 'Yes',
                            TRUE ~ 'No'))


# Make plot -----------------------------------------------------------

ggplot(europe) +
  geom_sf(aes(fill = factor(points))) +
  # use colors of Moroccan flag
  scale_fill_manual(values = c('#C1272D',
                               '#FFFFFF',
                               '#006233'),
                    name = 'Points to Morocco?') +
  ggtitle('Countries which have awarded Morocco points in the Eurovision Song Contest',
          subtitle = '2023 30-Day Mapping Challenge Day 4: A Bad Map\nAlexander Adams') +
  labs(caption = 'Data Source: https://public.opendatasoft.com/explore/dataset/world-administrative-boundaries\nTwitter: @alexadams385\nGitHub: AAdams149') +
  theme_void() +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#e9ddae'),
    panel.background = element_rect(fill = '#e9ddae'),
    legend.title.align = 0.5,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'black',
                               size = 18),
    legend.title = element_text(color = 'black',
                                size = 18),
    legend.position = c(0.1, 0.5),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 18),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 


# save and export -----------------------------------------------------

ggsave('day4_badmap/day4_badmap.png')

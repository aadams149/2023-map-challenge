
library(cowplot)
library(dplyr)
library(purrr)
library(readr)
library(sf)
library(showtext)
library(tidyr)

showtext_auto()
font_add_google('Rufina')
plotfont <- 'Rufina'

wards <-
  sf::st_read('day3_polygons/Wards_from_2022.shp') %>%
  select(NAME, geometry) %>%
  st_transform(crs = 4326)

data <-
  read_csv('day27_dot/ACS_Demographic_Characteristics_DC_Census_Tract.csv') %>%
  select(
    GEOID,
    'under5' = DP05_0005E, # ( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: Under 5 years )
    'age5_9' = DP05_0006E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 5 to 9 years )
    'age10_14' = DP05_0007E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 10 to 14 years )
    'age15_19' = DP05_0008E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 15 to 19 years )
    'age20_24' = DP05_0009E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 20 to 24 years )
    'age25_34' = DP05_0010E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 25 to 34 years )
    'age35_44' = DP05_0011E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 35 to 44 years )
    'age45_54' = DP05_0012E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 45 to 54 years )
    'age55_59' = DP05_0013E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 55 to 59 years )
    'age60_64' = DP05_0014E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 60 to 64 years )
    'age65_74' = DP05_0015E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 65 to 74 years )
    'age75_84' = DP05_0016E, #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 75 to 84 years )
    'age85_plus' = DP05_0017E #( type: esriFieldTypeDouble, alias: SEX AND AGE: Total population: 85 years and over ) 
  ) %>%
  mutate(alpha = under5+age5_9,
         genz = age10_14+age15_19+age20_24,
         millenial = age25_34+age35_44,
         genx = age45_54+age55_59,
         boomer = age60_64+age65_74,
         silent = age75_84+age85_plus,
         GEOID = as.character(GEOID)) %>%
  select(GEOID,
         alpha,
         genz,
         millenial,
         genx,
         boomer,
         silent) %>%
  pivot_longer(cols = c(alpha,genz,millenial,genx,boomer,silent),names_to = 'generation',values_to = 'count') %>%
  mutate(count = round(count/50,0)) %>%
  
  left_join(tigris::tracts('DC')) %>%
  st_as_sf() %>%
  st_transform(crs = st_crs(wards))

tract_split <- data %>%
  split(f = .$generation)

generate_samples <- function(data){
  suppressMessages(st_sample(data,
                             size = data$count))
}

dots <- map(tract_split, generate_samples)

dots <- imap(dots, 
                  ~st_sf(data.frame(point = rep(.y, length(.x))),
                         geometry = .x))

dots <- do.call(rbind, dots)

dots <-
  dots %>%
  group_by(point) %>%
  summarise() %>%
  ungroup()

map <-
  ggplot() +
  geom_sf(data = dots,
          aes(color = factor(point))) +
  scale_color_manual(name = 'Generation',
                     labels = c('Gen Alpha',
                                'Gen Z',
                                'Millenial',
                                'Gen X',
                                'Baby Boomer',
                                'Silent Generation'),
                     values = c('#BF0D3E',
                                '#ED8B00',
                                '#009CDE',
                                '#00B140',
                                '#FFD100',
                                '#919D9D')) +
  
  geom_sf(data = data,
          fill = '#FFFFFF',
          aes(geometry = geometry),
          alpha = 0) +
  geom_sf(data = wards, 
          linewidth = 0.7,aes( 
            geometry = geometry,
            alpha = 0)) +
  geom_sf_label(data = wards, aes(label = NAME)) +
  theme_void() +
  guides(linewidth = 'none') +
  guides(alpha = 'none') +
  theme(
    text = element_text(family = plotfont),
    plot.background = element_rect(fill = '#134e0b',
                                   color = '#134e0b'),
    legend.title.align = 0.1,
    plot.title = element_text(hjust = 0.5,
                              color = 'black',
                              size = 24),
    plot.subtitle = element_text(color = 'black',
                                 hjust = 0.5,
                                 size = 18),
    legend.text = element_text(color = 'white',
                               size = 28),
    legend.title = element_text(color = 'white',
                                size = 28),
    legend.position = c(0.3, 0.3),
    plot.margin = margin(t = 40,
                         r = 15,
                         b = 40,
                         l = 15),
    plot.caption = element_text(color = 'black',
                                hjust = 0.5,
                                size = 14),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank()
  ) 

ggdraw() +
  draw_plot(map) +
  draw_text('Generations in Washington, D.C.', 
            x = 0.5,
            y = 0.97,
            size = 44,
            family = plotfont,
            color = 'white') +
  draw_text('2023 30-Day Mapping Challenge Day 27: Dot Map\nAlexander Adams',
            x = 0.5,
            y = 0.92,
            size = 32,
            family = plotfont,
            color = 'white',
            lineheight = 0.3) +
  draw_text('Each dot represents 50 people',
            x = 0.375,
            y = 0.17,
            size = 28,
            family = plotfont,
            color = 'white') +
  draw_text('Data: D.C. Open Data Portal\nTwitter: @alexadams385\nGitHub: AAdams149',
            x = 0.5,
            y = 0.03,
            size = 28,
            family = plotfont,
            color = 'white',
            lineheight = 0.3)

ggsave('day27_dot/day27_dot.png')

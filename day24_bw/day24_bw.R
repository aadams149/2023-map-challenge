
library(cowplot)
library(dplyr)
library(plotly)
library(readr)
library(sf)
library(showtext)
library(tidygeocoder)
library(tigris)

showtext_auto()
font_add_google('Spectral')
plotfont <- 'Spectral'

#get the source url to the font file from google
bela_file <- showtextdb::google_fonts("Spectral")$regular_url 

#create custom CSS 
bela_css <- paste0(
  "<style type = 'text/css'>",
  "@font-face { ",
  "font-family: 'Spectral'; ", #however you want to refer to it
  "src: url('", bela_file, "'); ", #file from google
  "}",
  "</style>")

hbcus <-
  read_csv('day24_bw/hbcus.csv')

latlongs <-
  tidygeocoder::geo(hbcus$Institution)

latlongs <-
  latlongs %>%
  mutate(lat = case_when(address == 'Hinds Community College at Utica' ~ 32.047005,
                         address == 'J. F. Drake State Technical College' ~ 34.7717707,
                         address == 'Jarvis Christian University' ~ 32.5891962,
                         address == 'Trenholm State Community College' ~ 32.3502738,
                         address == "St. Philip's College" ~ 29.4159957,
                         address == 'Simmons College' ~ 38.2394708,
                         TRUE ~ lat),
         long = case_when(address == 'Hinds Community College at Utica' ~ -90.6256064,
                          address == 'J. F. Drake State Technical College' ~ -86.5758899,
                          address == 'Jarvis Christian University' ~ -95.1823684,
                          address == 'Trenholm State Community College' ~ -86.3810831,
                          address == "St. Philip's College" ~ -98.4560899,
                          address == 'Simmons College' ~ -85.7673219,
                          TRUE ~ long)) %>%
  right_join(hbcus,
             by = c('address' = 'Institution')) %>%
  st_as_sf(coords = c('long',
                      'lat'),
           remove = FALSE,
           crs = 4326)

states <-
  tigris::states() %>%
  filter(NAME %in% unique(latlongs$State))

map <-
  ggplotly(
    ggplot() +
      geom_sf(data = states,
              fill = '#FFFFFF',
              color = '#000000') +
      geom_sf(data = latlongs,
              aes(shape = factor(Type),
                  text = paste0(address,
                                '\n',
                                City, ', ',State,'\nFounded ',
                                Founded))) +
      guides(shape = guide_legend(title = 'Type')) +
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
        legend.position = c(0.25, 0.82),
        plot.caption = element_text(color = 'black',
                                    hjust = 0.5,
                                    size = 18),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.line = element_blank(),
        axis.ticks = element_blank()
      ),
    tooltip = 'text') %>%
  layout(title = list(text = paste0('Historically Black Colleges and Universities in the United States',
                                    '<br>',
                                    '<sup>',
                                    '2023 30-Day Mapping Challenge Day 24: Black and White\nAlexander Adams',
                                    '</sup>'),
                      x = 0.4,
                      y = 0.9),
         annotations = 
           list(x = 1, y = 0.0, text = "Data Source: Wikipedia\nTwitter: @alexadams385\nGitHub: AAdams149", 
                showarrow = F, xref='paper', yref='paper', 
                xanchor='right', yanchor='auto', xshift=0, yshift=0))

#add the CSS as a dependency for the plotly object
map$dependencies <- c(
  map$dependencies,
  list(
    htmltools::htmlDependency(
      name = "bela-font", #these  first 3 arguments don't really matter for this use case
      version = "0",  
      src = "",
      head = bela_css #refer to the custom CSS created
    )
  )
)

htmlwidgets::saveWidget(as_widget(map), 'day24_bw/day24_bw.html')

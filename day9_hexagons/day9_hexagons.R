
library(dplyr)
library(ggplot2)
library(htmlwidgets)
library(plotly)
library(readr)
library(sf)
library(showtext)


showtext_auto()
font_add_google("Belanosima")
plotfont <- "Belanosima"

#get the source url to the font file from google
bela_file <- showtextdb::google_fonts("Belanosima")$regular_url 

#create custom CSS 
bela_css <- paste0(
  "<style type = 'text/css'>",
  "@font-face { ",
  "font-family: 'Belanosima'; ", #however you want to refer to it
  "src: url('", bela_file, "'); ", #file from google
  "}",
  "</style>")

#add the CSS as a dependency for the plotly object
p$dependencies <- c(
  p$dependencies,
  list(
    htmltools::htmlDependency(
      name = "bela-font", #these  first 3 arguments don't really matter for this use case
      version = "0",  
      src = "",
      head = bela_css #refer to the custom CSS created
    )
  )
)

dw_nom <-
  read_csv('day9_hexagons/H118_members.csv') %>%
  mutate(district_code = case_when(state_abbrev %in% c('AK',
                                                       'DE',
                                                       'ND',
                                                       'SD',
                                                       'VT',
                                                       'WY') ~ 'AL',
                                   TRUE ~ as.character(district_code)),
         party_code = case_when(party_code == 200 ~ 'R',
                                party_code == 100 ~ 'D'))

hex <-
  st_read('day9_hexagons/HexCDv30.shp') %>%
  mutate(CDLABEL = case_when(CDLABEL %in% c('AK',
                                            'DE',
                                            'ND',
                                            'SD',
                                            'VT',
                                            'WY') ~ 'AL',
                             TRUE ~ as.character(CDLABEL))) %>%
  left_join(dw_nom,
            by = c('STATEAB' = 'state_abbrev',
                   'CDLABEL' = 'district_code')) %>%
  mutate(dist_label = paste0(STATEAB, '-', CDLABEL),
         mouse_text = paste0(bioname,
                             ' (',
                             party_code,
                             ', ',
                             dist_label,
                             ')\n',
                             nominate_dim1))
p <- ggplotly(
  ggplot(data = hex, aes(text = mouse_text)) +
  geom_sf(aes(fill = nominate_dim1)) +
  scale_fill_gradient2(low = 'blue',
                       mid = 'white',
                       high = 'red',
                       name = 'DW-Nominate Score') +
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
  layout(title = list(text = paste0('DW-Nominate Scores for the 118th U.S. House of Representatives',
                             '<br>',
                             '<sup>',
                             '2023 30-Day Mapping Challenge Day 9: Hexagons\nAlexander Adams',
                             '</sup>'),
                      x = 0.4,
                      y = 0.9),
         annotations = 
           list(x = 1, y = 0.0, text = "Data Source: Daily Kos | voteview.com\nTwitter: @alexadams385\nGitHub: AAdams149", 
                showarrow = F, xref='paper', yref='paper', 
                xanchor='right', yanchor='auto', xshift=0, yshift=0))


p$dependencies <- c(
  p$dependencies,
  list(
    htmltools::htmlDependency(
      name = "bela-font",
      version = "0",  
      src = "",
      head = bela_css
    )
  )
)

htmlwidgets::saveWidget(as_widget(p), 'day9_hexagons/day9_hexagons.html')

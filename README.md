# 2023-map-challenge
Code and maps for the 2023 30-Day Map Challenge

At the encouragement of some friends, I've decided to try the 2023 30-Day Map
Challenge. This repository contains the code and maps I've created during this challenge.

## Day 1: Points

#### Map: Historic Bridges of Brevard County, Florida

![Day 1: Points](day1_points/day1_points.png?raw=true "Historic Bridges of Brevard County, Florida")

For my first map, I decided to plot the area where I grew up: Brevard County, Florida. 
This map depicts the locations of historic bridges in Brevard County. The data is sourced from 
the [Florida Geographic Data Library](https://fgdl.org/ords/r/prod/fgdl-current/catalog) (BAR Historic Bridges in Florida - Oct 2023).

The colors for this map were selected from the first image of the Sebastian Inlet Bridge in [this article.](https://www.sitd.us/sebastian-inlet-bridge-in-design-phase-timeline-below) The Sebastian Inlet Bridge is identified with a triangle on this map.

## Day 2: Lines

#### Map: All Roads Lead to Rome...Georgia?

![Day 2: Lines](day2_lines/day2_lines.png?raw=true "Roads in Rome, Georgia")

For day 2, I decided to plot the road system in Rome, Georgia. (Honestly, I just though of the saying "all roads lead to rome" and decided to run with it.) The spatial line file came from the [Georgia GIS Clearinghouse](https://data.georgiaspatial.org).

## Day 3: Polygons

#### Map: Vacancy Rates in Census Tracts in Washington, D.C.

![Day 3: Polygons](day3_polygons/day3_polygons.png?raw=true "Vacancy Rates in D.C. Census Tracts")

For day 3, I decided to plot the housing vacancy rates across census tracts in Washington, D.C. I also overlaid the boundaries for D.C.'s eight wards and added identifying labels. The data came from the [Washington D.C. Open Data portal](https://opendata.dc.gov/datasets/DCGIS::census-tracts-in-2020/explore).

## Day 4: A Bad Map

#### Map: 12 - er, 7 Points to Morocco!

![Day 4: A Bad Map](day4_badmap/day4_badmap.png?raw=true "Points Awarded to Morocco in the Eurovision Song Contest")

I'm a huge fan of the Eurovision Song Contest, and this is the first but likely not the last ESC-related map I'm going to make for this challenge. There's some essential context needed here: Eurovision is open to countries with eligible television broadcasters in the European Broadcasting Area, a region which encompasses Europe as well as parts of North Africa and Western Asia. Over the years, various countries have participated in Eurovision which aren't necessarily in Europe, like Armenia, Azerbaijan, Georgia, Israel, and Morocco. It's this last country which is the focus of my bad map. Morocco only entered Eurovision once, in 1980, when they sent the song [Bitaqat Hub (بطاقة حب)](https://www.youtube.com/watch?v=97FD34DpSuw&ab_channel=escLIVEmusic1) (sometimes spelled Bitakat Hob) by Samira Bensaïd. Unfortunately, it did extremely poorly. In the Eurovision Song Contest, countries award points to each other, and are unable to award points to themselves. Morocco received only 7 points, all from Italy. (For comparison, the winning entry in 1980, What's Another Year by Johnny Logan representing Ireland, received 143 points). This resulted in Morocco finishing 18th of 19 countries, barely ahead of Finland. The poor showing so offended the Moroccan public broadcaster MRT that they decided to withdraw from the contest and to date have never sent another entry. 

This map shows all the countries which have awarded points to Morocco in the Eurovision Song Contest. The two colors used (red for Morocco and green for Italy) are the two colors of the Moroccan flag. If you don't like this map, maybe you'll like Bitaqat Hub better. I suggest you listen to it; it's a fantastic fusion of disco and traditional Arabic music styles, and Samira Bensaïd is a stellar artist. Morocco may have only sent one Eurovision entry, but it's a good one.

Tne shapefile for this map came from [opendatasoft](https://public.opendatasoft.com/explore/dataset/world-administrative-boundaries/).

## Day 5: Analog

Yeah I didn't feel like doing this.

## Day 6: Asia

#### Map: Miracle on the Han River

![Day 6: Asia](day6_asia/day6_asia.png?raw=true "Miracle on the Han River: Selected Chaebols in Seoul, South Korea")

In the years following World War II and the Korean War, South Korea was an extremely poor and underdeveloped nation. Government ministers, looking to Germany's economic development and growth as an example, sought to lead their own country in a similar direction. Germany had the ["Miracle on the Rhine"](https://en.wikipedia.org/wiki/Wirtschaftswunder), and South Korea would have the ["Miracle on the Han River"](https://en.wikipedia.org/wiki/Miracle_on_the_Han_River), so named for the large river which flows through the nation's capitol and largest city, Seoul.

Many of the businesses which sprung up during this period of economic growth are known as *chaebols*. Chaebols are large companies owned by a single extended family, similar to the Rockefellers, Vanderbilts, or Pritzkers in the U.S. Several chaebols built their corporate headquarters or flagship stores along the Han River in Seoul. This map shows the locations of some of those headquarters. 

The shapefile for the municipalities of Seoul comes from [this GitHub repository of South Korean GIS data](https://github.com/southkorea/seoul-maps/tree/master). The shapefile for the Han River originally comes from the [Food and Agriculture Organization of the United Nations](https://data.apps.fao.org/catalog/iso/dc2a5121-0b32-482b-bd9b-64f7a414fa0d), but it's a large file, so the version included here in this repo is filtered to only the Han River. The list of chaebols and the families who own them came from the "List of major chaebols by family group" table on the [Wikipedia page for chaebols](https://en.wikipedia.org/wiki/Chaebol).

The colors for this map were taken from the first image on the [Wikipedia page for the *Hibiscus syriacus*](https://en.wikipedia.org/wiki/Hibiscus_syriacus), also known as the Rose of Sharon, which is the national flower of South Korea.

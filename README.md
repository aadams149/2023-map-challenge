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

## Day 7: Navigation

#### Map: Closest Metro Line in Northwest D.C.

![Day 7: Navigation](day7_navigation/day7_navigation.png?raw=true "Closest Metro Line in Northwest D.C.")

I have to be honest, I don't feel particularly proud of this map. This is a map of neighborhood clusters in northwest Washington D.C., colored according to the metro line of the stop closest to them. In northwest D.C., all of the stops on the blue line are also on the orange and silver lines. These are presented as blue for simplicity. The green line overlaps substantially with the yellow line, so a similar approach was taken. The colors of the map are the official WMATA hex codes. The shapefile for the neighborhood clusters can be found [here](https://opendata.dc.gov/datasets/neighborhood-clusters/explore). The data for the metro stops is taken from the WMATA API by way of a tutorial I wrote for the `folium` package in python during my master's degree. The data can be found [here](https://github.com/aadams149/portfolio/tree/main/Coursework), as can the tutorial. At some point, I may try to rework this into something better, but for now I'm focusing on finishing as many maps as I can for this challenge. 

## Day 8: Africa

#### Map: I Bless the Rains Down in Africa

![Day 8: Africa](day8_africa/day8_africa.png?raw=true "Avg. Annual Rainfall in South Africa, 1983-2000")

Sure, Toto really had something with the whole "bless the rains down in Africa" thing, but what were those rains really like? For my Day 8 map, I chose to visualize the average rainfall in millimeters/year between 1983 and 2000. Why 1983? Because "Africa" by Toto came out in 1982. Why 2000? Because that's where the data ended. 

This map clearly shows that the eastern parts of South Africa got a higher amount of annual rainfall on average than the western regions of the country. However, the data I found did not have records for several municipalities, particularly in the east, hence the greyed-out locations. I've identified the top 5 and bottom 5 municipalities for average annual rainfall and labeled them. Some of the weather reporting stations matched to the same municipality, which is why you might see two labels pointing to the same polygon but listing different values. They're capturing different parts of that polygon.

The colors for this map are drawn from the South African flag: red for the dry parts, green for the wet parts, black and blue for the fill scale, gold for the borders and background, and white for the header and footer panels. The data for this map came from the [South African Environmental Observation Network (SAEON)](https://livingatlas-dcdev.opendata.arcgis.com/datasets/044f1e57cf1e4e489e2d9d89734f3d5a_0/about), as well as [this random person's upload of municipality boundaries](https://dataportal-mdb-sa.opendata.arcgis.com/datasets/b415f05c9d0648bfa2b042aa799059ad/about) and [Princeton University for the nation-level shapefile of South Africa I used in preparing the data for this map.](https://maps.princeton.edu/catalog/stanford-qt291sw6359)

## Day 9: Hexagons

#### Map: DW-Nominate Scores in the 118th U.S. House of Representatives

![Day 9: Hexagons](day9_hexagons/day9_hexagons.png?raw=true "DW-Nominate Scores in the 118th U.S. House of Representatives")

For this map, I chose to visualize DW-Nominate scores. DW-Nominate is a method political scientists use to quantify a legislator's position on a left-right spectrum relative to other legislators based on their votes in a given legislative session. In the U.S., scores below 0 indicate more left-leaning legislators, while scores above 0 indicate more right-leaning legislators (like a number line). This map uses a hexagon shapefile from the [Daily Kos (available through this link)](https://www.dailykos.com/stories/2022/9/20/2122648/-Sagebrush-doesn-t-vote-But-what-if-it-did-Introducing-the-2022-congressional-district-hexmap) and DW-Nominate scores from [voteview.com](https://voteview.com/data). While the version shown here in the README is static, this map is interactive, and I've included an HTML version in the Day 9 folder which has labels for each congressional district with the name and party of its representative as well as their DW-Nominate score. Despite the interactive nature of this map, this was honestly one of the easier ones I've done for this challenge so far. 

## Day 10: North America

#### Map: County Public Health Department Social Media Accounts in the U.S.

![Day 10: North America](day10_northamerica/day10_northamerica.png?raw=true "County Health Department Social Media Accounts in the U.S.")

For this map, I re-used some data I personally compiled for a project for my master's degree. That project centered on the social media presences of county public health departments across the U.S. during the COVID-19 pandemic. I was mainly looking if counties which had these accounts (and furthermore, which had active accounts) had notably different rates of COVID infection or death. (Spoiler alert: they didn't.) But the data lives on, even if it is only accurate as of December 2021. This is a filled polygon map of U.S. counties, colored by whether or not they have a Facebook account for their public health department, a Twitter account, both, or neither. Some really populous counties, like Bernalillo County, New Mexico, don't have social media accounts for their public health department, while some small rural counties, like the ones in Nebraska and Idaho, do have these accounts. This is because many rural counties opted to consolidate their public health departments into multi-county public health districts for efficiency, and these multi-county districts have social media accounts. If you look at the code, you can see which of my repos I'm pulling this data from, and that repo also has data on those multi-county departments as well as a shapefile of their boundaries. 

Is this a bit of a cop-out? Yes. Do I care? No.

## Day 12: South America

#### Map: Orinoco Flow: Cities and Towns Along the Orinoco River

![Day 12: South America](day12_southamerica/day12_southamerica.png?raw=true "Cities and Towns Along the Orinoco River")

Don't get it twisted, I don't like Orinoco Flow as a song all that much. That being said, the title did provide the inspiration for my Day 12 map, which shows cities and towns in Colombia and Venezuela along the Orinoco River. Locations are identified by labels and sized according to population, and labels are colored by country. 

Data for the river came from the [UN Food and Agriculture Organization](https://data.apps.fao.org/catalog/iso/12d7d96a-b0ea-4aea-aedc-b9c9a80cab7f), and the coordinates for the different cities came from [simplemaps.com](https://simplemaps.com/data/co-cities).
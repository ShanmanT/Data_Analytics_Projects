library(tidyverse)
library(sf)
library(rnaturalearthdata)
library(rnaturalearth)
library(rgeos)

theme_set(theme_bw())

Factbook <- read_csv("cia-factbook.txt")
world2 <- rename(world2, country = name)

Factbook2 <- left_join(Factbook,world2, by = 'country')

Factbook2 %>% ggplot() + geom_sf(aes(fill = exports, geometry = geometry))
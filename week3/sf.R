library(sp)
library(sf)
library(ggplot2)

data(meuse)
data(meuse.grid)

# convert sample points
meuse_sf <- st_as_sf(meuse, coords = c("x", "y"), crs = 28992)

# convert grid points
grid_sf <- st_as_sf(meuse.grid, coords = c("x", "y"), crs = 28992)

ggplot() +
  geom_sf(data = grid_sf, color = "black", size = 0.3) +
  geom_sf(data = meuse_sf, color = "red", size = 2) +
  coord_sf() +
  theme_minimal() +
  labs(title = "Meuse grid and sampling points (sf)")

ggplot() +
  geom_sf(data = grid_sf, color = "grey80", size = 0.2) +
  geom_sf(data = meuse_sf, color = "red", size = 2) +
  coord_sf() +
  theme_minimal() +
  labs(title = "Grid + Meuse observations (sf format)")
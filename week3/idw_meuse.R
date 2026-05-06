# Load libraries
library(sp)
library(gstat)
library(raster)
library(ggplot2)

# Load data
data(meuse)
head(meuse)
data(meuse.grid)
head(meuse.grid)

# Convert to spatial objects
coordinates(meuse) <- ~x+y
coordinates(meuse.grid) <- ~x+y
gridded(meuse.grid) <- TRUE

##    Plot the grid
data(meuse.grid)
coords <- as.data.frame(meuse.grid)[, c("x", "y")]
ggplot(coords, aes(x = x, y = y)) +
  geom_point(size = 0.5, color = "black") +
  coord_equal() +
  theme_minimal() +
  labs(title = "Grid structure (meuse dataset)")

meuse_df <- as.data.frame(meuse)
ggplot() +
  geom_point(data = coords,
             aes(x = x, y = y),
             size = 0.5, color = "black") +
  geom_point(data = meuse_df,
             aes(x = x, y = y),
             color = "red", size = 2) +
  coord_equal() +
  theme_minimal() +
  labs(title = "Grid structure with Meuse sampling points")

# Perform IDW interpolation
idw.out <- idw(zinc ~ 1, meuse, meuse.grid, idp = 2.0)

# Convert to data frame for ggplot
idw.df <- as.data.frame(idw.out)
head(idw.df)

# Visualize
ggplot() +
  geom_raster(data = idw.df, 
              aes(x = x, y = y, fill = var1.pred)) +
  geom_point(data = as.data.frame(meuse), 
             aes(x = x, y = y),
             color = "black", size = 1) +
  coord_equal() +
  scale_fill_viridis_c(name = "Predicted Zinc") +
  labs(
    title = "IDW Interpolation of Zinc Concentration",
    x = "X Coordinate",
    y = "Y Coordinate"
  ) +
  theme_minimal()

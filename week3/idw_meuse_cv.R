library(sp)
library(gstat)

data(meuse)
dim(meuse)
coordinates(meuse) <- ~x+y

idw_model <- gstat(
  formula = zinc ~ 1,
  locations = meuse,
  set = list(idp = 2)
)

# leave one out cross validation
cv_idw <- krige.cv(
  zinc ~ 1,
  meuse,
  model = NULL,   # NULL for IDW
  nfold = nrow(meuse),
  set = list(idp = 2)
)

head(cv_idw)
dim(cv_idw)

# Error measures
ME <- mean(cv_idw$residual)
RMSE <- sqrt(mean(cv_idw$residual^2))
MAE <- mean(abs(cv_idw$residual))

ME
RMSE
MAE

# Compare different IDW powers
powers <- c(1,2,3)

for(p in powers){
  
  cv <- krige.cv(
    zinc ~ 1,
    meuse,
    model = NULL,
    nfold = nrow(meuse),
    set = list(idp = p)
  )
  
  rmse <- sqrt(mean(cv$residual^2))
  
  cat("IDP =", p, " RMSE =", rmse, "\n")
}

## Plot for 3
idw_out <- idw(
  formula = zinc ~ 1,
  locations = meuse,
  newdata = meuse.grid,
  idp = 3
)
head(idw_out)

idw_df <- as.data.frame(idw_out)

## Visualise
ggplot(idw_df, aes(x = x, y = y)) +
  geom_raster(aes(fill = var1.pred)) +
  coord_equal() +
  scale_fill_viridis_c() +
  labs(
    title = "IDW Interpolation of Zinc (power = 3)",
    fill = "Zinc"
  ) +
  theme_minimal()

## Add some points
ggplot() +
  geom_raster(data = idw_df,
              aes(x = x, y = y, fill = var1.pred)) +
  geom_point(data = as.data.frame(meuse),
             aes(x = x, y = y),
             color = "black", size = 1) +
  coord_equal() +
  scale_fill_viridis_c() +
  labs(
    title = "IDW Zinc Surface (p = 3) with Sampling Points",
    fill = "Zinc"
  ) +
  theme_minimal()

library(terra)
library(raster)

nc_file_path <- "C:/Users/dagudelo/Downloads/Chirp_precip.nc"

# Load the NetCDF file
raster_data <- rast(nc_file_path)

# Load the shapefile
kenya <- getData(name = "GADM", country = "KE", level = 1)
x11()
plot(kenya)

# Filter the shapefile
target = kenya[kenya$NAME_1=="Kajiado"|kenya$NAME_1=="Nairobi" , ] 
x11()
plot(target)

# Crop and Mask 
crop_data <- terra::crop(raster_data, vect(target), mask=TRUE)
x11()
plot(crop_data)

# Raster to dataframe
data_table = t(terra::as.data.frame(crop_data, xy = TRUE, na.rm = TRUE))
rownames(data_table) <- NULL ; colnames(data_table) <- NULL
data_table = as.data.frame(data_table)
dim(data_table)
View(data_table)

# Making dates
monthly_dates <- seq(as.Date("1981-01-01"), as.Date("2023-09-01"), by = "1 month")
final_dates <- as.character(format(monthly_dates, "%Y-%m"))
length(final_dates)

data_final =cbind.data.frame(c("cpt:X","cpt:Y",final_dates),data_table)
View(data_final)

# Save dataframe

write.csv(data_final,"C:/Users/dagudelo/Downloads/chirps_table.csv",row.names = F)

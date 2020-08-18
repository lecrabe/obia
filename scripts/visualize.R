################### VIZUALIZATION
#plotRGB(mosaic,stretch="hist")
#plot(segment,add=T)

plot(raster(res_final))
plot(readOGR(train_shp_file),add=T)

table(dbf_res[,code_field],useNA = "always")


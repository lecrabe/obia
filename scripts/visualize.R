################### VIZUALIZATION
#plotRGB(mosaic,stretch="hist")
#plot(segment,add=T)

plot(raster(res_final))
#plot(readOGR(segment_file),add=T)
plot(spdf,add=T)
table(dbf_res[,code_field],useNA = "always")


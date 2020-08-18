
################### PROCESS - PREPARE TRAINING DATA
df           <- read.csv(train_file)
codes        <- data.frame(cbind(unique(df[,code_field]),1:length(unique(df[,code_field]))))
names(codes) <- c(code_field,num_field)
dd           <- merge(df,codes,all.x=T,by.x=code_field,by.y=code_field)

spdf         <- SpatialPointsDataFrame(coords = dd[,c(xcoord_field,ycoord_field)],
                                       data   = dd[,c(id_field,xcoord_field,ycoord_field,code_field,num_field)],
                                       proj4string=CRS("+init=epsg:4326"))

mosaic       <- brick(mosaic_file)
nbands       <- nbands(mosaic)
band_names   <- names(mosaic)

dbf <- spdf@data
dbf[,c("tmp_id",band_names)] <- extract(mosaic,spdf,df=T)

train_sel <- dbf[!is.na(dbf[,band_names[1]]),]

table(train_sel[,code_field])

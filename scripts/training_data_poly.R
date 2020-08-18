################### PROCESS - PREPARE TRAINING DATA ID
shp <- readOGR(train_file)
shp@data[,id_field] <- row(shp)[,1]
head(shp)

writeOGR(shp,
         train_shp_file,
         substr(basename(train_shp_file),1,nchar(basename(train_shp_file))-4),
         "ESRI Shapefile",
         overwrite_layer = T)


################### PROCESS - CONVERT TRAINING AS TIF
system(sprintf("python3 %s/oft-rasterize_attr_Int32.py -v %s -i %s -o %s -a %s",
               scriptdir,
               train_shp_file,
               mosaic_file,
               train_tif_file,
               id_field
))


################### PROCESS - EXTRACT SPECTRAL SIGNATURE ON THE TRAINING
system(sprintf("oft-stat -i %s -o %s -um %s -nostd",
               mosaic_file,
               train_st,
               train_tif_file))


################### PROCESS - PREPARE TRAINING DATA
mosaic       <- brick(mosaic_file)
nbands       <- nbands(mosaic)
band_names   <- names(mosaic)


df           <- read.table(train_st)
names(df)    <- c("tr_id","tr_sz",band_names)

dbf          <- read.dbf(train_dbf_file)
head(dbf)

dd           <- merge(df,dbf,all.x=T,by.x="tr_id",by.y=id_field)

codes        <- data.frame(cbind(unique(dbf[,code_field]),1:length(unique(dbf[,code_field]))))
names(codes) <- c(code_field,num_field)

dt           <- merge(dd,codes,all.x=T,by.x=code_field,by.y=code_field)

train_sel    <- dt[!is.na(dt[,band_names[1]]),]

table(train_sel[,code_field])
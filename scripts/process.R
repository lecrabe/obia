
################### PROCESS - SEGMENTATION AS SHP
system(paste("otbcli_Segmentation", 
             "-in",mosaic_file,
             "-mode vector",
             "-mode.vector.out",segment_file,
             "-filter meanshift",
             sep=" "))


################### PROCESS - CONVERT SEGMENTATION AS TIF
system(sprintf("python3 %s/oft-rasterize_attr_Int32.py -v %s -i %s -o %s -a %s",
               scriptdir,
               segment_file,
               mosaic_file,
               seg_tif_file,
               "DN"
))


################### PROCESS - EXTRACT SPECTRAL SIGNATURE ON THE SEGMENTS 
system(sprintf("oft-stat -i %s -o %s -um %s -nostd",
               mosaic_file,
               img_sg_st,
               seg_tif_file))


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


################### PROCESS - SUPERVISED CLASSIFICATION MODEL
training      <- train_sel[,c(num_field,band_names)]
fit           <- randomForest(as.factor(class_num) ~ . ,ntree=400, mtry=3, data=training)

img_segs_spec <- read.table(img_sg_st)
names(img_segs_spec) <- c("sg_id","sg_sz",band_names)
 

results       <- predict(fit,img_segs_spec,keep.forest=TRUE)
resultsWithId <- data.frame(img_segs_spec[,1] , results , as.is=TRUE)
res_all       <- resultsWithId[,c(1,2)]

write.table(file=res_sg_st,res_all,sep=" ",quote=FALSE, col.names=FALSE,row.names=FALSE)
#res_all <- read.table(res_sg_st)



####################  PROCESS - EXPORT RESULTS IN SEGMENTS
img_segs_spec[,num_field] <- res_all$results
img_segs_spec[rowSums(img_segs_spec[,band_names]) < 0.1,num_field] <- 0

dbf_res <- merge(img_segs_spec,codes,by.x=num_field,by.y=num_field,all.x=T)
dbf_res <- arrange(dbf_res,sg_id)

file.rename(seg_dbf_file,seg_dbf_bckp)

write.dbf(dbf_res,seg_dbf_file)

# #########################################
# RASTER VERSION BELOW
# #########################################

####################  PROCESS - RECLASSIFY SEGMENTS
system(sprintf("(echo %s; echo 1; echo 1; echo 2; echo 0) | oft-reclass -oi  %s %s",
               res_sg_st,
               res_reclass,
               seg_tif_file))


####################  PROCESS - CONVERT RESULTS TO BYTE
system(sprintf("gdal_translate -ot byte -co COMPRESS=LZW %s %s",
               res_reclass,
               res_recl_byte
))


####################  PROCESS - GENERATE MOSAIC MASK
band_ls <- paste0("#",1:nbands)

band_equation <- paste0(band_ls[1]," 0 > ",
                        paste0((sapply(2:nbands,function(x){paste0(band_ls[x]," 0 > *")})),collapse = " "))

system(sprintf("(echo 1; echo \"%s\") | oft-calc -ot Byte %s %s",
               band_equation,
               mosaic_file,
               mosaic_mask))


####################  PROCESS - COMBINE WITH MASK AND CONVERT RESULTS TO BYTE
system(sprintf("gdal_calc.py -A %s -B %s --type=Byte --co COMPRESS=LZW --outfile=%s --calc=%s",
               mosaic_mask,
               res_reclass,
               res_recl_byte,
               "\"(A>0)*B\""))


####################  PROCESS -  CREATE A PSEUDO COLOR TABLE
cols <- col2rgb(c("darkgreen","grey"))
pct  <- data.frame(cbind(c(1:2),
                        cols[1,],
                        cols[2,],
                        cols[3,]))

write.table(pct,color_table,row.names = F,col.names = F,quote = F)


####################  PROCESS -  ADD PSEUDO COLOR TABLE TO RESULTS
system(sprintf("(echo %s) | oft-addpct.py %s %s",
               color_table,
               res_recl_byte,
               res_pct
))


####################  PROCESS - COMPRESS FINAL RESULTS
system(sprintf("gdal_translate -ot byte -co COMPRESS=LZW %s %s",
               res_pct,
               res_final
))




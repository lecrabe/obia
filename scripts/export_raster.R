# #########################################
# RASTER EXPORT OF RESULTS
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

####################  PROCESS - GENERATE COLOR TABLE
#cols <- col2rgb(sample(colors(),nrow(codes)))
cols <- col2rgb(my_colors)

pct  <- data.frame(cbind(codes$class_num,
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


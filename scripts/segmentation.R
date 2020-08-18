
################### PROCESS - SEGMENTATION AS SHP
system(paste("otbcli_Segmentation", 
             "-in",mosaic_file,
             "-mode vector",
             "-mode.vector.out",segment_file,
             "-filter meanshift",
             "-mode.vector.outmode ovw",
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
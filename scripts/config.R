rootdir    <- paste0(normalizePath("~"),"/obia/")

scriptdir  <- paste0(rootdir,"scripts/")

data_dir   <- paste0(rootdir,"data/")
aoi_dir    <- paste0(data_dir,"aoi/")
mosaic_dir <- paste0(data_dir,"mosaic/")
segs_dir   <- paste0(data_dir,"segments/")
train_dir  <- paste0(data_dir,"training/")
class_dir  <- paste0(data_dir,"classification/")

dir.create(data_dir,showWarnings = F)
dir.create(mosaic_dir,showWarnings = F)
dir.create(aoi_dir,showWarnings = F)
dir.create(segs_dir,showWarnings = F)
dir.create(train_dir,showWarnings = F)
dir.create(class_dir,showWarnings = F)

setwd(data_dir)

source(paste0(scriptdir,"packages.R"))


################### ALL VARIABLES
mosaic_mask    <- paste0(mosaic_dir,"mask.tif")

segment_file   <- paste0(segs_dir,"segments.shp")
seg_dbf_file   <- paste0(segs_dir,"segments.dbf")
seg_dbf_bckp   <- paste0(segs_dir,"segments_bckup.dbf")
seg_tif_file   <- paste0(segs_dir,"segments.tif")
img_sg_st      <- paste0(segs_dir,"spectral_lib.txt")

train_shp_file <- paste0(train_dir,"train.shp")
train_tif_file <- paste0(train_dir,"train.tif")
train_dbf_file <- paste0(train_dir,"train.dbf")
train_st       <- paste0(train_dir,"spectral_training.txt")

res_sg_st      <- paste0(class_dir,"results_segs.txt")
res_reclass    <- paste0(class_dir,"tmp_results.tif")
res_recl_byte  <- paste0(class_dir,"tmp_results_byte.tif")
res_pct        <- paste0(class_dir,"tmp_results_pct.tif")
color_table    <- paste0(class_dir,"color_table.txt")
res_final      <- paste0(class_dir,"obia.tif")


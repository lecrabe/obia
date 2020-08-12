################### USER INPUTS SUDAN TEST
#mosaic_file  <- paste0(mosaic_dir,"aoi_sudan_l8_2020.tif")
#mosaic_file  <- paste0(mosaic_dir,"clip.tif")
#train_file   <- paste0(train_dir,"ceo-aa_sdn_frel_ad-sample-data-2020-05-27_final.csv")

# xcoord_field <- "LON"
# ycoord_field <- "LAT"
# code_field   <- "LC.IN.2018"
# id_field     <- "PLOT_ID" 
# num_field    <- "class_num"

################### USER INPUTS TANZANIA
mosaic_file  <- paste0(mosaic_dir,"kaliua_s2_2019.tif")
train_file   <- paste0(train_dir,"Kaliua_LCCS_Classifiedplots_CSV.csv")

################### REACTIVES - TRAINING FILE
head(read.csv(train_file))

xcoord_field <- "location_x"
ycoord_field <- "location_y"
code_field   <- "lccs_label"
id_field     <- "id" 
num_field    <- "class_num"
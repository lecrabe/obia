################### USER INPUTS UGANDA
mosaic_file  <- paste0(mosaic_dir,"clip_uganda.tif")
train_file   <- paste0(train_dir,"training_UGA.shp")

################### REACTIVES - TRAINING FILE HEADERS
head(readOGR(train_file))

code_field     <- "Code"

id_field       <- "unique_id" # leave as is if no such field exists
num_field      <- "class_num" # leave as is if no such field exists


####################  PRECISE THE PSEUDO COLOR TABLE
my_colors <- c("green","pink","brown","grey","yellow","orange","darkgrey","purple","darkblue")


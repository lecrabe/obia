####################################################################################
#######          OBJECT BASED IMAGE ANALYSIS                    ####################
#######          FAO Open Foris SEPAL project                   ####################
#######          Contact: remi.dannunzio@fao.org                ####################
####################################################################################

####################################################################################
# FAO declines all responsibility for errors or deficiencies in the database or
# software or in the documentation accompanying it, for program maintenance and
# upgrading as well as for any # damage that may arise from them. FAO also declines
# any responsibility for updating the data and assumes no responsibility for errors
# and omissions in the data provided. Users are, however, kindly asked to report any
# errors or deficiencies in this product to FAO.
####################################################################################

####################################################################################
## Last update: 2020/08/19
####################################################################################

####################################################################################
###### RUN THIS FIRST
####################################################################################
source(paste0(paste0(normalizePath("~"),"/obia/scripts/"),"config.R"))


####################################################################################
###### EDIT THE INPUTS FILE AND ADJUST YOUR VARIABLES (POLYGON TRAINING DATA)
####################################################################################
source(paste0(scriptdir,"inputs_poly.R")        ,echo = T)
source(paste0(scriptdir,"training_data_poly.R") ,echo = T)


####################################################################################
###### EDIT THE INPUTS FILE AND ADJUST YOUR VARIABLES (CSV POINT FILE TRAINING DATA)
####################################################################################
# source(paste0(scriptdir,"inputs_csv.R")        ,echo = T)
# source(paste0(scriptdir,"training_data_csv.R") ,echo = T)


####################################################################################
###### RUN THE PROCESS SCRIPTS
####################################################################################
source(paste0(scriptdir,"segmentation.R")       ,echo = T)
source(paste0(scriptdir,"random_forest.R")      ,echo = T)
source(paste0(scriptdir,"export_vector.R")      ,echo = T)
source(paste0(scriptdir,"export_raster.R")      ,echo = T)


####################################################################################
###### VISUALIZE AND CLEAN
####################################################################################
source(paste0(scriptdir,"visualize.R"),echo=T)
source(paste0(scriptdir,"clean.R"))

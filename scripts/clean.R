########################################
## Clean all
system(sprintf(paste0("rm -f -r ",class_dir,"/","tmp*.tif")))

rm(img_segs_spec)
rm(res_all)
rm(resultsWithId)
gc()
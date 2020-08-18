####################  PROCESS - EXPORT RESULTS IN SEGMENTS
img_segs_spec[,num_field] <- res_all$results
img_segs_spec[rowSums(img_segs_spec[,band_names]) < 0.1,num_field] <- 0

dbf_res <- merge(img_segs_spec,codes,by.x=num_field,by.y=num_field,all.x=T)
dbf_res <- arrange(dbf_res,sg_id)

file.rename(seg_dbf_file,seg_dbf_bckp)

write.dbf(dbf_res,seg_dbf_file)
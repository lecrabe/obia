################### PROCESS - SUPERVISED CLASSIFICATION MODEL
training      <- train_sel[,c(num_field,band_names)]
fit           <- randomForest(as.factor(class_num) ~ . ,ntree=400, mtry=3, data=training)

img_segs_spec <- read.table(img_sg_st)
names(img_segs_spec) <- c("sg_id","sg_sz",band_names)


results       <- predict(fit,img_segs_spec,keep.forest=TRUE)
resultsWithId <- data.frame(img_segs_spec[,1] , results , as.is=TRUE)
res_all       <- resultsWithId[,c(1,2)]

write.table(file=res_sg_st,res_all,sep=" ",quote=FALSE, col.names=FALSE,row.names=FALSE)

read_meas <- function(sourc='test', opt.nrows = 10){
  d.test <- read.table(paste('UCI HAR Dataset/',sourc,'/X_',sourc,'.txt',sep=''),
                       sep = "",nrows = opt.nrows, header=FALSE,
                       col.names = md.feat$feat_name)
  d.test <- d.test[,md.feat.mean_std]
  d.test.subj <- read.table(paste('UCI HAR Dataset/',sourc,'/subject_',sourc,'.txt',sep=''), 
                            sep = "",nrows = opt.nrows, header=FALSE)
  d.test$subject <- d.test.subj$V1
  d.test.actv <- read.table(paste('UCI HAR Dataset/',sourc,'/y_',sourc,'.txt',sep=''),
                            sep = "",nrows = opt.nrows, header=FALSE)
  d.test$actv_name <- md.actv[as.vector(d.test.actv$V1),2]
  ##d.test$source <- sourc
  d.test
}

library(dplyr)
opt.nrows <- -1
unzip('getdata-projectfiles-UCI HAR Dataset.zip')

md.feat <- read.table('UCI HAR Dataset/features.txt',sep ="",header = FALSE,
                      col.names = c('feat_num','feat_name'))
md.feat.mean_std <- md.feat$feat_num[grepl("*mean()*",md.feat$feat_name)|
                                       grepl("*std()*",md.feat$feat_name)]
md.actv <- read.table('UCI HAR Dataset/activity_labels.txt',sep ="",header = FALSE,
                      col.names = c('actv_num','actv_name'))
d.test <-read_meas('test', opt.nrows)
d.train <-read_meas('train', opt.nrows)

d.all <- union(d.test,d.train)
d.tidy <- (d.all %>% group_by(actv_name,subject)
                 %>% summarise_each(funs(mean)))

write.table(d.tidy,'UCI HAR Dataset/result.txt',row.name=FALSE)

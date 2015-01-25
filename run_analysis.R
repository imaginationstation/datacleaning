# run_analysis.R

library(dplyr)

#SETUP
# Assume data is in the current working directory as would be uncompressed
dataUrl <- "./UCI HAR Dataset"

# Actvivity label mapping.
activityLabels <- tbl_df(read.table(file = paste(dataUrl, "activity_labels.txt", sep = "/"), stringsAsFactors = FALSE, 
                            col.names = c("id", "label")))

# Variable ID's
varIds <- read.table(file = paste(dataUrl, "features.txt", sep = "/"), stringsAsFactors = FALSE)[, 2]

# Helper functions
labelMap <- function(path) {
  labels <- as.numeric(readLines(paste(dataUrl, path, sep = "/")))
  mappedLabels <- activityLabels[match(labels, activityLabels$id), "label"]$label
  mappedLabels
}
subjects <- function(path) {
  subjects <- as.numeric(readLines(paste(dataPath, path, sep = "/")))
  subjects
}


#WORK
# "Tidy" the ids - mean to Mean, std to StdDev names and remove problematic characters
varIds <- gsub("-mean", "Mean", varIds)
varIds <- gsub("-std", "StdDev", varIds)
varIds <- gsub("[-()]", "", varIds)

# Training data
training <- tbl_df(read.table(file = paste(dataUrl, "train/X_train.txt", sep = "/"), col.names = varIds)) %>%
  mutate(subject = subjects("train/subject_train.txt"), activity = labelMap("train/Y_train.txt"))

# Test data
test <- tbl_df(read.table(file = paste(dataUrl, "test/X_test.txt", sep = "/"), col.names = varIds)) %>%
  mutate(subject = subjects("test/subject_test.txt"), activity = labelMap("test/Y_test.txt"))

# Merged data
merge <- rbind_list(training, test)

# Group the activity
merge <- merge %>%
  select(subject, activity, matches("Mean|StdDev", ignore.case = FALSE)) %>%
    arrange(subject, activity) %>%
      group_by(subject, activity) %>%
        summarise_each(funs(mean))

# Add a prefix
n <- colnames(merged)[-(1:2)]
colnames(merged)[-(1:2)] <- paste("Mean", n, sep = "")
rm(n)


# OUTPUT
write.table(merge, "./datacleaning_results.txt", fileEncoding = "ASCII", row.names = FALSE) 

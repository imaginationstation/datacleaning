# Code Book

***
#### Package Dependencies
* [dplyr]("http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html") 

***
#### Setup

Name           | Description
-------------- | -----------
dataURL        | The location of the data relative to the working directory, currently assumed to be in "UCI HAR Dataset"
activityLabels | A data frame mapping activity ID' to labels
varIds         | A data frame of feature variable ids 
training       | The training data frame to be merged
test           | The test data frame 
merge          | The merged training and test data frame

***
#### Helper Functions
* **labelMap(path)** - Given a path to a label file, results in a map of the id value to the label 
* **subjects(path)** - Given a path to a subject file, results in a vector representation 

***
#### Work
1. Variable ids are cleaned removing problematic characters 
1. Training data loaded with the labels taken from the varIds data frame and subject variable added
1. Test data loaded with labels taken from varIds data and subject variable added
1. Training and Test data are row merged
1. Merged data is then summarized, grouped, and arragned by subject and activity with the Mean and StdDev calculated for each
1. Merged data is written out to a file ./datacleaning_results.txt" 


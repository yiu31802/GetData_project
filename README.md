# run_analysis.R

## Preparation
On top of basic R environment, your R must have:

* `plyr` package
* `reshape2` package

The data we use can be downloaded from:
* https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

So basically, you just `git clone` this script git, and download the data from the location above.
Here's the typical example command flow to run the script:

~~~
$ git clone <URL-to-this-git>.git scriptdir
$ wget https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
$ unzip *.zip
$ cp scriptdir/run_analysis.R UCI\ HAR\ Dataset
$ cd UCI\ HAR\ Dataset
$ R

> source("run_analysis.R")
~~~

## Script overview
The analysis is divided into 6 steps.

* Step 0: Read files from local directory and store them in RAM memory as data.frame

  * The definition of each file is found in `UCI\ HAR\ Dataset/README.txt`.

* Step 1: Combine the two datasets, "test" and "train", into one dataset called 'merged'

  * In this step, the column names are also set by reading `features` data.frame in the second
    column.

* Step 2: As we examin only the mean and std values, only the corresponding columns are fultered.

* Step 3: Map the activity number (1-6) to the name defined in `activitylabels` data.frame.

* Step 4: Make the column name of each variable more meaningful and better suited for R.

   * Remove the 't' character at the beginning as it does not hold special meaning in our
     analaysis.
   * Replaced 'f' with FFT to mean Fast Fourier Transformation
   * Do not use abbreviated words such as 'Acc' and 'Mag'
   * Do not use `-`  and `()` as they can lead to some R unexpected behavior.

* Step 5: Melt the data once, and reshape the data in a tidy format.
   * As the data.frame now is too wide and hard to get the tidy result, the data.frame is
     made in a tall form by `melt` function from `reshape2` library. This resulted `melted`
     table is easier to deal with; we can use `dcast` to reshape the data. The resulted
     `casted` table is yet unordered like `1, 10, 11, 20, 2...`, it must be reordered
     by `factor` and `arrange` function from `plyr` package.
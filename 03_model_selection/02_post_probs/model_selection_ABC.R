####################################
##### Model selection with ABC #####
####################################

# remove all objects
rm(list = ls())

# 1) import data

    # load observed summary statistics (as vector)
    obs_stat <- read.table(file="../../ABCstat_observed_formatted.txt.gz", h=T)
        # remove dataset column
        obs_stat <- obs_stat[,-1]
        # create vector of stats to be kept
        STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260)
        # keep only selected stats
        obs_stat <- obs_stat[,STATS]
    TARGET <- as.matrix(obs_stat)[1,]

    # load simulated summary statistics (as matrix or data frame)
        # null model
        load('../01_stats_objects/01_null/ABCstat_null_interspeNoMig*txt.gz.Rdata')
        data_null <- stat
        rm(stat, na_stat)
        # full model
        load('../01_stats_objects/02_full/ABCstat_full_interspeMig*txt.gz.Rdata')
        data_full <- stat
        rm(stat, na_stat)
    SUMSTAT <- rbind(data_null, data_full)

    # create model index (as vector)
        n_data_null <- nrow(data_null)
        n_data_full <- nrow(data_full)
    INDEX <- c(rep("null", n_data_null), rep("full", n_data_full))

# 2) set parameters of ABC

    # indicate required proportion of points nearest the target value
    TOL <- 0.01

    # indicate the type of simulation required
    METHOD <- "neuralnet"

# 3) estimate posterior model probabilities

    # load abc package
    library(abc)

    # estimate posterior model probabilities
    modsel <- postpr(target=TARGET, index=INDEX, sumstat=SUMSTAT, tol=TOL, method=METHOD)

    # save estimation of posterior model probabilities
    save(modsel, file="./modsel.Rdata")

    # summarise result
    summary(modsel)

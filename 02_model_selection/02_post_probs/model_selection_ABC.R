####################################
##### Model selection with ABC #####
####################################

# remove all objects
rm(list = ls())

# 1) import data

    # load observed summary statistics (as vector)
    obs_stat <- read.table(file = "../../01_model_simulations/ABCstat_observed_formatted.txt.gz", h = T)
        # remove dataset column
        obs_stat <- obs_stat[, -1]
        # create vector of stats to be kept
        STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260)
        # keep only selected stats
        obs_stat <- obs_stat[, STATS]
    TARGET <- as.matrix(obs_stat)[1, ]

    # load simulated summary statistics (as matrix or data frame)
        # NM model
        load('../01_stats_objects/01_NM/ABCstat_NM*txt.gz.Rdata')
        data_NM <- stat
        rm(stat, na_stat)
        # CM model
        load('../01_stats_objects/02_CM/ABCstat_CM*txt.gz.Rdata')
        data_CM <- stat
        rm(stat, na_stat)
        # RM model
        load('../01_stats_objects/03_RM/ABCstat_RM*txt.gz.Rdata')
        data_RM <- stat
        rm(stat, na_stat)
        # AM model
        load('../01_stats_objects/04_AM/ABCstat_AM*txt.gz.Rdata')
        data_AM <- stat
        rm(stat, na_stat)
    SUMSTAT <- rbind(data_NM, data_CM, data_RM, data_AM)

    # create model index (as vector)
        n_data_NM <- nrow(data_NM)
        n_data_CM <- nrow(data_CM)
        n_data_RM <- nrow(data_RM)
        n_data_AM <- nrow(data_AM)
    INDEX <- c(rep("NM", n_data_NM), rep("CM", n_data_CM), rep("RM", n_data_RM), rep("AM", n_data_AM))

# 2) set parameters of ABC

    # indicate required proportion of points nearest the target value
    TOL <- 0.05

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

####################################
##### Goodness of fit with PCA #####
####################################

# remove all objects
rm(list = ls())

# load library abc
library(abc)

# 1) import data

    # load observed summary statistics (as vector)
    obs_stat <- read.table(file =
        "../01_model_simulations/ABCstat_observed_formatted.txt.gz", h = T)
        # remove dataset column
        obs_stat <- obs_stat[, -1]
        # create vector of stats to be kept
        STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260)
        # keep only selected stats
        obs_stat <- obs_stat[, STATS]
    TARGET <- as.matrix(obs_stat)[1, ]
    	rm(obs_stat, STATS)

    # load simulated summary statistics (as matrix or data frame)
        # NM model
        load('../02_model_selection/01_stats_objects/01_NM/ABCstat_NM*txt.gz.Rdata')
        data_NM <- stat
        rm(stat, na_stat)
        # RM model
        load('../02_model_selection/01_stats_objects/03_RM/ABCstat_RM*txt.gz.Rdata')
        data_RM <- stat
        rm(stat, na_stat)
    SUMSTAT <- rbind(data_NM, data_RM)

    # create model index (as vector)
    INDEX <- c(rep("NM", nrow(data_NM)), rep("RM", nrow(data_RM)))


# 2) run goodness of fit with PCA

    # goodness of fit with PCA
    pdf(file = "./gfitpca.pdf")
    par(mar = c(4, 4, 1, 1))
    gfitpca(target = TARGET, sumstat = SUMSTAT, index = INDEX, cprob = 0.05,
        xlim = c(-18, 18), ylim = c(-14, 12))
    dev.off()

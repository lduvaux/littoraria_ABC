####################################################
##### Cross-validation for model selection ABC #####
####################################################

# remove all objects
rm(list = ls())

# extract command line arguments
args <- commandArgs(trailingOnly = TRUE)

# load abc package
library(abc)

# 1) import data

    # load simulated summary statistics (as matrix or data frame)
        # NM model
        load('../02_model_selection/01_stats_objects/01_NM/ABCstat_NM*txt.gz.Rdata')
        data_NM <- stat
        rm(stat, na_stat)
        # CM model
        load('../02_model_selection/01_stats_objects/02_CM/ABCstat_CM*txt.gz.Rdata')
        data_CM <- stat
        rm(stat, na_stat)
        # RM model
        load('../02_model_selection/01_stats_objects/03_RM/ABCstat_RM*txt.gz.Rdata')
        data_RM <- stat
        rm(stat, na_stat)
        # AM model
        load('../02_model_selection/01_stats_objects/04_AM/ABCstat_AM*txt.gz.Rdata')
        data_AM <- stat
        rm(stat, na_stat)
    SUMSTAT <- rbind(data_NM, data_CM, data_RM, data_AM)

    # create model index (as vector)
    INDEX <- c(rep("NM", nrow(data_NM)),
               rep("CM", nrow(data_CM)),
               rep("RM", nrow(data_RM)),
               rep("AM", nrow(data_AM)))

    # load estimation of posterior model probabilities
        load('../02_model_selection/02_post_probs/modsel.Rdata')
    POSTPR.OUT <- modsel
        rm(modsel)


# 2) set parameters of cross-validation

    # set the size of the cross-valiation sample for each model
    NVAL <- 5

    # set the tolerance rate
    TOLS <- 0.01


# 3) run cross-validation

    # cross-validation
    cv.modsel <- cv4postpr(index = INDEX, sumstat = SUMSTAT, postpr.out = POSTPR.OUT,
                 nval = NVAL, tols = TOLS)

    # extract model probabilities
    assign(paste("model.probs", args[1], args[2], sep = "."),
        get(paste("tol", TOLS, sep = ""), cv.modsel$model.probs))

    # save result
    save(list=paste("model.probs", args[1], args[2], sep = "."),
        file = paste("model.probs", args[1], args[2],"Rdata", sep = "."))

    # summarise result
    summary(cv.modsel)

    # plot result
#   plot(cv.modsel, file = "cv_modsel")

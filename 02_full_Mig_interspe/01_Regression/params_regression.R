N_TASKS <- 5 # number of datasets
N_REP <- 500
N_DATA <- N_TASKS * N_REP

# priors
PREF_PRIOR <- "priors_full_interspeMig" # prefix of the prior files
PATH_PRIOR <- "../" # path of the folder containing the prior files
PRIORS <- c(1:5, 7, 11, 13, 15, 16, 19) # vector of parameters to be kept for the abc analysis

# stats
PREF_STAT <- "ABCstat_full_interspeMig"
PATH_STAT <- PATH_PRIOR
STATS <- c(2:10) # vector of stats to be kept for the abc analysis

# bad simuls
PREF_BADS <- "Badsimul_thres1Pc_full_interspeMig"
PATH_BADS <- PATH_PRIOR


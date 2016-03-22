N_SETS <- 990515  # total number of datasets
MODEL <- "full_interspeMig"

# bad simuls
READ_BADF <- T  # do I load bad simulation text file? if not I load the Rdata bad simulation file
PREF_BADS <- paste("Badsimul_thres1Pc_", MODEL, "*txt.gz", sep="")
PATH_BADS <- "../../../02_full_Mig_interspe/01_prior2stats/"
RDATA_BAD <- paste(PREF_BADS, "Rdata", sep=".")

# priors
READ_PRIORF <- T    # do I load prior text file? if not I load Rdata prior file
PREF_PRIOR <- paste("priors_", MODEL, "*txt.gz", sep="")
PATH_PRIOR <-  PATH_BADS
PRIORS <- c(1:5, 7, 9, 11, 13, 15, 16, 19) # vector of parameters to be kept for the abc analysis
RDATA_PRIOR <- paste(PREF_PRIOR, "Rdata", sep=".")

# simulated stats
READ_STATF <- T    # do I load stat text file? if not I load Rdata stat file
PREF_STAT <- paste("ABCstat_", MODEL, "*txt.gz", sep="")
PATH_STAT <- PATH_BADS
STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260) # vector of stats to be kept for the abc analysis
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

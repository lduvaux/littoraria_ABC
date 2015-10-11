# How many datasets to load?
    # the original find_pls.R script reads 10,000 sets of stats and params
    # ben Jackson used 50,000 datasets in Butlin et al. Evolution 2014
N_SETS <- 3000
MODEL <- "full_interspeMig"

# bad simuls
READ_BADF <- T  # do I load bad simulation text file? if not I load the Rdata bad simulation file
PREF_BADS <- paste("Badsimul_thres1Pc_",MODEL,sep="")
PATH_BADS <- "../01_prior2stats/"
RDATA_BAD <- paste(PREF_BADS, "Rdata", sep=".")

# priors
READ_PRIORF <- T    # do I load prior text file? if not I load Rdata prior file
PREF_PRIOR <- paste("priors_",MODEL,sep="")
PATH_PRIOR <-  PATH_BADS
PRIORS <- c(1:5, 7, 9, 11, 13, 15, 16, 19) # vector of parameters to be kept for the abc analysis
RDATA_PRIOR <- paste(PREF_PRIOR, "Rdata", sep=".")

# simulated stats
READ_STATF <- T    # do I load stat text file? if not I load Rdata stat file
PREF_STAT <- paste("ABCstat_",MODEL,sep="")
PATH_STAT <- PATH_BADS
STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260) # vector of stats to be kept for the abc analysis
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

# PLS extraction
NUMCOMP <- 40   # nber of components to compute
DIROUT <- "./"

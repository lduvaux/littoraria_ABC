N_REP <- 500    # nber of dataset per file
N_FILES <- 5    # number fo files uploaded for PLS extraction
N_DATA <- N_FILES * N_REP
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
PRIORS <- c(1:5, 7, 11, 13, 15, 16, 19) # vector of parameters to be kept for the abc analysis
RDATA_PRIOR <- paste(PREF_PRIOR, "Rdata", sep=".")

# simulated stats
READ_STATF <- T    # do I load stat text file? if not I load Rdata stat file
PREF_STAT <- paste("ABCstat_",MODEL,sep="")
PATH_STAT <- PATH_BADS
STATS <- c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,110,111,112,113,114,115,116,117,146,147,148,149,150,151,152,153,182,183,184,185,186,187,188,189,218,219,220,221,222,223,224,225,254,255,256,257,258,259,260,261) # vector of stats to be kept for the abc analysis
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

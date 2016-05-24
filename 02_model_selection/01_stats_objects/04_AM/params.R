N_SETS <- 1e5  # total number of datasets
MODEL <- "AM"

# bad simuls
READ_BADF <- T    # load bad simulation text file? if not then load the Rdata bad simulation file
PREF_BADS <- paste("Badsimul_thres1Pc_", MODEL, "*txt.gz", sep="")
PATH_BADS <- "../../../01_model_simulations/04_AM/01_prior2stats/"
RDATA_BAD <- paste(PREF_BADS, "Rdata", sep=".")

# priors
READ_PRIORF <- T  # load prior text file? if not then load Rdata prior file
PREF_PRIOR <- paste("priors_", MODEL, "*txt.gz", sep="")
PATH_PRIOR <-  PATH_BADS
PRIORS <- c(1:5, 7, 9:11, 14, 15, 19, 21, 23, 24, 27) # vector of parameters to be kept for the ABC analysis
RDATA_PRIOR <- paste(PREF_PRIOR, "Rdata", sep=".")

# simulated stats
READ_STATF <- T   # load stat text file? if not then load Rdata stat file
PREF_STAT <- paste("ABCstat_", MODEL, "*txt.gz", sep="")
PATH_STAT <- PATH_BADS
STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260) # vector of stats to be kept for the ABC analysis
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

TEST_ABC <- T
N_TASKS <- 5
N_REP <- 1750
N_DATA <- N_TASKS * N_REP
MODEL <- "full_interspeMig"

# bad simuls
READ_BADF <- T  # do I load bad simulation text file? if not I load the Rdata bad simulation file
PREF_BADS <- paste("Badsimul_thres1Pc_",MODEL,sep="")
PATH_BADS <- "../"
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

# observed stats
F_OBS <- "./ABCstat_observed.txt"

# ABC parameters
LOAD_REG <- F
TOL <- 0.1 # proportion of points accepted nearest the target values.
METH <- "neuralnet"    # ABC algorithm
VTRANSF <- rep("logit", length(PRIORS)) # a vector of character strings indicating the kind of transformation to be applied to the parameter values.
LOGITBD <- function(prior, signi=1){ # a matrix of bounds if 'transf' is '"logit"'.  The matrix has as many lines as parameters (including the ones that are not '"logit"' transformed) and 2 columns. First column is the minimum bound and second column is the maximum bound.
# IMPORTANT NOTE: I made a function here, but one can chose to directly provide a matrix of bounds
    res <- t(apply(prior, 2, function(x) round(range(x), signi)))
    return(res)
    }  
NUMNET <- 100  # the number of neural networks when 'method' is '"neuralnet"'. Defaults to 10
SIZENET <- length(PRIORS) # the number of units in the hidden layer.

# ABC outputs
TRIAL <- paste(TOL, "_", METH, "_logit", sep="")
REGFIL <- paste("ABCreg_", MODEL, "_", TRIAL, ".Rdata", sep="")
RESFIL <- paste("ABCres_", MODEL, "_", TRIAL, sep="")    # do not add file extension type (e.g. ".txt")
POSTPLOT <- paste("PostDist_", MODEL, "_", TRIAL, ".pdf", sep="")
DIAGPLOT <- paste("DiagnosticPlot_", MODEL, "_", TRIAL, ".pdf", sep="")
SAMPGDSIM <- paste("SampleRetainedSim.", MODEL, ".", TRIAL, ".pdf", sep="")

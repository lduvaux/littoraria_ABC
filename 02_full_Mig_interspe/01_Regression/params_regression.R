TEST_ABC <- T
N_TASKS <- 5 # number of datasets, useful to put it small for debuging
N_REP <- 500
N_DATA <- N_TASKS * N_REP
MODEL <- "full-interspeMig"

# bad simuls
READ_BADF <- T  # do I load bad simulation text file? if not I load the Rdata bad simulation file
PREF_BADS <- "Badsimul_thres1Pc_full_interspeMig"
PATH_BADS <- "../"  # path of the folder containing the prior files
RDATA_BAD <- paste(PREF_BADS, "Rdata", sep=".")

# priors
READ_PRIORF <- T    # do I load prior text file? if not I load Rdata prior file
PREF_PRIOR <- "priors_full_interspeMig" # prefix of the prior files
PATH_PRIOR <-  PATH_BADS
PRIORS <- c(1:5, 7, 11, 13, 15, 16, 19) # vector of parameters to be kept for the abc analysis
RDATA_PRIOR <- paste(PREF_PRIOR, "Rdata", sep=".")

# simulated stats
READ_STATF <- T    # do I load stat text file? if not I load Rdata stat file
PREF_STAT <- "ABCstat_full_interspeMig"
PATH_STAT <- PATH_BADS
STATS <- c(2:10) # vector of stats to be kept for the abc analysis
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

# observed stats
F_OBS <- "../../ABCstat_observed.txt"

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

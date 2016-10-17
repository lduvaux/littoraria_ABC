DEBUG <- F  # set to true if you want to make some quick tests
N_SETS <- 1e6  # total number of datasets
MODEL <- "AM"

# bad simuls
READ_BADF <- T    # load bad simulation text file? if not then load the Rdata bad simulation file
PREF_BADS <- paste("Badsimul_thres1Pc_", MODEL, "*txt.gz", sep="")
PATH_BADS <- "../01_prior2stats/"
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
PATH_STAT <- "./"
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

# ABC parameters
LOAD_REG <- F
TOL <- 0.01
    # TOL: proportion of points accepted nearest the target values.
    # 0.05 good for an initial test with 1e5 datasets (i.e. 5e3 datasets retained)
    # for the final estimation (1e6 simulated datasets), 0.01 is a better value (1e4 datasets retained)
METH <- "neuralnet"    # ABC algorithm
VTRANSF <- rep("logit", length(PRIORS)) # a vector of character strings indicating the kind of transformation to be applied to the parameter values.
LOGITBD <- function(prior, signi=1){ # a matrix of bounds if 'transf' is '"logit"'.  The matrix has as many lines as parameters (including the ones that are not '"logit"' transformed) and 2 columns. First column is the minimum bound and second column is the maximum bound.
# IMPORTANT NOTE: I made a function here, but one can chose to directly provide a matrix of bounds
    res <- t(apply(prior, 2, function(x) round(range(x), signi)))
    return(res)
    }  
NUMNET <- 100
    # the number of neural networks when 'method' is '"neuralnet"'.
    # Defaults to 10, 100 is good for the final estimation
SIZENET <- length(PRIORS) # the number of units in the hidden layer.

# ABC outputs
TRIAL <- paste(TOL, "_", METH, "_logit", sep="")
REGFIL <- paste("ABCreg_", MODEL, "_", TRIAL, ".Rdata", sep="")
RESFIL <- paste("ABCres_", MODEL, "_", TRIAL, sep="")    # do not add file extension type (e.g. ".txt")
POSTPLOT <- paste("PostDist_", MODEL, "_", TRIAL, ".pdf", sep="")
DIAGPLOT <- paste("DiagnosticPlot_", MODEL, "_", TRIAL, ".pdf", sep="")
SAMPGDSIM <- paste("SampleRetainedSim.", MODEL, ".", TRIAL, ".pdf", sep="")

TEST_ABC <- T
N_FILES <- 5
N_REP <- 500
N_DATA <- N_FILES * N_REP
MODEL <- "full_interspeMig"

# bad simuls
READ_BADF <- T  # do I load bad simulation text file? if not I load the Rdata bad simulation file
PREF_BADS <- paste("Badsimul_thres1Pc_", MODEL ,sep="")
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
PREF_STAT <- paste("ABCstat_", MODEL, sep="")
PATH_STAT <- "./"
RDATA_STAT <- paste(PREF_STAT, "Rdata", sep=".")

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

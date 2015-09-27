rm(list=ls())
library(abc)
source("./params_PLS_extraction.R")
source("./functions_extract_data.R")

print("### I) load data")
print("    # I.1) load bad simuls")
if (READ_BADF){
    lbads <- read_badf(pattern=PREF_BADS, path=PATH_BADS, n_files=N_FILES,
        n_data=N_DATA, file=RDATA_BAD, n_rep=N_REP)
    bads <- lbads$bads
    test_bad <- lbads$test_bad
    rm(lbads)
} else {
    load(RDATA_BAD)
}

print("    # I.2) load priors")
if (READ_PRIORF) {
    prior <- read_prior(pattern=PREF_PRIOR, path=PATH_PRIOR,
        n_files=N_FILES, vpriors=PRIORS, n_data=N_DATA, file=RDATA_PRIOR)
} else {
    load(RDATA_PRIOR)
}

print("    # I.3) load simulated stats")
if (READ_STATF) {
    stat <- read_stat(pattern=PREF_STAT, path=PATH_STAT, n_files=N_FILES,
        n_data=N_DATA, vstats=STATS, file=RDATA_STAT)
} else {
    load(RDATA_STAT)
}


print("### II) extract PLS")



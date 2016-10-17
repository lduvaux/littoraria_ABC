rm(list=ls())
library("MASS")
source("./params.R")
source("./functions.R")

print("### I) load data")
print("    # I.1) load bad simuls")
if (READ_BADF){
    lbads <- read_badf(pattern=PREF_BADS, path=PATH_BADS, model=MODEL)
    bads <- lbads$bads
    test_bad <- lbads$test_bad
    ids <- lbads$IDs
    save(bads, test_bad, ids, file=RDATA_BAD)  # save clean set of bads simuls as it's quicker to reload a R object
    rm(lbads)
} else {
    load(RDATA_BAD)
}

print("    # I.2) load priors")
if (READ_PRIORF) {
    prior <- read_sim_files(pattern=PREF_PRIOR, path=PATH_PRIOR, 
        n_sets=N_SETS, vcol=PRIORS, tabads=bads, is.prior=T, model=MODEL)

    na_prior <- which(is.na(prior), arr.ind=T)
    if (dim(na_prior)[1] > 0) {
        print ("ERROR: na present in priors!!!")
        quit(status = 1)
    }
    save(prior, na_prior, file=RDATA_PRIOR)  # save clean matrix of priors as it's quicker to reload a R object
} else {
    load(RDATA_PRIOR)
}

print("    # I.3) load simulated stats")
if (READ_STATF) {
    stat <- read_sim_files(pattern=PREF_STAT, path=PATH_STAT, 
        n_sets=N_SETS, vcol=STATS, tabads=bads, is.prior=F, model=MODEL)

    na_stat <- which(is.na(stat), arr.ind=T)
    if (dim(na_stat)[1] > 0) {
        stat <- stat[-na_stat[,1],]
        prior <- prior[-na_stat[,1],]  # amend the prior matrix accordingly
        save(prior, na_prior, file=RDATA_PRIOR)  # ... and save it anew
    }
    save(stat, na_stat, file=RDATA_STAT)  # save clean matrix of stats
    load(RDATA_STAT)
}

if (nrow(prior) != nrow(stat)){
    print("Error: the number of prior sets is different of the number of statitics sets")
    print(paste("Number of prior sets: ", nrow(prior), sep=""))
    print(paste("Number of stat sets: ", nrow(stat), sep=""))
    quit
}

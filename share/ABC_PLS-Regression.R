rm(list=ls())
library("abc")

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
nb_pls <- commandArgs(trailingOnly = T) [1]
if (DEBUG) nb_pls <- 10
print(paste("Number of retained PLS components:", nb_pls))
STATS <- 1:nb_pls   # the number of PLS to keep
if (READ_STATF) {
    ids2 <- gsub(".txt.gz", ".transf.txt.gz", ids)
    stat <- read_sim_files(pattern=PREF_STAT, path=PATH_STAT, 
        n_sets=N_SETS, vcol=STATS, tabads=bads, is.prior=F, model=MODEL)

    na_stat <- which(is.na(stat), arr.ind=T)
    if (dim(na_stat)[1] > 0) {
        stat <- stat[-na_stat[,1],]
        prior <- prior[-na_stat[,1],]  # amend the prior matrix accordingly
        save(prior, na_prior, file=RDATA_PRIOR)  # ... and save it anew
    }
    save(stat, na_stat, file=RDATA_STAT)  # save clean matrix of stats
} else {
    load(RDATA_STAT)
}

if (nrow(prior) != nrow(stat)){
    print("Error: the number of prior sets is different of the number of statitics sets")
    print(paste("Number of prior sets: ", nrow(prior), sep=""))
    print(paste("Number of stat sets: ", nrow(stat), sep=""))
    quit
}
cat ("\n")


print("### II) ABC analysis")
print("    # II.1) load observed stats")
print("         # Do not mind the warning message about the file incomplete final line")
F_OBS <- commandArgs(trailingOnly = T) [2]
if (DEBUG) {
    F_OBS <- "ABCstat_observed_formatted.transf.txt.gz"
    print(F_OBS)
    NUMNET <- 3
}
obs_stat <- unlist(read.table(F_OBS, header=T, sep="\t", strip.white = T, stringsAsFactors = F)[,STATS])
print(obs_stat)


print("    # II.1) perform ABC")
if (!LOAD_REG)
{
    print("    # Compute regression")
    logitbd <- LOGITBD(prior)
    print (paste("myres <- abc(target=obs_stat, param=prior, sumstat=stat, tol=", TOL, ", method='", METH, "', transf=VTRANSF, numnet=", NUMNET, ", sizenet=", SIZENET, ", trace=T, logit.bounds=logitbd)", sep=""))
    myres <- abc(target=obs_stat, param=prior, sumstat=stat, tol=TOL, method=METH, transf=VTRANSF, numnet=NUMNET, sizenet=SIZENET, trace=T, logit.bounds=logitbd)
    
	cat("save myres", "\n")
    save(myres, file = REGFIL)
	
} else {
	print("   # load regression results")
	load(REGFIL)
}

print("### III) Analysis of the results")
print("    # III.1) Summary of posterior distributions (credibility interval)")
postres <- summary(myres, intvl = .9)
save(postres, file = paste(RESFIL, ".Rdata", sep=""))
write.table(postres, file = paste(RESFIL, ".txt", sep=""))

print("    # III.1) Few quick plots")
pdf(file=POSTPLOT)
hist(myres, breaks=30, ask=F); dev.off()

pdf(file=DIAGPLOT)
plot(myres, param=prior, ask=F); dev.off()

pdf(file=SAMPGDSIM)
hist(which(myres$region==T)); dev.off()


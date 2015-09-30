rm(list=ls())
library("abc")
source("./params.R")
source("./functions.R")

print("### I) load data")
print("    # I.1) load bad simuls")
if (READ_BADF){
    lbads <- read_badf(pattern=PREF_BADS, path=PATH_BADS, n_files=N_FILES,
        n_data=N_DATA, file=RDATA_BAD, n_rep=N_REP, model=MODEL)
    bads <- lbads$bads
    test_bad <- lbads$test_bad
    ids <- lbads$IDs
    rm(lbads)
} else {
    load(RDATA_BAD)
}

print("    # I.2) load priors")
if (READ_PRIORF) {
    prior <- read_prior(pattern=PREF_PRIOR, path=PATH_PRIOR,
        n_files=N_FILES, vpriors=PRIORS, n_data=N_DATA, file=RDATA_PRIOR,
        model=MODEL, id=ids)
} else {
    load(RDATA_PRIOR)
}

print("    # I.3) load simulated stats")
#~nb_pls <- commandArgs(trailingOnly = T) [1]
nb_pls <- 20
print(paste("Number of retained PLS components:", nb_pls))
STATS <- 1:nb_pls   # the 
if (READ_STATF) {
    ids2 <- gsub(".txt.gz", ".transf.txt.gz", ids)
    stat <- read_stat(pattern=PREF_STAT, path=PATH_STAT, n_files=N_FILES,
        n_data=N_DATA, vstats=STATS, file=RDATA_STAT, model=MODEL, id=ids2)
} else {
    load(RDATA_STAT)
}
cat ("\n")


print("### II) ABC analysis")
print("    # II.1) load observed stats")
print("         # Do not mind the warning message about the file incomplete final line")
F_OBS <- commandArgs(trailingOnly = T) [2]
F_OBS <- "ABCstat_observed_formatted.transf.txt.gz"
print(F_OBS)
obs_stat <- unlist(read.table(F_OBS, header=T, sep="\t", strip.white = T, stringsAsFactors = F)[,STATS])
print(obs_stat)


print("    # II.1) perform ABC")
if (!LOAD_REG)
{
    print("    # Compute regression")
    if (TEST_ABC) NUMNET <- 3
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


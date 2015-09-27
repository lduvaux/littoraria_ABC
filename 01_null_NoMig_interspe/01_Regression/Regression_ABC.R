rm(list=ls())
library(abc)
source("./params_regression.R")

print("### I) load data")
print("    # I.1) load bad simuls")
        # WARNING: to be changed when julia script corrected
if (READ_BADF){
    f_bads <- dir(pattern = PREF_BADS, path = PATH_BADS, full.names = T)
    if (TEST_ABC)  f_bads <- f_bads[1:N_TASKS]
    bads <- as.data.frame(matrix(ncol = 3, nrow = N_DATA))

    colnames(bads) <- c("jobID.taskID", "datasetID", "dataset_Nb")
    ite <- 1
    data_nb <- 0
    for (fil in f_bads){
        print (fil)
        tab <- read.table(fil, header=T, sep="\t", stringsAsFactors = F)
        if (nrow(tab)==0) {
            data_nb <- data_nb + N_REP
            next}
        jobID.taskID <- unlist(strsplit(fil, "Mig\\.|\\.txt"))[2]
        dataset_nber <- strsplit(tab[,1], "\\.")
        dataset_nber <- as.numeric(sapply(dataset_nber, function(x) x[4]))
        gdn <- dataset_nber + data_nb
        
        nst <- length(dataset_nber)
        bads[ite:(ite+nst-1),] <- data.frame(rep(jobID.taskID, nst), dataset_nber, gdn, stringsAsFactors = F)

        # increment
        ite <- ite+nst
        data_nb <- data_nb + N_REP
    }
    bads <- bads[-c(ite:nrow(bads)),]
    test_bad <- nrow(bads) > 0
    save(bads, test_bad, file=RDATA_BAD)  # save clean set of bads simuls as it's quicker to reload a R object

} else {
    load(RDATA_BAD)
}

print("    # I.2) load priors")
if (READ_PRIORF) {
    f_prior <- dir(pattern = PREF_PRIOR, path = PATH_PRIOR, full.names = T)
    if (TEST_ABC)  f_prior <- f_prior[1:N_TASKS]
    prior <- matrix(ncol = length(PRIORS), nrow = N_DATA)

    ite <- 1
    for (fil in f_prior){
        print (fil)
        tab <- read.table(fil, header=T, sep=" ", stringsAsFactors = F)
        tab <- as.matrix(tab[,-ncol(tab)])[,PRIORS]
        if (ite==1) colnames(prior) <- colnames(tab)
        npr <- nrow(tab)
        prior[ite:(ite+npr-1),] <- tab
        ite <- ite+npr
    }
    if (test_bad) prior <- prior [-bads$dataset_Nb,]  # remove bad datasets
    save(prior, file=RDATA_PRIOR)  # save clean matrix of priors as it's quicker to reload a R object

} else {
    load(RDATA_PRIOR)
}

print("    # I.3) load simulated stats")
if (READ_STATF) {
    f_stat <- dir(pattern = PREF_STAT, path = PATH_STAT, full.names = T)
    if (TEST_ABC)  f_stat <- f_stat[1:N_TASKS]
    stat <- matrix(ncol = length(STATS), nrow = N_DATA)

    ite <- 1
    for (fil in f_stat){
        print (fil)
        tab <- read.table(fil, header=T, sep="\t", strip.white = T, stringsAsFactors = F)
        tab <- as.matrix(tab[,STATS])
        if (ite==1) colnames(stat) <- colnames(tab)
        nst <- nrow(tab)
        stat[ite:(ite+nst-1),] <- tab
        ite <- ite+nst
    }
    if (test_bad) stat <- stat [-bads$dataset_Nb,]  # remove bad datasets
    save(stat, file=RDATA_STAT)  # save clean matrix of stats as it's quicker to reload a R object
    
} else {
    load(RDATA_STAT)
}

print("    # I.4) load observed stats")
print("         # Do not mind the warning message about the file incomplete final line")
obs_stat <- unlist(read.table(F_OBS, header=T, sep="\t", strip.white = T, stringsAsFactors = F)[,STATS])


print("### II) perform abc")
if (!LOAD_REG)
{
    print("    # Compute regression")
    if (TEST_ABC) # NUMNET <- 3
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


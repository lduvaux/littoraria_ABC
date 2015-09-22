rm(list=ls())
library(abc)
source("./params_regression.R")

# I) load data
    # I.1) load bad simuls
        # WARNING: to be changed when julia script corrected
f_bads <- dir(pattern = PREF_BADS, path = PATH_BADS, full.names = T)
bads <- as.data.frame(matrix(ncol = 3, nrow = N_DATA))
colnames(bads) <- c("jobID.taskID", "datasetID", "dataset_Nb")
ite <- 1
data_nb <- 0
for (fil in f_bads){
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

    # I.2) load priors
f_prior <- dir(pattern = PREF_PRIOR, path = PATH_PRIOR, full.names = T)
prior <- matrix(ncol = length(PRIORS), nrow = N_DATA)
ite <- 1
for (fil in f_prior){
    tab <- read.table(fil, header=T, sep=" ", stringsAsFactors = F)
    tab <- as.matrix(tab[,-ncol(tab)])[,PRIORS]
    if (ite==1) colnames(prior) <- colnames(tab)
    npr <- nrow(tab)
    prior[ite:(ite+npr-1),] <- tab
    ite <- ite+npr
}

    # I.3) load stats
f_stat <- dir(pattern = PREF_STAT, path = PATH_STAT, full.names = T)
stat <- matrix(ncol = length(STATS), nrow = N_DATA)
ite <- 1
for (fil in f_stat){
    tab <- read.table(fil, header=T, sep="\t", strip.white = T, stringsAsFactors = F)
    tab <- as.matrix(tab[,STATS])
    if (ite==1) colnames(stat) <- colnames(tab)
    nst <- nrow(tab)
    stat[ite:(ite+nst-1),] <- tab
    ite <- ite+nst
}

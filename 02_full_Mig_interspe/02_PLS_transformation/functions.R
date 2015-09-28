read_badf <-  function(pattern, path, n_files, n_data, file, n_rep, model){

    f_bads <- dir(pattern = pattern, path = path, full.names = T)[1:n_files]
    bads <- as.data.frame(matrix(ncol = 3, nrow = n_data))
    IDs <- character(n_files)

    colnames(bads) <- c("jobID.taskID", "datasetID", "dataset_Nb")
    ite <- 1
    data_nb <- 0
    for (ifil in seq(f_bads)){
        fil <- f_bads[ifil]
        sep <- paste(model, "\\.", sep="")
        print (fil)
        ID <- unlist(strsplit(fil, sep))[2]
        IDs[ifil] <- ID
        tab <- read.table(fil, header=T, sep="\t", stringsAsFactors = F)
        if (nrow(tab)==0) {
            data_nb <- data_nb + n_rep
            next}
        jobID.taskID <- unlist(strsplit(fil, "Mig\\.|\\.txt"))[2]
        dataset_nber <- strsplit(tab[,1], "\\.")
        dataset_nber <- as.numeric(sapply(dataset_nber, function(x) x[4]))
        gdn <- dataset_nber + data_nb
        
        nst <- length(dataset_nber)
        bads[ite:(ite+nst-1),] <- data.frame(rep(jobID.taskID, nst), dataset_nber, gdn, stringsAsFactors = F)

        # increment
        ite <- ite+nst
        data_nb <- data_nb + n_rep
    }
    bads <- bads[-c(ite:nrow(bads)),]
    test_bad <- nrow(bads) > 0
    save(bads, test_bad, file=file)  # save clean set of bads simuls as it's quicker to reload a R object
    return(list(bads=bads, test_bad=test_bad, IDs=IDs))
}

read_prior <- function(pattern, path, n_files, n_data, vpriors, file, model, ids){

    prior <- matrix(ncol = length(vpriors), nrow = n_data)
    ite <- 1
    for (i in seq(ids)){
        id <- ids[i]
        patt <- paste(pattern, ".", id, sep="")
        fil <- dir(pattern = patt, path = path, full.names = T)
        print (fil)
        tab <- read.table(fil, header=T, sep=" ", stringsAsFactors = F)
        tab <- as.matrix(tab[,-ncol(tab)])[,vpriors]
        if (ite==1) colnames(prior) <- colnames(tab)
        npr <- nrow(tab)
        prior[ite:(ite+npr-1),] <- tab
        ite <- ite+npr
    }
    if (test_bad) prior <- prior [-bads$dataset_Nb,]  # remove bad datasets
    save(prior, file=file)  # save clean matrix of priors as it's quicker to reload a R object
    return(prior)
}

read_stat <-  function(pattern, path, n_files, n_data, vstats, file, model, ids){

    stat <- matrix(ncol = length(vstats), nrow = n_data)
    ite <- 1
    for (i in seq(ids)){
        id <- ids[i]
        patt <- paste(pattern, ".", id, sep="")
        fil <- dir(pattern = patt, path = path, full.names = T)
        print (fil)
        tab <- read.table(fil, header=T, sep="\t", strip.white = T, stringsAsFactors = F)
        tab <- as.matrix(tab[,vstats])
        if (ite==1) colnames(stat) <- colnames(tab)
        nst <- nrow(tab)
        stat[ite:(ite+nst-1),] <- tab
        ite <- ite+nst
    }
    if (test_bad) stat <- stat [-bads$dataset_Nb,]  # remove bad datasets
    save(stat, file=file)  # save clean matrix of stats as it's quicker to reload a R object
    return(stat)
}

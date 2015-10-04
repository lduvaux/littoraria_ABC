read_badf <-  function(pattern, path, n_files, n_data, n_rep, model){
# pattern: pattern of input file names
# path: path of input files
# n_files: number of files to be loaded
# n_rep: number of datasets per input file
# model: model prefix

    f_bads <- dir(pattern = pattern, path = path, full.names = T)[1:n_files]
    bads <- as.data.frame(matrix(ncol = 3, nrow = n_rep * n_files))
    IDs <- character(n_files)

    colnames(bads) <- c("jobID.taskID", "datasetID", "dataset_Nb")
    ite <- 1
    data_nb <- 0	# dataset ID
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
	bads <- bads[-c(ite:nrow(bads)),]	# remove empty rows
    test_bad <- nrow(bads) > 0
    return(list(bads=bads, test_bad=test_bad, IDs=IDs))
}

read_sim_files <- function(pattern, ids, path, n_rep, vcol, test_bad, bads, is.prior){
# pattern: pattern of input file names
# ids: IDs of input files
# path: path of input files
# n_rep: number of datasets per input file
# vcol: columns of the table to be kept for the analysis
# test_bad: is there bad datasets in the files?
# bads: if so which ones?
# is.prior: are the priors loaded?

    prior <- matrix(ncol = length(vcol), nrow = n_rep * length(ids))
    ite <- 1
    for (i in seq(ids)){
        id <- ids[i]
        patt <- paste(pattern, ".", id, sep="")
        fil <- dir(pattern = patt, path = path, full.names = T)
        print (fil)
        
        if (is.prior) {
			tab <- read.table(fil, header=T, sep=" ", stringsAsFactors = F)
			tab <- as.matrix(tab[,-ncol(tab)])[,vcol]
		} else {
			tab <- read.table(fil, header=T, sep="\t", stringsAsFactors = F)
			tab <- as.matrix(tab)[,vcol]}
        if (ite==1) colnames(prior) <- colnames(tab)
        npr <- nrow(tab)
        prior[ite:(ite+npr-1),] <- tab
        ite <- ite+npr
    }
    if (test_bad) prior <- prior [-bads$dataset_Nb,]  # remove bad datasets
    return(prior)
}

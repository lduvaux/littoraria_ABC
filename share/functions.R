get_elements <- function(x, sep="_", what=c(1)){
    return(strsplit(x, sep)[[1]][what])
}

collapse_elements <- function(nom, sep="_", what=1:3, colla="_"){
    res <- paste(get_elements(nom, sep, what), collapse=colla)
    return(res)
}

read_badf <-  function(pattern, path, model){
# pattern: pattern of input file names
# path: path of input files
# model: model prefix

    f_bads <- dir(pattern = pattern, path = path, full.names = T)
    bads <- as.data.frame(matrix(ncol = 4, nrow = 0))
    IDs <- character(length(f_bads))

    colnames(bads) <- c("raw", "IDs", "jobID.taskID", "datasetID")
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
            next
        } else {
            nst <- nrow(tab)
            inds <- as.numeric(sapply(tab[,1], get_elements, "\\.", 4))
            job.task <- sapply(tab[,1], collapse_elements, sep="\\.", what=2:3, colla=".")
            tab <- cbind(tab, IDs=rep(ID, nrow(tab)), job.task, inds, stringsAsFactors = F)
            bads[ite:(ite+nst-1),] <- tab
        }
        # increment
        ite <- ite + nst
    }
    test_bad <- nrow(bads) > 0
    return(list(bads=bads, test_bad=test_bad, IDs=IDs))
}

read_sim_files <- function(pattern, path, n_sets, vcol, tabads, is.prior, model){
# pattern: pattern of input file names
# path: path of input files
# n_sets: number of datasets to load
# vcol: columns of the table to be kept for the analysis
# tabads: if so which ones?
# is.prior: are the priors loaded?

    f_sims <- dir(pattern = pattern, path = path, full.names = T)
    ftab <- matrix(ncol = length(vcol), nrow = n_sets)
    sets <- 1 ; ifil <- 1 ; nbads <- 0
    
    # we want to read files as long as we haven't loaded n_sets datasets
    while (sets < n_sets){
        # select file and read file
        fil <- f_sims[ifil]
        print (fil)
        if (is.prior) {
			tab <- read.table(fil, header=T, sep=" ", stringsAsFactors = F)
			tab <- as.matrix(tab[,-ncol(tab)])[,vcol]
		} else {
			tab <- read.table(fil, header=T, sep="\t", stringsAsFactors = F)
			tab <- as.matrix(tab)[,vcol]}
        if (ifil==1) colnames(ftab) <- colnames(tab)

        # detect and remove bad datasets
        id <- get_elements(fil, paste(model, ".", sep=""), 2)
        sub_bads <- subset(tabads, IDs==id)
        if (nrow(sub_bads)>0) {
            tab <- tab[-sub_bads[,"datasetID"],]
            nbads <- nbads + nrow(sub_bads)
        }
        # fill final table and increment
        npr <- nrow(tab)
        ftab[sets:(sets+npr-1),] <- tab
        sets <- sets+npr
        ifil <- ifil + 1
        if (ifil > length(f_sims) & sets < (n_sets-nbads)){
            print(paste(
                "WARNING: All datasets files read but number of loaded datasets inferior to n_sets=", n_sets, sep=""))
            print(paste("    Number of expected datasets (n_sets - n_bads): ", n_sets-nbads,  sep=""))
            print(paste("    Number of loaded datasets: ", sets-1,  sep=""))
            break
        }
    }
    if (nbads>0) ftab <- ftab [-(sets:n_sets),]  # remove bad datasets
    return(ftab)
}

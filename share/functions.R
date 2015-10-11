read_badf <-  function(pattern, path, model){
# pattern: pattern of input file names
# path: path of input files
# model: model prefix

    f_bads <- dir(pattern = pattern, path = path, full.names = T)
    bads <- as.data.frame(matrix(ncol = 1, nrow = 0))
    IDs <- character(length(f_bads))

    colnames(bads) <- c("jobID.taskID.datasetID")
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
            bads[ite:(ite+nst-1),] <- tab
        }
        # increment
        ite <- ite + nst
    }
    test_bad <- nrow(bads) > 0
    return(list(bads=bads, test_bad=test_bad, IDs=IDs))
}

#~    # functions
#~    get_badf <-  function(filbad){

#~        usplit <- function(x) unlist(strsplit(x, "\\."))[4]
#~        tabad <- read.table(filbad, header=T, sep="\t", stringsAsFactors = F)
#~        if (nrow(tabad)>0) {
#~            bads <- as.numeric(sapply(tabad[,1], usplit))
#~        } else bads <- NA
#~        return(bads)
#~    }

#~read_sim_files <- function(pattern, ids, path, n_sets, vcol, test_bad, bads, is.prior){
#~# pattern: pattern of input file names
#~# path: path of input files
#~# n_sets: number of datasets to load
#~# vcol: columns of the table to be kept for the analysis
#~# test_bad: is there bad datasets in the files?
#~# bads: if so which ones?
#~# is.prior: are the priors loaded?


#~    f_sims <- dir(pattern = pattern, path = path, full.names = T)
#~    IDs <- character(length(f_sims))
        
#~    ftab <- matrix(ncol = length(vcol), nrow = n_sets)
#~#    sets <- 1
#~    sets <- 4
#~    while (sets < n_sets){
#~        # select file and get ID
#~        fil <- f_sims[sets]
#~        print (fil)
#~        sep <- paste(model, "\\.", sep="")
#~        id <- unlist(strsplit(fil, sep))[2]
#~        IDs[sets] <- id
        
#~        # read file
#~        if (is.prior) {
#~			tab <- read.table(fil, header=T, sep=" ", stringsAsFactors = F)
#~			tab <- as.matrix(tab[,-ncol(tab)])[,vcol]
#~		} else {
#~			tab <- read.table(fil, header=T, sep="\t", stringsAsFactors = F)
#~			tab <- as.matrix(tab)[,vcol]}
#~        if (sets==1) colnames(ftab) <- colnames(tab)

#~        # detect bad datasets   # can be 
#~        filbad <- paste(pref_bads, ".", id, sep="")
#~        bads <- get_badf(filbad)
#~        # put them in a big table?
#~        if (!is.na(bads)) tab <- tab[-bads,]

#~        # fill final table and increment
#~        npr <- nrow(tab)
#~        ftab[sets:(sets+npr-1),] <- tab
#~        sets <- sets+npr
#~        ifil <- ifil + 1
#~        if (ifil > length(bads) & data_nb < n_sets){
#~            print(paste(
#~"           WARNING: All datasets files have been read but the
#~            number of datasets loaded is inferior to n_sets=", n_sets, sep=""))
#~        }
#~    }
#~    if (test_bad) ftab <- ftab [-bads$dataset_Nb,]  # remove bad datasets
#~    return(ftab)
#~}

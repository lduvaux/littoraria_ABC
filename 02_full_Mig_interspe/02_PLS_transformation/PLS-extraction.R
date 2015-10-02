rm(list=ls())
library("MASS")
library("pls")
source("./params.R")
source("./functions.R")

print("### I) load data")
print("    # I.1) load bad simuls")
if (READ_BADF){
    lbads <- read_badf(pattern=PREF_BADS, path=PATH_BADS, n_files=N_FILES,
        n_data=N_DATA, n_rep=N_REP, model=MODEL)
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
    prior <- read_prior(pattern=PREF_PRIOR, path=PATH_PRIOR,
        n_files=N_FILES, vpriors=PRIORS, n_data=N_DATA,
        model=MODEL, id=ids, test_bad=test_bad, bads=bads)

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
    stat <- read_stat(pattern=PREF_STAT, path=PATH_STAT, n_files=N_FILES,
        n_data=N_DATA, vstats=STATS, model=MODEL, id=ids,
        test_bad=test_bad, bads=bads)
    na_stat <- which(is.na(stat), arr.ind=T)
    if (dim(na_stat)[1] > 0) {
        stat <- stat[-na_stat[,1],]
        prior <- prior[-na_stat[,1],]
        save(prior, na_prior, file=RDATA_PRIOR)  # save clean matrix of priors as it's quicker to reload a R object
    }
    save(stat, na_stat, file=RDATA_STAT)  # save clean matrix of stats as it's quicker to reload a R object
} else {
    load(RDATA_STAT)
}


print("### II) extract PLS")
numComp <- NUMCOMP

print("    # II.1) standardize the params")
params <- prior
for(i in 1:ncol(params)){
    params[,i] <- (params[,i] - mean(params[,i])) / sd(params[,i])
}

print("    # II.2) force stats in [1,2]")
stats <- stat
myMax <- c(); myMin <- c(); lambda <- c(); myGM <- c();
for(i in 1:ncol(stats)){
	myMax <- c(myMax, max(stats[,i]));
	myMin <- c(myMin, min(stats[,i]));
	stats[,i] <- 1 + (stats[,i]-myMin[i]) / (myMax[i] - myMin[i]);
}

print("    # II.3) transform statistics via boxcox")
for(i in 1:ncol(stats)){
	d <- as.data.frame(cbind(stats[,i], params))
	mylm <- lm(as.formula(d), data=d)
	myboxcox <- boxcox(mylm, lambda=seq(-50, 80, 1/10), plotit=T, interp=T, eps=1/50)
	lambda <- c(lambda, myboxcox$x[myboxcox$y==max(myboxcox$y)])
	print(paste(names(stats)[i], myboxcox$x[myboxcox$y==max(myboxcox$y)]))
	myGM <- c(myGM, exp(mean(log(stats[,i]))))
}
dev.off()

print("    # II.4) standardize the BC-stats")
myBCMeans <- c(); myBCSDs <- c();
for(i in 1:ncol(stats)){
	stats[,i] <- (stats[,i]^lambda[i] - 1)/(lambda[i]*myGM[i]^(lambda[i]-1))
	myBCSDs <- c(myBCSDs, sd(stats[,i]))
	myBCMeans <- c(myBCMeans, mean(stats[,i]))
	stats[,i] <- (stats[,i]-myBCMeans[i])/myBCSDs[i]
}

print("    # II.5) perform pls")
#myPlsr <- plsr(as.matrix(params) ~ as.matrix(stats), scale=F, ncomp=numComp, validation="LOO");
myPlsr <- plsr(as.matrix(params) ~ as.matrix(stats), scale=F, ncomp=numComp)

print("Variance explained by the first 10 components")
print(sum(explvar(myPlsr)[1:10]))
print("Variance explained by EACH the first 'numComp' components")
print(explvar(myPlsr))
print("Detail of the variance explained for each parameter by each of the first 'numComp' components")
print(summary(myPlsr))


print("    # II.6) write pls to a file")
myPlsrDataFrame <- data.frame(comp1=myPlsr$loadings[,1])
for(i in 2:numComp){
    myPlsrDataFrame <- cbind(myPlsrDataFrame, myPlsr$loadings[,i])
}

pls_tab <- cbind(colnames(stats), myMax, myMin, lambda, myGM, myBCMeans, myBCSDs, myPlsrDataFrame)
write.table(pls_tab,
    file=paste(DIROUT, "Routput_", MODEL, ".txt", sep=""),
    col.names=F, row.names=F, sep="\t", quote=F
)

print("    # II.7) make RMSE plot")
pdf(paste(DIROUT, "RMSE_", MODEL, ".pdf", sep=""));
plot(RMSEP(myPlsr));
dev.off();


#obsa <- read.table("/mnt/uni/ABC/arvalis/arvalis_both.obs", header=T);
#n <- data.frame(a=1:length(names(obsa)), n=names(obsa));
#pdf(paste(directory, "stats_", filename, ".pdf", sep=""), width=9, height=12);
#par(mfrow=c(5,4), cex=0.5)		
#	for(i in c(1:13,25,26,49:51,63,64,76:80,183:227)){
#	plot(density(stats[,i]), xlim=c(min(stats[,i])-max(stats[,i])+min(stats[,i]),max(stats[,i])+max(stats[,i])-min(stats[,i])), main=names(stats)[i]);	
#	print(paste(n[n[,2]==names(stats)[i],1], obsa[n[n[,2]==names(stats)[i],1]]));
#	lines(c(obsa[,n[n[,2]==names(stats)[i],1]], obsa[,n[n[,2]==names(stats)[i],1]]), c(0,1000), col="red")
#}

#dev.off();


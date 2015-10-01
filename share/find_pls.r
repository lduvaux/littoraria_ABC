rm(list=ls())
# variables and load data
directory <- "./"
filename <- "fullModel_Mig_Interspe"
load("priors_full_interspeMig.Rdata")
load("ABCstat_full_interspeMig.Rdata")
# WARNING: in the original script, it read 10,000 sets of stats and params
numComp <- ncol(stat)


# standardize the params
params <- prior
for(i in 1:ncol(params)){
    params[,i] <- (params[,i] - mean(params[,i])) / sd(params[,i])
}

# force stats in [1,2]
stats <- stat
myMax <- c(); myMin <- c(); lambda <- c(); myGM <- c();
for(i in 1:ncol(stats)){
	myMax <- c(myMax, max(stats[,i]));
	myMin <- c(myMin, min(stats[,i]));
	stats[,i] <- 1 + (stats[,i]-myMin[i]) / (myMax[i] - myMin[i]);
}

# transform statistics via boxcox  
library("MASS")
for(i in 1:ncol(stats)){
	d <- as.data.frame(cbind(stats[,i], params))
	mylm <- lm(as.formula(d), data=d)
	myboxcox <- boxcox(mylm, lambda=seq(-50, 80, 1/10), plotit=T, interp=T, eps=1/50)
	lambda <- c(lambda, myboxcox$x[myboxcox$y==max(myboxcox$y)])
	print(paste(names(stats)[i], myboxcox$x[myboxcox$y==max(myboxcox$y)]))
	myGM <- c(myGM, exp(mean(log(stats[,i]))))
}

# standardize the BC-stats
myBCMeans <- c(); myBCSDs <- c();
for(i in 1:ncol(stats)){
	stats[,i] <- (stats[,i]^lambda[i] - 1)/(lambda[i]*myGM[i]^(lambda[i]-1))
	myBCSDs <- c(myBCSDs, sd(stats[,i]))
	myBCMeans <- c(myBCMeans, mean(stats[,i]))
	stats[,i] <- (stats[,i]-myBCMeans[i])/myBCSDs[i]
}

# perform pls
library("pls")
#myPlsr <- plsr(as.matrix(params) ~ as.matrix(stats), scale=F, ncomp=numComp, validation="LOO");
myPlsr <- plsr(as.matrix(params) ~ as.matrix(stats), scale=F, ncomp=numComp)

# write pls to a file
myPlsrDataFrame <- data.frame(comp1=myPlsr$loadings[,1])
for(i in 2:numComp){
    myPlsrDataFrame <- cbind(myPlsrDataFrame, myPlsr$loadings[,i])
}
pls_tab <- cbind(colnames(stats), myMax, myMin, lambda, myGM, myBCMeans, myBCSDs, myPlsrDataFrame)
write.table(
    pls_tab,
    file=paste(directory, "Routput_", filename, ".txt", sep=""),
    col.names=F, row.names=F, sep="\t", quote=F
)

#make RMSE plot
pdf(paste(directory, "RMSE_", filename, ".pdf", sep=""));
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

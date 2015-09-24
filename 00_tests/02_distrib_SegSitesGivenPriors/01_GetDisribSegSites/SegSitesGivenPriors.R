rm(list=ls())
library(data.table)

# I) count good loci per simulations
segs_tab <- read.table("Count_segsites.txt", header=F, sep=" ")
segs <- segs_tab[,2]
test <- segs > 0 & segs < 5
sim <- rep(1:1e4, each=100)
count <- table(test, sim)

segs_mu2 <- read.table("Count_segsites_mu2.txt", header=F, sep=" ")
segs2 <- segs_mu2[,2]
test2 <- segs2 > 0 & segs2 < 5
count2 <- table(test2, sim)

# II) get distribution per parameter
prior <- read.table("priors_DistSegSites.txt.gz", header=T, sep=" ")
while (ncol(prior) > 13) prior <- prior[, -length(prior)]
param <- colnames(prior)

prior2 <- read.table("priors_DistSegSites_mu2.txt.gz", header=T, sep=" ")
while (ncol(prior2) > 13) prior2 <- prior2[, -length(prior2)]

# III) relation between parameters and proportion of correct simulations
gd <- count[2,]
mgd <- mean(gd)
gd2 <- count2[2,]
mgd2 <- mean(gd2)
pdf("GoodSimulGivenPriors.pdf")
layout(matrix(1:6, 3, 2, byrow = TRUE))
for (i in seq(param)){

    para <- prior[,i]
    para2 <- prior2[,i]
    eq <- gd ~ para
    eq2 <- gd2 ~ para2
    res <- loess(eq, span = .5)
    res2 <- loess(eq2, span = .5)

    sam <- sample (length(para), 1e3)
    plot(gd[sam] ~ para[sam], ylim=c(0,100), xlab=paste("prior of", param[i]), ylab="Fqcy of correct simulations", pch=".", col="brown")
    par(new=T)
    plot(gd2[sam] ~ para2[sam], ylim=c(0,100), xlab=paste("prior of", param[i]), ylab="Fqcy of correct simulations", pch=".", col="blue")
    abline(h=mgd, col="red", lwd=1)
    abline(h=mgd2, col="turquoise", lwd=1.5)
    lines(sort(res$fitted) ~ sort(res$x), col="brown", lwd=1.5)
    lines(sort(res2$fitted) ~ sort(res2$x), col="blue", lwd=1.5)
    print(i)
}
dev.off()

# IV) relation between parameters and nber of segsites
dat <- data.frame(segs, as.factor(sim))
means <- aggregate(segs~sim, FUN=mean)
means2 <- aggregate(segs2~sim, FUN=mean)
v_mean <- means[,2]
v_mean2 <- means2[,2]
m_mean <- mean(v_mean)
m_mean2 <- mean(v_mean2)
pdf("SegSitesGivenPriors.pdf")
layout(matrix(1:6, 3, 2, byrow = TRUE))
for (i in seq(param)){

    para <- prior[,i]
    para2 <- prior2[,i]
    eq <- v_mean ~ para
    eq2 <- v_mean2 ~ para2
    res <- loess(eq, span = .5)
    res2 <- loess(eq2, span = .5)

    sam <- sample (length(para), 1e3)
    plot(v_mean[sam] ~ para[sam], ylim=c(0,4), xlab=paste("prior of", param[i]), ylab="Mean nber of SegSites", pch=".", col="brown")
    par(new=T)
    plot(v_mean2[sam] ~ para2[sam], ylim=c(0,4), xlab=paste("prior of", param[i]), ylab="Mean nber of SegSites", pch=".", col="blue")
    abline(h=m_mean, col="red", lwd=1)
    abline(h=m_mean2, col="turquoise", lwd=1)
    lines(sort(res$fitted) ~ sort(res$x), col="brown", lwd=1.5)
    lines(sort(res2$fitted) ~ sort(res2$x), col="blue", lwd=1.5)
    print(i)
}
dev.off()

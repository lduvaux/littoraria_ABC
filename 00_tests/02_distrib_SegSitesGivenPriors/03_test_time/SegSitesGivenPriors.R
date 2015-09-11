rm(list=ls())

# I) Count_SegSites_msnseg_mu1.5_Z15.txt
segs_tab <- read.table("Count_SegSites_msnseg_mu1.5_Z15.txt", header=F, sep=" ")
segs <- segs_tab[,2]
tab <- table(segs)

mat <- matrix(ncol=100, data=segs, byrow=T)
score <- apply(mat, 1, function(x) sum(x<1 | x>4))
table(score)

# II) Count_SegSites_msnseg_mu1.5_Z10.txt
segs_tab2 <- read.table("Count_SegSites_msnseg_mu1.5_Z10.txt", header=F, sep=" ")
segs2 <- segs_tab2[,2]
tab2 <- table(segs2)

mat2 <- matrix(ncol=100, data=segs2, byrow=T)
score2 <- apply(mat2, 1, function(x) sum(x<1 | x>4))
table(score2)

pdf("Distribution_Segsites_mu1.5.pdf")
layout(matrix(1:2, ncol=2))
plot(tab2, xlab=paste("Distribution of SegSites\nUp to 10 trials - n(0)=", tab2[1], sep=""), ylab="fqcy")
plot(tab, xlab=paste("Distribution of SegSites\nUp to 15 trials - n(0)=", tab[1], sep=""), ylab="fqcy")
dev.off()

# III) Count_SegSites_msnseg_mu3_Z10.txt
segs_tab3 <- read.table("Count_SegSites_msnseg_mu3_Z10.txt", header=F, sep=" ")
segs3 <- segs_tab3[,2]
tab3 <- table(segs3)

mat3 <- matrix(ncol=100, data=segs3, byrow=T)
score3 <- apply(mat3, 1, function(x) sum(x<1 | x>4))
table(score3)

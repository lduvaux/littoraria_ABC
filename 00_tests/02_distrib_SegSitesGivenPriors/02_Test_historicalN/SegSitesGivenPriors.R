rm(list=ls())

# I) count segsites, mu=3e-9
segs_sam0_mu3 <- read.table("Count_Segsites_msnsam_mu3.txt", header=F, sep=" ")
segs_sam_mu3 <- segs_sam0_mu3[,2]
tab_sam_mu3 <- table(segs_sam_mu3)

segs_seg0_mu3 <- read.table("Count_Segsites_msnseg_mu3.txt", header=F, sep=" ")
segs_seg_mu3 <- segs_seg0_mu3[,2]
tab_seg_mu3 <- table(segs_seg_mu3)

# II) count segsites, mu=1.5e-9
segs_sam0_mu1.5 <- read.table("Count_Segsites_msnsam_mu1.5.txt", header=F, sep=" ")
segs_sam_mu1.5 <- segs_sam0_mu1.5[,2]
tab_sam_mu1.5 <- table(segs_sam_mu1.5)

segs_seg0_mu1.5 <- read.table("Count_Segsites_msnseg_mu1.5.txt", header=F, sep=" ")
segs_seg_mu1.5 <- segs_seg0_mu1.5[,2]
tab_seg_mu1.5 <- table(segs_seg_mu1.5)

# Z10
segs_seg0_mu1.5_Z10 <- read.table("Count_segsites_msnseg_mu1.5_Z10.txt", header=F, sep=" ")
segs_seg_mu1.5_Z10 <- segs_seg0_mu1.5_Z10[,2]
tab_seg_mu1.5_Z10 <- table(segs_seg_mu1.5_Z10)

# II) plot distros
pdf("Distrib_SegSites_omsVersions.pdf")
layout(matrix(1:6, 2, 3, byrow=T))
plot(tab_sam_mu3)
plot(tab_sam_mu1.5)
plot(tab_seg_mu3)
plot(tab_seg_mu1.5)
plot(tab_seg_mu1.5_Z10)
dev.off()

# check by dataset
mat_seg1.5 <- matrix(ncol=100, data=segs_seg_mu1.5, byrow=T)
res_seg1.5 <- apply(mat_seg1.5 , 1, function(x) sum(x<1 | x >4))
table(res_seg1.5)


mat_seg1.5_Z10 <- matrix(ncol=100, data=segs_seg_mu1.5_Z10, byrow=T)
res_seg1.5_Z10 <- apply(mat_seg1.5_Z10, 1, function(x) sum(x<1 | x >4))
table(res_seg1.5_Z10)

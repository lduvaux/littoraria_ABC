tab <- read.table("priors_fullModel_interMig.txt.gz", header=T, sep=" ")
hist(tab$history1)
range(tab$history1)

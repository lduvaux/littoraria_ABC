STATS <- c(1:80, 109:116, 145:152, 181:188, 217:224, 253:260)   # same stats as for the PLS component extraction

tab <- read.delim("ABCstat_full_interspeMig.1961048.1.txt.gz", stringsAsFactors = F)
head(tab)
tabf <- tab[,STATS]
cat(colnames(tabf), file="ListOfStats.txt", sep="\t")

gz1 <- gzfile("ABCstat_full_interspeMig.1961048.1_formatted.txt.gz", "w")
write.table(tabf, gz1, quote=F, row.names=F, sep="\t")
close(gz1)


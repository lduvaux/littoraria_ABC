###########################################################
##### Posteriors distribution of migration - NM model #####
###########################################################

# remove all objects
rm(list = ls())

# load posteriors
load('./01_NM/03_ABC_Regression/ABCreg_NM_0.05_neuralnet_logit.Rdata')

# identify which columns are migration parameters
colnames(myres$adj.values)

# plot posteriors distribution of migration
pdf(file="./Posteriors_distribution_intrasp_mig_NM.pdf")
hist(log(myres$adj.values[, 5]), main = "Posteriors distribution of L. cingulata intra-specific migration", col = "grey", xlab = "log(fitted M12)")
hist(log(myres$adj.values[, 6]), main = "Posteriors distribution of L. filosa intra-specific migration", col = "grey", xlab = "log(fitted M34)")
dev.off()

###########################################################
##### Posteriors distribution of migration - CM model #####
###########################################################

# remove all objects
rm(list = ls())

# load posteriors
load('./02_CM/03_ABC_Regression/ABCreg_CM_0.05_neuralnet_logit.Rdata')

# identify which columns are migration parameters
colnames(myres$adj.values)

# plot posteriors distribution of migration
pdf(file="./Posteriors_distribution_intrasp_mig_CM.pdf")
hist(log(myres$adj.values[, 5]), main = "Posteriors distribution of L. cingulata intra-specific migration", col = "grey", xlab = "log(fitted M12) = log(fitted M21)")
hist(log(myres$adj.values[, 6]), main = "Posteriors distribution of L. filosa intra-specific migration", col = "grey", xlab = "log(fitted M34) = log(fitted M43)")
dev.off()

###########################################################
##### Posteriors distribution of migration - RM model #####
###########################################################

# remove all objects
rm(list = ls())

# load posteriors
load('./03_RM/03_ABC_Regression/ABCreg_RM_0.05_neuralnet_logit.Rdata')

# identify which columns are migration parameters
colnames(myres$adj.values)

# plot posteriors distribution of migration
pdf(file="./Posteriors_distribution_intrasp_mig_RM.pdf")
hist(log(myres$adj.values[, 5]), main = "Posteriors distribution of L. cingulata intra-specific migration", col = "grey", xlab = "log(fitted M12) = log(fitted M21)")
hist(log(myres$adj.values[, 6]), main = "Posteriors distribution of L. filosa intra-specific migration", col = "grey", xlab = "log(fitted M34) = log(fitted M43)")
dev.off()

###########################################################
##### Posteriors distribution of migration - AM model #####
###########################################################

# remove all objects
rm(list = ls())

# load posteriors
load('./04_AM/03_ABC_Regression/ABCreg_AM_0.05_neuralnet_logit.Rdata')

# identify which columns are migration parameters
colnames(myres$adj.values)

# plot posteriors distribution of migration
pdf(file="./Posteriors_distribution_intrasp_mig_AM.pdf")
hist(log(myres$adj.values[, 5]), main = "Posteriors distribution of L. cingulata intra-specific migration", col = "grey", xlab = "log(fitted M12) = log(fitted M21)")
hist(log(myres$adj.values[, 6]), main = "Posteriors distribution of L. filosa intra-specific migration", col = "grey", xlab = "log(fitted M34) = log(fitted M43)")
dev.off()

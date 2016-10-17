# remove all objects
rm(list = ls())

# import data
lapply(as.list(dir(path = "../../Results/03_cross_valid", pattern = "model.probs.",
    full.names = TRUE)), load, .GlobalEnv)

# generate a single matrix with all the data
postprobs <- do.call("rbind", mget(ls(pattern = "model.probs.")))

# remove individual matrices of data
rm(list = ls(pattern = "model.probs."))

# subset posterior probabilities of the NM model
postprobs <- postprobs[rownames(postprobs)=="NM", c("NM", "RM")]

# require sm package
library(sm)

# plot density curves

pdf(file = "../../Results/03_cross_valid/post_probs_NM.pdf", width = 5.9, height = 5.9)

par(mar = c(6, 4, 1, 1))

sm.density.compare(c(postprobs[, c("NM", "RM")]), as.factor(rep(c("NM", "RM"), each = nrow(postprobs))), col = rep("black", 2), xlab = "Posterior probability of models NM and RM when the\npseudo-observed data was simulated under the NM model")

text(0.15, 12, "RM")
text(0.80, 06, "NM")

dev.off()

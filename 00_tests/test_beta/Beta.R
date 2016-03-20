a = runif(10, 0, 0.5)
b = runif(10, 0, 200)
max_bd = 10

pdf("Examples_beta_random_realisations.pdf")
layout(matrix(1:4,2,2))
i = 1
while (i < length(a)){
    plot(density(rbeta(1e5, a[i], b[i]) * max_bd),
        xlim=c(0.000001, max_bd), xlab="natural scale", main="")
    if (i %% 5 == 1) 
        title(main="Beta distributions\n5 random realisations (natural scale)")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 1], b[i + 1]) * max_bd),
        xlim=c(0.000001, max_bd), col="red", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 2], b[i + 2]) * max_bd),
        xlim=c(0.000001, max_bd), col="green", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 3], b[i + 3]) * max_bd),
        xlim=c(0.000001, max_bd), col="blue", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 4], b[i + 4]) * max_bd),
        xlim=c(0.000001, max_bd), col="orange", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 5], b[i + 5]) * max_bd),
        xlim=c(0.000001, max_bd), col="purple", xlab="", main="", ylab="")
    i = i + 5
}


i = 1
while (i < length(a)){
    plot(density(log10(rbeta(1e5, a[i], b[i]) * max_bd)),
        xlim=log10(c(0.000001, max_bd)), xlab="log10 scale", main="")
    if (i %% 5 == 1)
        title(main="Same 5 Random realisations\nas on the left (log10 scale)")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 1], b[i + 1]) * max_bd)),
        xlim=log10(c(0.000001, max_bd)), col="red", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 2], b[i + 2]) * max_bd)),
        xlim=log10(c(0.000001, max_bd)), col="green", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 3], b[i + 3]) * max_bd)),
        xlim=log10(c(0.000001, max_bd)), col="blue", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 4], b[i + 4]) * max_bd)),
        xlim=log10(c(0.000001, max_bd)), col="orange", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 5], b[i + 5]) * max_bd)),
        xlim=log10(c(0.000001, max_bd)), col="purple", xlab="", main="", ylab="")
    i = i + 5
}
dev.off()

###################

max_bd = 10
max_lim = 0.1

pdf("Examples_beta_random_realisations_xmax1.pdf")
layout(matrix(1:4,2,2))
i = 1
while (i < length(a)){
    plot(density(rbeta(1e5, a[i], b[i]) * max_bd),
        xlim=c(0.000001, max_lim), xlab="natural scale", main="")
    if (i %% 5 == 1) 
        title(main="Beta distributions\n5 random realisations (natural scale)")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 1], b[i + 1]) * max_bd),
        xlim=c(0.000001, max_lim), col="red", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 2], b[i + 2]) * max_bd),
        xlim=c(0.000001, max_lim), col="green", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 3], b[i + 3]) * max_bd),
        xlim=c(0.000001, max_lim), col="blue", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 4], b[i + 4]) * max_bd),
        xlim=c(0.000001, max_lim), col="orange", xlab="", main="", ylab="")
    par(new=T)
    plot(density(rbeta(1e5, a[i + 5], b[i + 5]) * max_bd),
        xlim=c(0.000001, max_lim), col="purple", xlab="", main="", ylab="")
    i = i + 5
}


i = 1
while (i < length(a)){
    plot(density(log10(rbeta(1e5, a[i], b[i]) * max_bd)),
        xlim=log10(c(0.000001, max_lim)), xlab="log10 scale", main="")
    if (i %% 5 == 1)
        title(main="Same 5 Random realisations\nas on the left (log10 scale)")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 1], b[i + 1]) * max_bd)),
        xlim=log10(c(0.000001, max_lim)), col="red", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 2], b[i + 2]) * max_bd)),
        xlim=log10(c(0.000001, max_lim)), col="green", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 3], b[i + 3]) * max_bd)),
        xlim=log10(c(0.000001, max_lim)), col="blue", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 4], b[i + 4]) * max_bd)),
        xlim=log10(c(0.000001, max_lim)), col="orange", xlab="", main="", ylab="")
    par(new=T)
    plot(density(log10(rbeta(1e5, a[i + 5], b[i + 5]) * max_bd)),
        xlim=log10(c(0.000001, max_lim)), col="purple", xlab="", main="", ylab="")
    i = i + 5
}
dev.off()







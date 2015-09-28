


## Ludovic Duvaux 2015-Sept-28

# variables
pls=../02_PLS_transformation/Routput_full_interspeMig.txt
nb_pls=15

# keep the n first principal components
npls=`basename ${pls}`  # save the new file in current directory
printf "cut -f1-$((7 + ${nb_pls})) ${pls} > ${npls}\n"
cut -f1-$((7 + ${nb_pls})) ${pls} > ${npls}


# transform files
stats=../01_prior2stats/ABCstat_full_interspeMig*
for sta0 in ${stats}
do
    # uncompress
    sta1=`basename ${sta0}`
    sta1=${sta1%.gz}
    printf "zcat ${sta0} > ${sta1}\n"
    zcat ${sta0} > ${sta1}

    # transform
    sta2=${sta1%.txt}
    sta2=${sta1}.transf.txt
    printf "./transformer ${npls} ${sta1} ${sta2} boxcox\n"
    ./transformer ${npls} ${sta1} ${sta2} boxcox

    # compress results
    printf "rm ${sta1}\n"
    rm ${sta1}
    printf "gzip ${sta2}\n\n"
    gzip -f ${sta2}
done


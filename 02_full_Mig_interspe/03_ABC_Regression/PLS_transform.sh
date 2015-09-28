#!/bin/bash
### script to PLS transform a matrix of summary statistics
## using flags in this script is not very clever as all parameter are needed!
## However, it was set as an example on how to write a full script with
## flags and all th eproper stuffs...
## Ludovic Duvaux 2015-Sept-28

## 1) check arguments
while test $# -gt 0
do
    case "$1" in
        -h|--help)
            echo "$0 - transform original summary statistics using PLS components"
            echo " "
            echo "Usage:"
            echo "$0 options"
            echo " "
            echo "options:"
            echo "-h, --help                show this help"
            echo "-n, --nb-pls              specify the number of pls components to keep"
            echo "-p, --pls-file            specify the pls component file"
            echo "-s, --stat-files          specify the files of original statistics"
            exit 0
            ;;
        -n|--nb-pls)
            shift
                nb_pls=$1
                
            shift
            ;;
        -p|--pls-file)
            shift
            pls=$1
            shift
            ;;
        -s|--stat-files)
            shift
            stats=()
            while [[ $1 != -* ]]
            do
                stats+=($1)
                shift
                if [ -z $1 ]; then
                    break
                fi
            done
            ;;
        -*)
            echo "Unexpected option $1"
            exit
            ;;
    esac
done

## 2) check that all needed arguments are presents
# pls file
if [ -z $pls ]; then
    echo "File of PLS components (flag -p) has to be specified!"
    exit
fi
if [ ! -f ${pls} ]; then
    echo "file $pls does not exist!"
    exit
fi

# number of pls
if [ -z $nb_pls ]; then
    echo "the number of components to keep has to be specified (flag -p) has to be specified!"
    exit
fi

# stat files
if [ -z $stats ]; then
    echo "Files of original statistics (flag -s) have to be specified!"
    exit
fi


## 3) Summarize run parameters
echo ""
echo "## Summary of the run parameters"
echo "The PLS component file is '$pls'"
echo "The number of retained pls is $nb_pls"
echo "the stat files to be processed are:"
for i in ${stats[@]}
do
    echo "${i}"
done

## 4) perform the transformation
    # 4.1) keep the n first principal components
printf "\n## Perform the transformation\n"
npls=`basename ${pls}`  # save the new file in current directory


printf "cut -f1-$((7 + ${nb_pls})) ${pls} > ${npls}\n"
cut -f1-$((7 + ${nb_pls})) ${pls} > ${npls}


    # 4.2) transform files
for sta0 in ${stats[@]}
do
    if [ ! -f ${sta0} ]; then
        echo "file $pls does not exist!"
        exit
    fi
    
    # uncompress
    echo ""
    sta1=`basename ${sta0}`
    sta1=${sta1%.gz}
    printf "zcat ${sta0} > ${sta1}\n"
    zcat ${sta0} > ${sta1}

    # transform
    sta2=${sta1%.txt}
    sta2=${sta2}.transf.txt
    printf "./transformer ${npls} ${sta1} ${sta2} boxcox\n"
    ./transformer ${npls} ${sta1} ${sta2} boxcox

    # compress results
    printf "rm ${sta1}\n"
    rm ${sta1}
    printf "gzip ${sta2}\n"
    gzip -f ${sta2}
done


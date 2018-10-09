                         ###########################
                         ##Littoraria ABC analyses##
                         ###########################

CONTENTS

This folder "littoraria_abc_scripts" contains the files needed to repeat 
the ABC analyses conducted in this study. These files are the input data 
file and a set of scripts and executables that take the user from the input
file to the results. This README file depicts the structure and names of 
directories, as well as the symbolic links, that must initially be set out
to allow the scripts to run properly. This README file also explains how 
the different scripts should be used. Scripts are commented to provide 
further information about their specific use.
Note that the workflow is also available on github at:
https://github.com/lduvaux/littoraria_ABC2015

NOTICE

* It is very unlikely that the worflow will work just fine in your 
  working environment from the first attempt. Users will need to adapt 
  scripts to meet their specific needs (e.g. adapt symbolic links, change
  few environment variables). For instance, the worflow was originally 
  designed to be run on a Linux high performance computing (HPC) cluster 
  managed with SGE. Therefore, the entire workflow *HAS TO* be adapted in
  order to be run on another system.
* In order to better understand the worflow, the authors strongly suggest 
  to ABC beginners to read the following excellent introductions to ABC
  analyses:
      - Csilléry et al. 2012. abc: an R package for approximate Bayesian 
         computation (ABC). Methods in Ecology and Evolution.
      - Csilléry et al. 2015. Approximate Bayesian Computation (ABC) in R:
         A Vignette. (Vignette of the abc R package)
         https://cran.r-project.org/web/packages/abc/vignettes/abcvignette.pdf
* For more information or in order to report a possible problem, please
  contact Ludovic Duvaux at ludovic.duvaux@inra.fr

#################################################################################

DEPENDENCIES
- bash/Linux environment
- julia 0.3.11 (build julia-483dbf5279)
- R
- transformer (ABCtoolBox package)

#################################################################################

DIRECTORY STRUCTURE AND LIST OF FILES

.
├── 01_model_simulations
│   ├── 01_NM
│   │   ├── 01_prior2stats
│   │   │   ├── NM.jl
│   │   │   ├── SGE_prior2stats.sh
│   │   │   └── runSim.sh -> ../../../share/runSim.sh
│   │   ├── 02_PLS_transformation
│   │   │   ├── PLS-extraction.R -> ../../../share/PLS-extraction.R
│   │   │   ├── SGE_Extract-PLS.sh -> ../../../share/SGE_Extract-PLS.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   └── params.R
│   │   └── 03_ABC_Regression
│   │       ├── ABC_PLS-Regression.R -> ../../../share/ABC_PLS-Regression.R
│   │       ├── PLS_transform.sh -> ../../../share/PLS_transform.sh
│   │       ├── SGE_ABC_PLS-Regression.sh
│   │       ├── functions.R -> ../../../share/functions.R
│   │       ├── params.R
│   │       └── transformer -> ../../../share/transformer
│   ├── 02_CM
│   │   ├── 01_prior2stats
│   │   │   ├── CM.jl
│   │   │   ├── SGE_prior2stats.sh
│   │   │   └── runSim.sh -> ../../../share/runSim.sh
│   │   ├── 02_PLS_transformation
│   │   │   ├── PLS-extraction.R -> ../../../share/PLS-extraction.R
│   │   │   ├── SGE_Extract-PLS.sh -> ../../../share/SGE_Extract-PLS.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   └── params.R
│   │   └── 03_ABC_Regression
│   │       ├── ABC_PLS-Regression.R -> ../../../share/ABC_PLS-Regression.R
│   │       ├── PLS_transform.sh -> ../../../share/PLS_transform.sh
│   │       ├── SGE_ABC_PLS-Regression.sh
│   │       ├── functions.R -> ../../../share/functions.R
│   │       ├── params.R
│   │       └── transformer -> ../../../share/transformer
│   ├── 03_RM
│   │   ├── 01_prior2stats
│   │   │   ├── RM.jl
│   │   │   ├── SGE_prior2stats.sh
│   │   │   └── runSim.sh -> ../../../share/runSim.sh
│   │   ├── 02_PLS_transformation
│   │   │   ├── PLS-extraction.R -> ../../../share/PLS-extraction.R
│   │   │   ├── SGE_Extract-PLS.sh -> ../../../share/SGE_Extract-PLS.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   └── params.R
│   │   └── 03_ABC_Regression
│   │       ├── ABC_PLS-Regression.R -> ../../../share/ABC_PLS-Regression.R
│   │       ├── PLS_transform.sh -> ../../../share/PLS_transform.sh
│   │       ├── SGE_ABC_PLS-Regression.sh
│   │       ├── functions.R -> ../../../share/functions.R
│   │       ├── params.R
│   │       └── transformer -> ../../../share/transformer
│   ├── 04_AM
│   │   ├── 01_prior2stats
│   │   │   ├── AM.jl
│   │   │   ├── SGE_prior2stats.sh
│   │   │   └── runSim.sh -> ../../../share/runSim.sh
│   │   ├── 02_PLS_transformation
│   │   │   ├── PLS-extraction.R -> ../../../share/PLS-extraction.R
│   │   │   ├── SGE_Extract-PLS.sh -> ../../../share/SGE_Extract-PLS.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   └── params.R
│   │   └── 03_ABC_Regression
│   │       ├── ABC_PLS-Regression.R -> ../../../share/ABC_PLS-Regression.R
│   │       ├── PLS_transform.sh -> ../../../share/PLS_transform.sh
│   │       ├── SGE_ABC_PLS-Regression.sh
│   │       ├── functions.R -> ../../../share/functions.R
│   │       ├── params.R
│   │       └── transformer -> ../../../share/transformer
│   ├── ABCstat_observed_formatted.txt.gz -> ../ABCstat_observed_formatted.txt.gz
│   ├── SGE_migration_posteriors.sh -> ../share/SGE_migration_posteriors.sh
│   └── migration_posteriors.R -> ../share/migration_posteriors.R
├── 02_model_selection
│   ├── 01_stats_objects
│   │   ├── 01_NM
│   │   │   ├── SGE_stats_objects.sh -> ../../../share/SGE_stats_objects.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   ├── params.R
│   │   │   └── stats_objects.R -> ../../../share/stats_objects.R
│   │   ├── 02_CM
│   │   │   ├── SGE_stats_objects.sh -> ../../../share/SGE_stats_objects.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   ├── params.R
│   │   │   └── stats_objects.R -> ../../../share/stats_objects.R
│   │   ├── 03_RM
│   │   │   ├── SGE_stats_objects.sh -> ../../../share/SGE_stats_objects.sh
│   │   │   ├── functions.R -> ../../../share/functions.R
│   │   │   ├── params.R
│   │   │   └── stats_objects.R -> ../../../share/stats_objects.R
│   │   └── 04_AM
│   │       ├── SGE_stats_objects.sh -> ../../../share/SGE_stats_objects.sh
│   │       ├── functions.R -> ../../../share/functions.R
│   │       ├── params.R
│   │       └── stats_objects.R -> ../../../share/stats_objects.R
│   └── 02_post_probs
│       ├── SGE_model_selection.sh
│       └── model_selection_ABC.R
├── 03_cross_valid
│   ├── SGE_cross_valid.sh
│   ├── cross_valid_ABC.R
│   └── model_probs.R
├── 04_goodness_fit_pca
│   ├── SGE_goodness_fit_pca.sh
│   └── goodness_fit_pca.R
├── ABCstat_observed_formatted.txt.gz
├── README
└── share
    ├── ABC_PLS-Regression.R
    ├── MSSimulation.jl
    ├── N_segsites_locus.jl
    ├── PLS-extraction.R
    ├── PLS_transform.sh
    ├── SGE_Extract-PLS.sh
    ├── SGE_migration_posteriors.sh
    ├── SGE_stats_objects.sh
    ├── SimGenerator.jl
    ├── SimUtils.jl
    ├── functions.R
    ├── migration_posteriors.R
    ├── msnseg
    ├── msums
    ├── runSim.sh
    ├── stats_objects.R
    ├── task_remover.sh
    └── transformer

#################################################################################

GUIDELINES ON HOW TO USE THE SCRIPTS

I.     > Folders in the first level must be used in the following order:

           1 ./01_model_simulations
           2 ./02_model_selection
           3 ./03_cross_valid
           4 ./04_goodness_fit_pca

        Make sure all scripts in each of these four folders have finished running
        before moving on to the next folder.

       > File "ABCstat_observed_formatted.txt.gz" is the input data file. It
         contains the computed summary statistics of the observed data. Do not
         edit or move this file, it will be called and used by some scripts.
         It was computed using the program "msums" from the file
         "Littoraria_ms.txt", which was generated with the script
         "littoraria_ms_generator.R”.

       > Folder ./share in the first level contains a collection of various
         scripts and executables. Here are stored most of the original files that
         most symbolic links refer to. As with the input data file, there is no
         need to move these files; however, differently from the input data file,
         some scripts might need editing to meet specific computational needs.

II.    > Folder ./01_model_simulations contains files to simulate the data.
         There are four folders here:

           01_NM   # No migration
           02_CM   # Constant migration
           03_RM   # Recent migration
           04_AM   # Ancient migration

         These four folders can start to be used simultaneously, provided there
         is enough computational power. Each of these four folders has the same
         directory substructure:

           01_prior2stats          # generates the simulated datasets
           02_PLS_transformation   # performs the pls transformation
           03_ABC_Regression       # performs the regression

         These three folders above must be used in the order here presented
         within each foler containg them. Do not start using a folder without
         finishing using the previous one. For example, one correct sequence of
         use would be:

           ./01_model_simulations/02_CM/01_prior2stats
           ./01_model_simulations/02_CM/02_PLS_transformation
           ./01_model_simulations/02_CM/03_ABC_Regression

         Inside folders named 01_prior2stats, there are three files. The only
         script that needs to be run here is SGE_prior2stats.sh. The input data
         for this script is within the script itself. The other two files will be
         called by the running script.

         Inside folders named 02_PLS_transformation, there are four files. The
         only script that needs to be run here is SGE_Extract-PLS.sh. The input
         data will be called from the previous step. The other three files will
         be called by the running script.

         Inside folders named 03_ABC_Regression, there are six files. The only
         script that needs to be run here is SGE_ABC_PLS-Regression.sh. The input
         data will be called from the previous step. The other five files will
         be called by the running script.

III.    > Folder ./02_model_selection contains files to perform the model
         selection step. There are two folders here:

           01_stats_objects   # saves simulated summary statistics as R objects
           02_post_probs      # estimates posterior model probabilities

         These two folders must be used one after the other following the order
         just outlined above.

         Inside folder 01_stats_objects, there are four folders, one per model:

           01_NM   # No migration
           02_CM   # Constant migration
           03_RM   # Recent migration
           04_AM   # Ancient migration

         These four folders can start to be used simultaneously, provided there
         is enough computationl power. Inside each of these folders, there are
         four files. The only script that needs to be run here is
         SGE_stats_objects.sh. The input data will be called from the previous
         step. The other three files will be called by the running script.

         Inside folder 02_post_probs, there are two files. The only script that
         needs to be run here is SGE_model_selection.sh. The input data will be
         called from the previous step. The other only file will be called by the
         running script.

IV.   > Folder ./03_cross_valid contains files to perform the cross validation
         step. There are three files here. The only script that needs to be run
         here is SGE_cross_valid.sh. The input data will be called from the
         previous step. The cross_valid_ABC.R file will be called by the running
         script. Running the file model_probs.R is optional; it plots the density
         curves of posterior probabilities.

V.    > Folder ./04_goodness_fit_pca contains files to perform the goodness of
         fit pca step. There are two files here. The only script that needs to be
         run here is SGE_goodness_fit_pca.sh. The input data will be called from
         the previous step. The other only file will be called by the running
         script.

#################################################################################

WORKFLOW AUTHORS

Mauricio Montano-Rendon, Martin Hinsch & Ludovic Duvaux

#################################################################################
REFERENCE

Hollander et al. (In press). ARE ASSORTATIVE MATING AND GENITAL DIVERGENCE 
DRIVEN BY REINFORCEMENT? Evolution Letters.

#################################################################################

CONTACT

ludovic.duvaux@inra.fr

#################################################################################

CREDITS and ACKOWLEDGMENTS are given in the article where these
analyses are originally described.

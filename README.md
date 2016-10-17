# littoraria_ABC2015

Project to infer reinformcement in two species of Australian periwinkles.
</p>
___
## Miscellaneous notes
### Behaviour of the 'transformer' program to transform the original statistics
To work properly the program needs:
- an input stat file including all the retained stats in the script 'PLS-extraction.R' to extract the PLS components
- the stats names have to be the same.

As long as this is respected, the input stat file can contain any supplementary stats (e.g. stats computed but not used and not filtered out from the files). This won't influence the transformation. The positions of these supplementary stats in the matrix does not matter either (i.e. they can be before, in between or after the needed stats). </p>
I tested this [here](/home/ludovic/Documents/01_professional/06_Projects_experiments/2010-2012_Shef_NERC1/01_Shef_NERC1_capture/04_ABC_demography_selection/01_Main_project/src/0.2_git_repos/littoraria_ABC2015.git).</p>

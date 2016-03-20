using Distributions
using SimGenerator


# Model with recent migration.
# Loci share demographic parameters (Ni, Ts, Mi) and mutation rates.
# A set of loci is treated as one data point, therefore theta and rho
# become nuisance parameters while migration rates are the priors for
# the ABC analysis.


# Setup the simulation. [REQUIRED]
@setup MSSimulation begin

#	set some global variables (accessible throughout the entire file)
	n0 = 1e4                # size of reference population
	mu = 3e-9               # mutation rate
	n_sites = 82            # locus length
	n_repl = int(ARGS[1])   # number of datasets (i.e. dataset simulations)
	n_loci = int(ARGS[2])   # number of loci per dataset
	theta0 = 4 * n0 * mu * n_sites

	# get some values from the command line
		# here the random seed
	srand(int(ARGS[3]))
	# suffix of the output files
	suf = ARGS[4]

	# total number of simulations performed by ms
	@par n_simulations  n_repl * n_loci
	# add constraints on number of segsites per locus (msnseg parameter -S, -M and -Z, respectively)
	@par snps           ["S" => int(ARGS[5]), "M" => int(ARGS[6]), "Z" => int(ARGS[7])]
	# for more than one population sample sizes are given as a list
	@par n_samples      [5, 5, 5, 5]	# 5 chromosomes per population
	@par theta          theta0
	# @par rho          TBS	# no recombination in our case
	@par n_sites        n_sites # needed for proper set of simulations.
	@par N              [TBS, TBS, TBS, TBS]
	# migration: only M12, M21, M23, M32, M34 and M43 are relevant here
	@par mig            [ [NaN TBS 0 0]; [TBS NaN TBS 0]; [0 TBS NaN TBS]; [0 0 TBS NaN] ]
	@par history        [ [:time => TBS, :type => :mig, :rates => ["m23" => [3, 2, 0], "m32" => [2, 3, 0] ] ],
                          [:time => TBS, :type => :join, :pops => [2, 1] ],
                          [:time => TBS, :type => :num, :sizes => [1 => TBS] ],
                          [:time => TBS, :type => :join, :pops => [4, 3] ],
                          [:time => TBS, :type => :num, :sizes => [3 => TBS] ],
                          [:time => TBS, :type => :join, :pops => [3, 1] ],
                          [:time => TBS, :type => :num, :sizes => [1 => TBS] ] ]
end


# Dataset of n_loci independent loci: what differ between datasets? [REQUIRED]
@level dataset begin
	@range n_repl

	# uniform priors on Ni=[5e4-5e5]=[5-50]*N0
	N1 = rand() * (100 - 5) + 5
	N2 = rand() * (100 - 5) + 5
	N3 = rand() * (100 - 5) + 5
	N4 = rand() * (100 - 5) + 5
	@par N              [N1, N2, N3, N4]

	# uniform priors on migration rates Mij: [1e-3 - 1e1]
        # M23 and M32 will be drawn from a beta
        # let's fix the value to zero here
        # the value will be updated in the section of the 'locus' level
	M12 = 10.0 ^ (rand() * (1 - (-3)) - 3)
	M21 = M12
	M23 = 0 # will be updated at level 'locus' 
	M32 = 0 # will be updated at level 'locus' 
	M34 = 10.0 ^ (rand() * (1 - (-3)) - 3)
	M43 = M34
    # so here is a vector of fixed values for all loci, however, M23 and M32
    # will be updated at the 'locus' level (see 'locus' level section below)
	@par mig            [M12, M21, M23, M32, M34, M43]

    # Beta distributions for M23 and M32:
        # we want a specific Beta for each of M23 and M32 as we don't use
        # the 'c' scale parameter of Roux et al. 2013
            # shape parameters Alpha=[0-20], Beta=[0-200] for both distribs
	@par mig_B23_par			[rand()*1, rand()*1000]    
	@par mig_B32_par			[rand()*1, rand()*1000]    
    
	# uniform priors on historical events (in years):
	T4 = rand() * (5e6 - 5e5) + 5e5       # [5e5 - 5e6] years
	T3 = rand() * (T4 - 50) + 50          # [50 - T4] years
	T2 = rand() * (T4 - 50) + 50          # [50 - T4] years
	T1 = rand() * (min(T2, T3) - 0) + 0   # [0 - min(T2, T3)] years
		# convert times in unit of 4N0 generations (1 generation a year)
	T1 = T1 / (4 * n0)
	T2 = T2 / (4 * n0)
	T3 = T3 / (4 * n0)
	T4 = T4 / (4 * n0)

	# uniform priors on Na=[5e4-5e5]=[5-50]*N0
	N5 = rand() * (100 - 5) + 5
	N6 = N5
	N7 = N5
	@par history        [T1, T1, T2, T2, N5, T3, T3, N6, T4, T4, N7]
end


# Set parameters across loci within datasets. If anything varies, it has to be set here. [REQUIRED]
	# In this case nothing varies. Only a dummy parameter, e.g. theta, is needed
	# in order to generate the good number of priors for ms (n_rep * n_loci)
@level locus begin
	@range n_loci   # range over which we should set the locus parameter, i.e. number of loci

    # dummy parameter just in case there's nothing else
	@par theta          theta0
    
    # migration:  here we update M23 and M32 for each locus (we are at
    # level 'locus'). They are respectively in positions 3 and 4 of the 
    # vector mig (called mig_fixed in this section)
        # set new parameter names for use at level 'locus'
    mig_B23_p = @par(mig_B23_par)
    mig_B32_p = @par(mig_B32_par)
    mig_fixed = @par(mig)
    
        # update M23 and M32
            # start with m23 and m32 (varies between 0 and 0.5)
    mig_B23 = rand(Beta(mig_B23_p[1], mig_B23_p[2]), 1)
    mig_B32 = rand(Beta(mig_B32_p[1], mig_B32_p[2]), 1)
            # then M23 and M32
    M23 = mig_B23 * 10 # the scalar is the upper bound of the parameter
    M32 = mig_B32 * 10 # the scalar is the upper bound of the parameter
        # update in vector mig_fixed
    mig_fixed[3] = M23[1]   # don't forget the '[1]' or there will be a type convertion issue
    mig_fixed[4] = M32[1]   # don't forget the '[1]' or there will be a type convertion issue
    
    # declare vector 'mig_fixed' as vector of values for parameter mig
    @par mig            mig_fixed
end


# Declare which variables are to be printed out as priors (for ABC analysis).
# Theta and rho are nuisance parameters, the relevant ones are Ni, Ts and Mi.
# Since summary statistics will be computed over an entire set of loci, then
# they have to be printed *once per dataset*. [REQUIRED]
@set priors begin
	# the level to use can be chosen
	@at_level dataset     # required

	# declare number of parameters
	@par N        4
	@par mig      6
    @par mig_B23_par    2
    @par mig_B32_par    2
	@par history 11

end


# Declare which level should be considered as a single sample in terms
# of summary statistics (used for spinput generation). [REQUIRED]
@set sample dataset


# Run, this time print priors as well as the spinput file (for the summary statistics). [REQUIRED]
@set run begin
	@ms_out         ARGS[8]
	@priors_out     "priors_" * suf * ".txt"
	@spinput_out    "spinput_" * suf * ".txt"
	@command        "msnseg"
end

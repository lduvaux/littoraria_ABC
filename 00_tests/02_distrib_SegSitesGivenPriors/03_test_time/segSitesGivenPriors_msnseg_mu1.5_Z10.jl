using Distributions
using SimGenerator


# Model with inter-species migration. 
# Loci share demographic parameters (Ni, Ts, Mi) and mutation rates but differ
# with respect to sample sizes. Furthermore we essentially want to treat a set
# of loci as one data point, therefore theta and rho become nuisance parameters
# while migration rates are our priors for the ABC analysis.


# Setup the simulation. [REQUIRED].
@setup MSSimulation begin

#	some global variable (accessible throughout the entire file).
	n0 = 1e5	# size of reference population
	mu = 1.5e-9	# mutation rate
	# r = 0		# recombination rate, not needed here
	n_sites = 82	# tag length
	n_repl = 10000 # number of datasets (i.e. dataset simulations).
	n_loci = 50	# We want to simulate several loci.
	theta0 = 4 * n0 * mu * n_sites

	# get some values from the command line
		# here the random seed
	srand(213)
	# can be whatever though, we can also be
		# suffix for outputs
	suf = "DistSegSites_msnseg_mu1.5_Z10"

	# total number of simulations performed by ms
	@par n_simulations 	n_repl * n_loci
	# add snp criteria (msnseg parameter)
	@par snps 			[1, 4, 10]
	# For more than one population sample sizes are given as a list.
	@par n_samples		[5, 5, 5, 5]	# 5 chromosomes per population
	@par theta			theta0
	# @par rho			TBS	# no recombination in our case
	@par n_sites		n_sites # needed for proper set of simulations.
	@par N				[TBS, TBS, TBS, TBS]
	# migration: only M12, M21, M23, M32, M34 and M43 are relevant here.
	@par mig			[ [NaN TBS 0 0]; [TBS NaN TBS 0]; [0 TBS NaN TBS]; [0 0 TBS NaN] ]
	@par history		[ 	[:time => TBS, :type => :join, :pops => [2, 1]] 
				     		[:time => TBS, :type => :join, :pops => [4, 3]] 
				     		[:time => TBS, :type => :join, :pops => [3, 1]]]

end

# Dataset of n_loci independent loci: what differ between datasets? [REQUIRED].
@level dataset begin
	@range n_repl

	# Uniform priors on Ni=[0.5-5]*N0
	@par N				[rand() * (5 - 0.5) + 0.5, rand() * (5 - 0.5) + 0.5, rand() * (5 - 0.5) + 0.5, rand() * (5 - 0.5) + 0.5]
	
	# Uniform priors on migration rates Mij: inter-spe [0-2], intra-spe[0-10]
	M23 = rand() * 2	# inter-spe
	M32 = rand() * 2	# inter-spe
	M12 = rand() * 10	# intra-spe
	M21 = rand() * 10	# intra-spe
	M34 = rand() * 10	# intra-spe
	M43 = rand() * 10	# intra-spe
	@par mig			[M12, M21, M23, M32, M34, M43]
	
	# uniform priors on historical events with h3 > h1 & h3 > h2
	h1 = rand() * (1 - 0.5)  + 0.5	# 4*[0.5 - 1]*N0
	h2 = rand() * (1 - 0.5)  + 0.5	 # 4*[0.5 - 1]*N0
	max_intraT = max(h1, h2)
	h3 = rand() * (5 - max_intraT) + max_intraT	# 4*[0.5 - 5]*N0, h3 > h1 & h3 > h2
	@par history		[h1, h2, h3]
end

# Set parameters across loci within datasets. If any varies, it has to be set here. [REQUIRED].
	# in our case, nothing varies. In this case we just need to set 
	# a dummy parameter, e.g. theta, in order to generate the good number 
	# of priors for ms (n_rep * n_loci)
@level locus begin
	@range n_loci	# range over which we should set the locus parameter, i.e. number of loci

	@par theta			theta0
end


# Declare which variables are to be printed out as priors (for ABC analysis).
# Theta and rho are nuisance parameters, the ones we are interested in are 
# (Ni, Ts, Mi). Since we will compute summary statistics over an entire
# set of loci we want them to be printed *once per dataset*. [REQUIRED].
@set priors begin
	# We can choose which level to use.
	@at_level dataset			# required

	# We have to tell the system that mig has 6 values (the same being
	# true for all parameters).
	@par N				4
	@par mig			6
	@par history		3

end

# Declare which level should be considered as a single sample in terms
# of summary stats (used for spinput generation). [REQUIRED].
@set sample dataset


# Run, this time print priors as well as the spinput file (for the summary stats). [REQUIRED].
@set run begin
	@ms_out			"ms-ali_" * suf * ".txt"
	@priors_out		"priors_" * suf * ".txt"
	@spinput_out	"spinput_" * suf * ".txt"
	@command		"./msnseg"
end




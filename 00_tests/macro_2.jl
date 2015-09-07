using Distributions
using SimGenerator


# Slightly more involved example. This time we want to simulate a number of
# loci per replicate. Loci share demographic parameters (migration rates) but 
# differ with respect to mutation and recombination rates. Furthermore we 
# essentially want to treat a set of loci as one data point, therefore theta
# and rho become nuisance parameters while migration rates are our priors for
# the ABC analysis.


# Setup the simulation.
@setup MSSimulation begin

	# Variables defined here are accessible throughout the entire parameter file.
	n_sites = 500
	# Now we want to simulate several loci.
	n_loci = 20
	# And this is the number of replicates.
	n_repl = 100

	@par n_simulations 	n_repl * n_loci
	# For more than one population sample sizes are given as a list.
	@par n_samples		[25, 35, 40]
	@par n_sites		n_sites
	@par theta			TBS
	@par rho			TBS
	# Migration matrix - diagonal elements are ignored.
	@par mig			[ [NaN TBS TBS]; [TBS NaN TBS]; [TBS TBS NaN] ]
end


# Replicates.
@level replicate begin
	@range n_repl

	# Migration rates vary between replicates.
	# (That means they are identical for all loci within one replicate!)
	@par mig			[rand()*10, rand()*10, rand()*10, rand()*10, rand()*10, rand()*10]
end


# For each replicate we want a number of loci to be simulated.
@level locus begin
	@range n_loci

	# Loci vary with respect to theta and rho.
	n0 = 100000
	mu = 3.5e-9
	r = 5e-8

	@par theta			(rand()+0.5) * 4 * mu * n0 * n_sites
	@par rho			(rand()+0.5) * 4 * r * n0 * n_sites
end


# Declare which variables are to be printed out as priors (for ABC analysis).
# Theta and rho are nuisance parameters, the ones we are interested in are 
# the migration rates. Since we will compute summary statistics over an entire
# set of loci we want migration parameters to be printed *once per replicate*.
@set priors begin
	# We can choose which level to use.
	@at_level replicate			# required

	# We have to tell the system that mig has 6 values.
	@par mig			6
end

# Declare which level should be considered as a single sample in terms
# of summary stats (used for spinput generation).
@set sample replicate


# Run, this time print priors as well as the spinput file (for the summary stats).
@set run begin
	@ms_out			"out_macro2.txt"
	@priors_out		"priors_macro2.txt"
	@spinput_out	"spinput.txt"
	@command		"msnsam"
end




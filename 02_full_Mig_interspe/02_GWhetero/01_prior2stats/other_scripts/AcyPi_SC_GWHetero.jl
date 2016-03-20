# works with version ...
using Distributions
using SimGenerator

function read_nsites(spinput)
    # function get locus length from spinput file
    f = open(spinput, "r")
    n_length = Int64[]
	for l in eachline(f)
        if (l == "")
            continue
        end
        
        if contains(l, "// length of locus ")
            elem = split(l, '\t')
            push!(n_length, int(elem[1]))
        end
    end
    close(f)
    n_length
end

# Setup the simulation.
@setup MSSimulation begin
    # get some values from the command line
    my_nsites = read_nsites(ARGS[1])    # get locus lengths
    n_repl = int(ARGS[2])
    srand(int(ARGS[3])) # rand seed
    pref = ARGS[4]  # prefix of the outputs
    
    # some global variables
    n_loci = length(my_nsites)
    n0 = 10000
    mu = 3.5e-9
    r = 1.2e-8
    n_samples = [24, 20]


    @par n_simulations 	n_repl * sum(n_loci)
    @par n_samples		n_samples
    @par n_sites		TBS
    @par theta			TBS
    @par rho			TBS
    @par N				[TBS, TBS]
    @par mig			[ [NaN TBS]; [TBS NaN] ]
    # each history event needs time, type, pops
    @par history		[   
        [:time => TBS, :type => :mig, :rates => [(1, 2, 0), (2, 1, 0)]	],
        [:time => TBS, :type => :join, :pops => [2, 1]],
        [:time => TBS, :type => :num, :sizes => [(1, TBS)]]
                        ] 
end

# this is one dataset (in ms terminology)
@level dataset begin
    @range n_repl 

    # Uniform priors on Ni=[1e4-8e5]=[1-80]*N0
    N1 = rand() * (60 - 3) + 3
    N2 = rand() * (60 - 3) + 3
    @par N				[N1, N2]

    # parameters of the migration rate Beta distributions, two pops so:
        # 4 shape parameters Alpha=[0-20], Beta=[0-200]
        # 2 scale parameters [0-10]
        # WARNING: for th emoment, I don't know if such a possibility is implemented
        # so I stuck with one beta for both pops
	@par mig			[rand()*20, rand()*200, rand()*15, rand()*15]

    # historical events
        # divergence time
    Td = rand() * (3e5 - 2e3) + 2e3			# [2e3 - 3e5] years
    max_born = min(1e5, Td)
    Tm = rand() * (max_born - 1e3) + 1e3
    
    # divide by 4*N0 for ms
    Td = Td / (4 * n0)                          
    Tm = Tm / (4 * n0)
        # ancestral popsize
    Na = rand() * (60 - 3) + 3                 # Na=[1e4-5e5]=[1-50]*N0

    # here the values of the TBS pars of history (:time) and mig are set 
    # values will differ between datasets
    @par history		[Tm, Tm, Td, Td, Na]
end

# Declare which variables are to be printed out as priors (for ABC analysis).
# The ones we are interested in are the migration values and the history events.
# Since we will compute summary statistics over an entire set of loci we want
# them to be printed *once per dataset*.
@set priors begin
    # We can choose which level to use.
    @at_level dataset			# required

    # We have to tell the system the number and names of parameters
    @par N              ["N1", "N2"]
    @par mig            ["shapeA", "shapeB", "scale1", "scale2"]
    @par history        ["Tm", "Tm", "Td", "Td", "Na"]
end

# Add loci. Number is determined in groupofloci, thus no @range needed.
@level locus begin
	# range over which we should set the locus parameter, i.e. number of loci
	@range n_loci
    gol = @par(locus)
    nsites = my_nsites[gol]

    # migration parameters same Beta, different scale
    mig_par = @par(mig)
    
    @par theta          4 * mu * n0 * nsites
    @par rho            4 * r * n0 * nsites
	@par n_sites        nsites
    # for each locus, the migration rate is the product of a random beta value
    # defined by the shape parameters (constant per datasets) and the 
    # migration rate (M12 & M21) specific scalar (constant for a given datset)
    @par mig            rand(Beta(mig_par[1], mig_par[2]), 2) .* mig_par[3:4]
    
end

# Declare which level should be considered as a single sample in terms
# of summary stats (used for spinput generation).
@set sample dataset

# Run, this time print priors as well as the spinput file (for the summary stats).
@set run begin
    @ms_out			"$(pref).ms"
    @priors_out		"$(pref).priors.gz"
    @spinput_out	"$(pref).spi"
    @params_out		"$(pref).params.gz"
    @command		"msnsam"
end




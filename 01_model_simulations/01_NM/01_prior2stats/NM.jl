using Distributions
using SimGenerator


# Model with no migration.
# Loci share demographic parameters (Ni, Ts, Mi) and mutation rates.
# A set of loci is treated as one data point, therefore theta and rho
# become nuisance parameters while migration rates are the parameters
# of interest for the ABC analysis.


# Setup the simulation. [REQUIRED]
@setup MSSimulation begin

    # set some global variables (accessible throughout the entire file)
    n0 = 1e4                # size of reference population
    mu = 3e-9               # mutation rate
    n_sites = 82            # locus length
    n_repl = int(ARGS[1])   # number of datasets (i.e. dataset simulations)
    n_loci = int(ARGS[2])   # number of loci per dataset
    theta0 = 4 * n0 * mu * n_sites

    # get some values from the command line
        # random seed
        srand(int(ARGS[3]))
        # suffix of the output files
        suf = ARGS[4]

    # total number of simulations performed by msnseg
    @par n_simulations  n_repl * n_loci
    # add constraints on number of segsites per locus (msnseg parameter -S, -M and -Z, respectively)
    @par snps           ["S" => int(ARGS[5]), "M" => int(ARGS[6]), "Z" => int(ARGS[7])]
    # for more than one population sample sizes are given as a list
    @par n_samples      [5, 5, 5, 5] # 5 chromosomes per population
    @par theta          theta0
    # @par rho          TBS # no recombination in our case
    @par n_sites        n_sites # needed for proper set of simulations
    @par N              [TBS, TBS, TBS, TBS]
    # migration: only M12, M21, M34 and M43 are relevant here
    @par mig            [ [NaN TBS 0 0]; [TBS NaN 0 0]; [0 0 NaN TBS]; [0 0 TBS NaN] ]
    @par history        [ [:time => TBS, :type => :join, :pops => [2, 1] ],
                          [:time => TBS, :type => :num, :sizes => [1 => TBS] ],
                          [:time => TBS, :type => :join, :pops => [4, 3] ],
                          [:time => TBS, :type => :num, :sizes => [3 => TBS] ],
                          [:time => TBS, :type => :join, :pops => [3, 1] ],
                          [:time => TBS, :type => :num, :sizes => [1 => TBS] ] ]
end


# Dataset of n_loci independent loci: what differ between datasets? [REQUIRED]
@level dataset begin
    @range n_repl

    # uniform priors on Ni = [5e4 - 1.5e6] = [5 - 150] * n0
    N1 = rand() * (150 - 5) + 5
    N2 = rand() * (150 - 5) + 5
    N3 = rand() * (150 - 5) + 5
    N4 = rand() * (150 - 5) + 5
    @par N              [N1, N2, N3, N4]

    # log-uniform priors on migration rates Mij = [1e-3 - 1e1]
    M12 = 10.0 ^ (rand() * (1 - (-3)) + (-3))
    M21 = M12
    M34 = 10.0 ^ (rand() * (1 - (-3)) + (-3))
    M43 = M34
    @par mig            [M12, M21, M34, M43]

    # uniform priors on historical events (in years):
    T4 = rand() * (5e6 - 5e5) + 5e5     # [5e5 - 5e6] years
    T3 = rand() * (T4 - 0) + 0          # [0 - T4] years
    T2 = rand() * (T4 - 0) + 0          # [0 - T4] years
        # convert times in unit of 4N0 generations (1 generation a year)
    T2 = T2 / (4 * n0)
    T3 = T3 / (4 * n0)
    T4 = T4 / (4 * n0)

    # uniform priors on Na = [5e4 - 1.5e6] = [5 - 150] * n0
    N5 = rand() * (150 - 5) + 5
    N6 = N5
    N7 = N5
    @par history        [T2, T2, N5, T3, T3, N6, T4, T4, N7]
end


# Set parameters across loci within datasets. If anything varies, it has to be set here. [REQUIRED]
    # In this case nothing varies across loci.
    # When nothing varies, a dummy parameter (e.g. theta) is needed in
    # order to generate the good number of priors for msnseg (n_rep * n_loci)

@level locus begin
    @range n_loci # range over which we should set the locus parameter, i.e. number of loci

    # dummy parameter in case there is nothing else
    @par theta          theta0
end


# Declare which variables are to be printed out as priors (for ABC analysis).
# Theta and rho are nuisance parameters, the relevant ones are Ni, Ts and Mi.
# Since summary statistics will be computed over an entire set of loci, then
# they have to be printed *once per dataset*. [REQUIRED]
@set priors begin
    # the level to use can be chosen
    @at_level dataset # required

    # declare number of parameters
    @par N            4
    @par mig          4
    @par history      9
end


# Declare which level should be considered as a single sample in terms
# of summary statistics (used for spinput generation). [REQUIRED]
@set sample dataset


# Run, this time print priors as well as the spinput file (for the summary statistics). [REQUIRED]
@set run begin
    @ms_out       ARGS[8]
    @priors_out   "priors_" * suf * ".txt"
    @spinput_out  "spinput_" * suf * ".txt"
    @command      "msnseg"
end

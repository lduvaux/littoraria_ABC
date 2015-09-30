export JULIA_LOAD_PATH=$JULIA_LOAD_PATH:~/bin   # simgenerator modules path (MSSimulation.jl  SimGenerator.jl  SimUtils.jl)
export PATH=$PATH:../../binaries    # executable path (msnsam, msums, fastsimcoal)

julia "$@"  # call julia

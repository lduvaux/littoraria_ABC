module MSSimulation


export MSSim, TBS, level, run, priors, get_simulation, sample

using SimGenerator, SimUtils, GZip

type MSSim
	sim::Simulation
	tbs::Vector{Symbol}
	priors_header::ASCIIString
	sample::Symbol
	cmd
end


function MSSim(sim::Simulation)
	pars = sim.setup
	tbs = collect_tbs(pars)
	cmd = gen_command(pars)
	MSSim(sim, tbs, "", :nil, cmd)
end

function MSSim(par::Parameter)
	MSSim(Simulation(par))
end

#typealias SimType MSSim
#function get_simulation(s::MSSim)
#	s.sim
#end

@setup_module MSSim

TBS = :tbs

find_tbs(s::Symbol) = s == TBS ? true : false

find_tbs{T}(s::T) = false

function find_tbs(a::Array)
	for e in a
		if find_tbs(e)
			return true
		end
	end

	false
end

function find_tbs(d::Dict)
	for (n, v) in d
		if find_tbs(v)
			return true
		end
	end
	
	false
end

function collect_tbs(pars::Parameter)
	tbs = Symbol[]

	for name in [:theta, :rho, :n_sites, :N, :mig, :history]
		with_key(pars, name) do par
			if find_tbs(par)
				push!(tbs, name)
			end
		end
	end

	tbs
end


function add_param(cmd, pars::Parameter, name, flag)
	if !haskey(pars, name)
		return cmd, false
	end

	p = pars[name]
	add_flag(cmd, flag, ` $p`), true
end

add_flag(cmd, flag, val) = `$cmd $flag $val`

function add_flag(cmd, flag, val::Array)
	cmd = `$cmd $flag`
	for v in val
		cmd = `$cmd $v`
	end
	cmd
end

# might need this if we want to preserve g over changes in n
# possibly also for migration rates
# doesn't do anything for now
type MSHistory
	cmd
end

function add_history!(hist, h)
	t = h[:time]
	ty = h[:type]

	if ty == :join
		pops = h[:pops]
		hist.cmd = `$(hist.cmd) -ej $t $(pops[1]) $(pops[2])`
		return
	end

	if ty == :split
		pop = h[:pop]; p = h[:p]
		hist.cmd = `$(hist.cmd) -es $t $pop $p`
		return
	end

	if ty == :mig

		if with_key(h, :rate) do rate
				hist.cmd = `$(hist.cmd) -eM $t $rate`
			end
			return 
		end

		if with_key(h, :rates) do r
				if ! isa(r, Dict)
					error(":rates expects a Dict!")
				end
				flag = ``
				for (idx, v) in r
					flag = `$flag -em $t $(v[1]) $(v[2]) $(v[3])`
				end
				hist.cmd = `$(hist.cmd) $flag`
			end
			return
		end

		if with_key(h, :matrix) do m
				flag = ` -ema $t $(size(m, 1))`
				for i in 1:size(m, 1)
					for j in 1:size(m, 2)
						flag = `$flag $i $j $(m[i, j])`
					end
				end
				hist.cmd = `$(hist.cmd) $flag`
			end
			return
		end
		
		error("unknown mig spec!")
	end

	if ty == :num
		if with_key(h, :size) do s
				hist.cmd = `$(hist.cmd) -eN $t $s`
			end
			return
		end

		if with_key(h, :sizes) do sizes
				if ! isa(sizes, Dict)
					error(":sizes expects a Dict!")
				end
				flag = ``
				for (idx, v) in sizes
					flag = `$flag -en $t $idx $v`
				end
				hist.cmd = `$(hist.cmd) $flag`
			end
			return
		end
		
		error("unknown :num spec - :size or :sizes required!") 
	end

	if ty == :growth
		if with_key(h, :rate) do r
				hist.cmd = `$(hist.cmd) -eG $t $r`
			end
			return
		end

		if with_key(h, :rates) do rates
				flag = ``
				for r in rates
					flag = `$flag -eg $t $(r[1]) $(r[2])`
				end
				hist.cmd = `$(hist.cmd) $flag`
			end
			return
		end

		error("unknown growth spec!")
	end

	error("unknown event type $ty!")
end

function gen_command(pars)
	cmd = ``
	
	required(pars, :n_samples, "number of samples (:n_samples) required!")
	n_samples = pars[:n_samples]
	ns = sum(n_samples)
	cmd = `$cmd $ns`
	n_pops = length(n_samples)

	required(pars, :n_simulations, 
		"number of simulations (:n_simulations) required!")
	n_sims = pars[:n_simulations]
	cmd = `$cmd $n_sims`

	required(pars, :theta, "parameter theta required!")
	cmd, f = add_param(cmd, pars, :theta, `-t`)
	cmd, f = add_param(cmd, pars, :rho, `-r`)
	if f
		cmd, f = add_param(cmd, pars, :n_sites, ``)
	end

	# option for msnseg (Ludovic 10/09/2015)
	if with_key(pars, :snps) do s
			if ! isa(s, Dict)
				error(":snps expects a Dict!")
			end
			flag = ``
			for (idx, v) in s
				flag = `$flag -$idx $v`
			end
			cmd = `$cmd $flag`
		end
	end

	if (n_pops > 1)
		cmd = add_flag(cmd, `-I`, n_pops)
		cmd = add_flag(cmd, ``, n_samples)
	end

	if (n_pops > 1)
		with_key(pars, :N) do n
			for i in 1:length(n)
				cmd = add_flag(cmd, `-n $i`, n[i])
			end
		end
	end

	with_key(pars, :mig) do mig
		for i in 1:size(mig, 1)
			for j in 1:size(mig, 2)
				if i==j 
					continue
				end
				cmd = add_flag(cmd, `-m $i $j`, mig[i, j])
			end
		end
	end

	with_key(pars, :history) do hist
		msh = MSHistory(cmd)
		for h in hist
			add_history!(msh, h)
		end

		cmd = msh.cmd
	end

	cmd
end

@keyword_symbol at_level
@keyword_single ms_out
@keyword_single priors_out
@keyword_single spinput_out
@keyword_single params_out
@keyword_single command

function priors(sim::MSSim, vars...; at_level::Symbol = :nil)
	if at_level == :nil
		error("priors needs a level!")
	end

	sim.priors_header = print_with_header(sim.sim, at_level, :priors_out, vars...)
end

function sample(sim::MSSim, s::Symbol)
	sim.sample = s
end

function run(sim::MSSim; ms_out = (), priors_out = (), spinput_out = (), params_out = (), command = "./msnsam")
	write_spinput = false

	if priors_out != ()
		priors_out = priors_out*".gz"
		pr_out = 
			isa(priors_out, String) ? 
				GZip.gzopen(priors_out, "w") :
				priors_out
		GZip.write(pr_out, sim.priors_header, "\n")
		sim.sim.setup[:priors_out] = pr_out
	end

	if spinput_out != ()
		if ! isa(ms_out, String)
			error("ms output file name needed for spinput generation!")
		end

		if sim.sample == :nil
			error("sample level required (@set sample)!")
		end

		write_spinput = true
		sp_out =
			isa(spinput_out, String) ?
				open(spinput_out, "w") :
				spinput_out
		spinput = Array(Vector{Int}, 0)
	end

	if isa(params_out, String)
		params_out = open(params_out, "w")
	end

	sim.cmd = `$command $(sim.cmd)`

	println(STDERR, "running ms with these parameters:\n$(sim.cmd)")

	if ms_out != ()
		sim.cmd = sim.cmd |> ms_out
	end
	out, proc = open(sim.cmd, "w")

	n_sims::Int = 0
	n_loci::Int = 0
	first_dataset = write_spinput
	dataset = ()

	# set filter for lowest level
	set_receiver(sim.sim) do par::Parameter
		# use the first dataset to count loci
		if first_dataset
			ds = par[sim.sample]
			if n_loci == 0
				dataset = ds
			end
			if dataset != ds
				first_dataset = false
			else
				push!(spinput, [par[:n_samples], par[:n_sites]])
				n_loci += 1
			end
		end

		# there might be no tbs parameters
		if ! isempty(sim.tbs)
			line::ASCIIString = gen_par_line(sim.tbs, par)
			if (params_out != ())
				println(params_out, line)
				flush(params_out)
			end
			println(out, line)
		end

		n_sims += 1
	end

	generate(sim.sim)

	if write_spinput
		println(sp_out, n_loci)
		println(sp_out, length(spinput[1])-1)

		for l in spinput, n in l
			println(sp_out, n)
		end

		println(sp_out, div(n_sims, n_loci))
		println(sp_out, ms_out)
	end

	if isa(priors_out, String)
		GZip.close(pr_out)
	end

	if isa(spinput_out, String)
		close(sp_out)
	end

	if isa(params_out, String)
		close(params_out)
	end

	wait(proc)

	proc.exitcode
end


end	# MSSimulation

module SimGenerator

export Simulation, add_level, generate, nop, Parameter, set_filter, set_receiver
export with_key, for_subset, gen_par_line, get_simulation, required, print_with_header
export @level, @par, @setup, @set, make_kw_arg, @keyword_single, @keyword_symbol
export @setup_module

using SimUtils

typealias Parameter Dict{Symbol, Any}

type Generator
	map::Function
	filter::Function
	name::Symbol
	range
end

nop(x) = Parameter()

type Simulation
	setup::Parameter
	geners::Vector{Generator}
end

Simulation(s::Parameter) = Simulation(s, Array(Generator, 0))

# obtain a Simulation object, faking OOP inheritance
# overload for custom simulations
function get_simulation(s::Simulation)
	s
end

macro setup_module(type_name)
	esc(quote
		typealias SimType $(type_name)

		get_simulation(sim::SimType) = sim.sim
		export get_simulation
	end)
end

# add a level of parameter sweeps
# gen has to return a Parameters object
# if range is Nothing name is expected to contain a range
# preset by the previous level
function add_level(gen::Function, sim::Simulation, name::Symbol, range = ())
	push!(sim.geners, Generator(gen, identity, name, range))
end

# setup the simulation
# imports the simulation module given as mod
# @par lines are used to initialize a parameter object, everything
# else is moved into a (global) preamble
# a global simulation object (to be used further down) is created
macro setup(mod, par)
	if par.head != :block
		error("@setup expects a block (begin...end)!")
	end

	constr = quote
		par = Parameter()
	end

	preamble = Expr(:block)
	
	# check all lines in the block
	for line in par.args
		# @par macro call, sets parameter values
		if isa(line, Expr) && line.head == :macrocall && 
			line.args[1] == symbol("@par")
			vname = line.args[2]
			val = line.args[3]
			push!(constr.args, 
				Expr(:(=), Expr(:ref, :par, QuoteNode(vname)), esc(val)))
		# otherwise -> preamble
		else
			push!(preamble.args, esc(line))
		end
	end

	result = Expr(:block)
	# using statement to include custom simulation module
	push!(result.args, Expr(:using, mod))
	# first preamble
	append!(result.args, preamble.args)
	# then parameter construction
	append!(result.args, constr.args)
	# create global simulation object
	push!(result.args, Expr(:(=), esc(:(__simulation)), :($(esc(mod)).SimType(par))))
	return result
end

# @par as used inside @level
# @par(x) *reads* value x in *old* parameter
# @par(x, y) *sets* value x to y in *new* parameter
# TODO: possibly split into two separate macros
macro par(name, value...)
	# @par(x)
	if isempty(value)
		return esc(Expr(:ref, :__parameter, QuoteNode(name)))

	# @par(x, y)
	else
		return Expr(:(=), 
			esc(Expr(:ref, :__new_parameter, QuoteNode(name))), esc(value[1]))
	end
end

# add a new level of parameter sweeps, forwards to add_level 
macro level(index, par)
	if par.head != :block
		error("@level expects a block (begin...end)!")
	end

	if index == ()
		error("@level needs index variable name!")
	end

	range = ()
	code = Expr(:block)
	# check all lines in the block
	for line in par.args
		# check macro calls
		# but only @range is filtered out
		if isa(line, Expr) && line.head == :macrocall &&
			line.args[1] == symbol("@range")
				range = line.args[2]
		# everything else goes into the code block
		else
			push!(code.args, line)
		end
	end

	esc(quote
		add_level(get_simulation(__simulation), $(QuoteNode(index)), $(range)) do __parameter
			__new_parameter = Parameter()
			$(code)
			__new_parameter
		end
	end)
end

# set filter function at level name
function set_filter(filt::Function, sim::Simulation, name::Symbol)
	i = 1
	for gen in sim.geners
		if gen.name == name
			gen.filter = filt
		end
		i += 1
	end
end

# set last filter function (usually used by run)
function set_receiver(filt::Function, sim::Simulation)
	sim.geners[end].filter = filt
end

# create a keyword argument expression object
function make_kw_arg(name, val)
	Expr(:kw, name, val...)
end

# Make name a (global) macro that map into a keyword argument expression 
# using the same name as keyword. The macro's argument has to be symbol.
macro keyword_symbol(name)
	res = quote
		macro $name(x)
			esc(make_kw_arg($(QuoteNode(name)), (QuoteNode(x), )))
		end
	end

	push!(res.args, Expr(:export, symbol("@" * string(name))))
	esc(res)
end

# Make name a (global) macro that map into a keyword argument expression 
# using the same name as keyword. The macro takes a single argument.
macro keyword_single(name)
	res = quote
		macro $name(x)
			esc(make_kw_arg($(QuoteNode(name)), (x, )))
		end
	end

	push!(res.args, Expr(:export, symbol("@" * string(name))))
	esc(res)
end

function print_with_header(sim::Simulation, level::Symbol, out_key::Symbol, vars...)
	if level == :nil
		return
	end

	list, header = list_header(vars)

	set_filter(sim, level) do par::Parameter
		with_key(par, out_key) do out
			println(out, gen_par_line(list, par))
		end

		par
	end

	header
end

# Call function func, giving macro calls as arguments. @par values are 
# given as tuples, all other macros are pasted into the argument list 
# verbatim and thus have to be predefined.
# TODO: update docs
macro set(func, par)
	if isa(par, Symbol)
		return esc(Expr(:call, func, :__simulation, QuoteNode(par)))
	end
	if isa(par, Expr) && par.head != :block
		return esc(Expr(:call, func, :__simulation, par))
	end
	if !isa(par, Expr)
		error("@set expects a block, a symbol or an expression!")
	end

	# function call, __simulation has to be first argument
	res = Expr(:call, func, :__simulation)

	for line in par.args
		if isa(line, Expr) && line.head == :macrocall 
			if line.args[1] == symbol("@par")
				if length(line.args) == 2
					push!(res.args, QuoteNode(line.args[2]))
				else
					push!(res.args, 
						:( tuple($(QuoteNode(line.args[2])), $(line.args[3])...) ))
				end
			else
				push!(res.args, line)
			end
		end
	end

	esc(res)
end

# Sweep recursively through all parameter levels calling generators and 
# filters as set.
function generate(sim::Simulation)
	generator = sim.geners[1]
	param = sim.setup
	range = generator.range
	# if no range was provided we assume it's in param
	if range == () && haskey(param, generator.name)
		range = param[generator.name]
	end

	if isa(range, Integer)
		range = 1:range
	end

	for sub in range
		# make current index available
		param[generator.name] = sub
		# get the patch
		patch = generator.map(param)
		# apply it and send it through the filter
		param_new = generator.filter(merge(param, patch))
		# not done yet, go one level down
		if length(sim.geners) > 1
			generate(Simulation(param_new, sim.geners[2:end]))
		end
	end
end

# if par has key name call fun on it (with value as 1st arg)
# return true if name was found, false otherwise
function with_key(fun::Function, par::Parameter, name::Symbol)
	if haskey(par, name)
		fun(par[name])
		true
	else
		false
	end
end

# apply fun to all values corresponding to keys in names
function for_subset{T}(fun::Function, par::Parameter, names::T)
	for name in names
		fun(par[name])
	end
end

# join all values corresponding to keys in names in a string separated by sep
function gen_par_line{NL}(names::NL, par::Parameter, sep::String = " ")
	line = ""
	for_subset(par, names) do p
		line = line * join(p, sep) * sep
	end
	line
end

function required(par::Parameter, key::Symbol, msg)
	if !haskey(par, key)
		error(msg)
	end
end

end	# SimGenerator

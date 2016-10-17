module SimUtils

export list_header

splatable{T}(x::T) = x
splatable(x::Symbol) = (x,)

function symb_header(sep::String, s::Symbol)
#	println(STDERR, "S")
	s, "$s$sep"
end

function symb_header(sep::String, s::Symbol, n::Int)
#	println(STDERR, "I")
	h = ""
	for i in 1:n
		h *= "$s$i$sep"
	end
	s, h
end

function symb_header(sep::String, s::Symbol, l...)
#	println(STDERR, "T")
#	println(STDERR, "\t$s")
#	println(STDERR, "\t$(typeof(l))")

	s, join(l, sep) * sep
end

function list_header(vars, sep = " ")
#	println(STDERR, typeof(vars))
	header = ""
	list = Symbol[]
	for var in vars
#		println(STDERR, typeof(var))
		s,h = isa(var, Symbol) ? symb_header(sep, var) : symb_header(sep, var...)
		header *= h
		push!(list, s)
	end

	list, header
end

end	# SimUtils

using GZip

function run(inp; nloc=1, out="res.txt.gz", minn=1, maxx=4, thres=1)

#	println("parameter values (min, max and threshold):")
#	println(minn)
#	println(maxx)
#	println(thres)

	f = open(inp, "r")
	res = GZip.gzopen(out, "w")

	i = 1	# locus number
	bad = 0	# number of bad loci
	simID = 1	# dataset ID
	GZip.write(res, "Simulation ID\n")
	for l in eachline(f)
		l = strip(l, '\n')
		elem = split(l, ' ')
		ss = int(elem[2])
	
		# test if bad number segsites
		if (ss < minn || ss > maxx)
			bad += 1
		end
	
		# when we reach the last locus of a dataset, test threshold
		if (i == nloc)
			if (bad >= thres)
				GZip.write(res, "full_interspeMig.jobID.taskID." * string(simID), "\n")
			end
			# then re-initialize and increment
			i = 0
			bad = 0
			simID += 1
		end
		i += 1
	end
	close(f)
	GZip.close(res)
end

#### run script
inp = "N_segsites_suff.txt"	# ARGS[1]
out = "Badsimul_thres" * string(thres) * ".txt.gz"	# ARGS[2]
thres = 12	# int(ARGS[3])
nloc = 20	# int(ARGS[4])
mini = 1	# int(ARGS[5])
maxi = 3	# int(ARGS[6])
run(inp, nloc=nloc, out=out, minn=mini, maxx=maxi, thres=thres)


fasta2ms.jl
util.jl

Convert a number of fasta files into an ms-like data file (plus assorted 
config files). Run like this:

./fasta2ms.jl converted -p L.corn.,L.ped.,Medicago,Pisum,Trifolium,Cytisus -o Lathyrus,Ononis res/*.fasta

In this case 'converted' denotes a file name prefix to use for all generated
files. -p ... gives a list of population names that are to be considered
ingroup while -o lists the outgroups (note that in both cases index ranges can
be used together with or instead of population names, e.g. Pisum,1-4). The rest
of the commandline is interpreted as a list of fasta file names.

For each fasta file the following algorithm is executed:

determine outgroup sequence
	for each site and each pop find the majority allele
	if it doesn't exist or majority alleles differ between populations
		pick one of the two alleles at random
	if any haplotype has an 'N' or a '-' at a given site
		that site is marked as 'N' in the outgroup sequence

generate ms sequence
	find segregating sites, i.e. sites that
		vary between haplotypes
		do not have 'N' in the population
		do not have 'N' in the outgroup
	for each segregating site and each haplotype set ms seq as 
		0 if equal outgroup
		1 otherwise

The script prints an ms-like file (including positions of segregating sites) in
*.ms, an spinput file in *.spi, a stats file (containing for each locus number
of undetermined and overall number of non-N sites in the OG seq) in *.stats and
a mask file (to be read by msums) in *.mask.

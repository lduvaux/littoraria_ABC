#################
## import data ##
#################

# remove all objects
rm(list = ls())

# import data
Littoraria_data <- read.table(file = "<PATH>/genotype.finally.result", h = T, fill = T)

# name rows
tag_names <- Littoraria_data[, 1]
Littoraria_data <- Littoraria_data[, -1]
rownames(Littoraria_data) <- tag_names
rm(tag_names)

# name SNP columns
names(Littoraria_data)[116:119] <- paste("SNP", 1:4, sep = "_")

# print number of tags at this stage
nrow(Littoraria_data)
# result: 767,685 tags

########################################################
## tag filter: tags with >= 5 individuals in each pop ##
########################################################

# split data into populations
cin_sym <- Littoraria_data[, c(grep("CBr", names(Littoraria_data)), grep("CPo", names(Littoraria_data)))]
cin_allo <- Littoraria_data[, c(grep("CDe", names(Littoraria_data)), grep("CMo", names(Littoraria_data)))]
fil_sym <- Littoraria_data[, c(grep("FBr", names(Littoraria_data)), grep("FPo", names(Littoraria_data)))]
fil_allo <- Littoraria_data[, c(grep("FDa", names(Littoraria_data)), grep("FDu", names(Littoraria_data)))]

# calculate number of individuals typed for each tag in each population
ind_typed_per_tag_cin_sym <- apply(cin_sym, 1, function(x){sum(!x == "-")})
ind_typed_per_tag_cin_allo <- apply(cin_allo, 1, function(x){sum(!x == "-")})
ind_typed_per_tag_fil_sym <- apply(fil_sym, 1, function(x){sum(!x == "-")})
ind_typed_per_tag_fil_allo <- apply(fil_allo, 1, function(x){sum(!x == "-")})
rm(cin_sym, cin_allo, fil_sym, fil_allo)

# retain tags with >= 5 invididuals typed in each population
Littoraria_data <- Littoraria_data[
	ind_typed_per_tag_cin_sym >= 5 &
	ind_typed_per_tag_cin_allo >= 5 &
	ind_typed_per_tag_fil_sym >= 5 &
	ind_typed_per_tag_fil_allo >= 5, ]
rm(	ind_typed_per_tag_cin_sym,
		ind_typed_per_tag_cin_allo,
		ind_typed_per_tag_fil_sym,
		ind_typed_per_tag_fil_allo)

# print number of tags at this stage
nrow(Littoraria_data)
# result: 50,380 tags

######################
## haplotype filter ##
######################

# write function to filter haplotypes
haplotype_filter <- function(x){
	x <- as.character(x)
	if(x == "-"){return(NA)}
	else{
		haplotype_reads <- unlist(strsplit(x, "[|]"))
		haplotypes <- as.numeric(unlist(strsplit(haplotype_reads[1], ",")))
		reads <- as.numeric(unlist(strsplit(haplotype_reads[2], ",")))
	}
	if(length(haplotypes) == 1){
		if(reads == 1){NA}
		else{haplotypes}
	}
	else{
		if(all(reads == 1)){NA}
		else{
			if(reads[1] == 1){haplotypes[2]}
			else{
				if(reads[2] == 1){haplotypes[1]}
				else{sample(haplotypes, 1)}
			}
		}
	}
}

# filter haplotypes
filtered_haplotypes <- apply(Littoraria_data[, 1:113], c(1, 2), haplotype_filter)
rm(haplotype_filter)

# rejoin filtered haplotypes and polymorphism details
Littoraria_data <- cbind(filtered_haplotypes, Littoraria_data[, 114:119])
rm(filtered_haplotypes)

########################################################
## tag filter: tags with >= 5 individuals in each pop ##
########################################################

# split data into populations
cin_sym <- Littoraria_data[, c(grep("CBr", names(Littoraria_data)), grep("CPo", names(Littoraria_data)))]
cin_allo <- Littoraria_data[, c(grep("CDe", names(Littoraria_data)), grep("CMo", names(Littoraria_data)))]
fil_sym <- Littoraria_data[, c(grep("FBr", names(Littoraria_data)), grep("FPo", names(Littoraria_data)))]
fil_allo <- Littoraria_data[, c(grep("FDa", names(Littoraria_data)), grep("FDu", names(Littoraria_data)))]

# calculate number of individuals typed for each tag in each population
ind_typed_per_tag_cin_sym <- apply(cin_sym, 1, function(x){sum(!is.na(x))})
ind_typed_per_tag_cin_allo <- apply(cin_allo, 1, function(x){sum(!is.na(x))})
ind_typed_per_tag_fil_sym <- apply(fil_sym, 1, function(x){sum(!is.na(x))})
ind_typed_per_tag_fil_allo <- apply(fil_allo, 1, function(x){sum(!is.na(x))})
rm(cin_sym, cin_allo, fil_sym, fil_allo)

# retain tags with >= 5 invididuals typed in each population
Littoraria_data <- Littoraria_data[
	ind_typed_per_tag_cin_sym >= 5 &
	ind_typed_per_tag_cin_allo >= 5 &
	ind_typed_per_tag_fil_sym >= 5 &
	ind_typed_per_tag_fil_allo >= 5, ]
rm(	ind_typed_per_tag_cin_sym,
		ind_typed_per_tag_cin_allo,
		ind_typed_per_tag_fil_sym,
		ind_typed_per_tag_fil_allo)

# print number of tags at this stage
nrow(Littoraria_data)
# result: 37,556 tags

###########################################################
## tag filter: tags with all SNPs having only two states ##
###########################################################

# write function to count number of states in a SNP
states_per_SNP_cal <- function(x){
	if(!is.na(x)){length(unique(unlist(strsplit(unlist(strsplit(as.character(x), "[|]"))[2], ","))))}
	else{NA}
}

# count number of states in a SNP
states_per_SNP <- as.data.frame(apply(Littoraria_data[, 116:119], c(1, 2), states_per_SNP_cal))
rm(states_per_SNP_cal)

# print number of tags where any SNP has more than two states
sum(apply(states_per_SNP, 1, function(x){any(x[!is.na(x)] == 3) | any(x[!is.na(x)] == 4)}))
# result: 2401 tags

# identify tags where all SNPs have two states
tags_SNP_2states <- apply(states_per_SNP, 1, function(x){all(x[!is.na(x)] <= 2) & any(x[!is.na(x)] != 1)})
rm(states_per_SNP)

# retain tags with all SNPs having only two states
Littoraria_data <- Littoraria_data[tags_SNP_2states, ]
rm(tags_SNP_2states)

# print number of tags at this stage
nrow(Littoraria_data)
# result: 35,155 tags

############################################
## retain five individuals per population ##
############################################

# split the data into populations
cin_sym <- Littoraria_data[, c(grep("CBr", names(Littoraria_data)), grep("CPo", names(Littoraria_data)))]
cin_allo <- Littoraria_data[, c(grep("CDe", names(Littoraria_data)), grep("CMo", names(Littoraria_data)))]
fil_sym <- Littoraria_data[, c(grep("FBr", names(Littoraria_data)), grep("FPo", names(Littoraria_data)))]
fil_allo <- Littoraria_data[, c(grep("FDa", names(Littoraria_data)), grep("FDu", names(Littoraria_data)))]

# randomly retain five individuals per population
for(i in 1:nrow(cin_sym)){cin_sym[i, -(sample(which(!is.na(cin_sym[i, ])), 5))] <- NA}
for(i in 1:nrow(cin_allo)){cin_allo[i, -(sample(which(!is.na(cin_allo[i, ])), 5))] <- NA}
for(i in 1:nrow(fil_sym)){fil_sym[i, -(sample(which(!is.na(fil_sym[i, ])), 5))] <- NA}
for(i in 1:nrow(fil_allo)){fil_allo[i, -(sample(which(!is.na(fil_allo[i, ])), 5))] <- NA}

# gather the data
Littoraria_data <- cbind(cin_sym, cin_allo, fil_sym, fil_allo, Littoraria_data[, 114:119])
rm(cin_sym, cin_allo, fil_sym, fil_allo)

#####################################################
## retain information of remaining haplotypes only ##
#####################################################

# write function to obtain numbers of retained haplotypes
hap_num_cal <- function(x){
	hap_num_original <- as.numeric(unlist(strsplit(as.character(Littoraria_data[x, 114]), ",")))
	hap_num_filtered <- unique(as.numeric(Littoraria_data[x, 1:113]))[!is.na(unique(as.numeric(Littoraria_data[x, 1:113])))]
	paste(intersect(hap_num_original, hap_num_filtered), collapse = ",")
}

# obtain numbers of retained haplotypes
Littoraria_data$Filtered_polymorphism_types <- sapply(1:nrow(Littoraria_data), hap_num_cal)
rm(hap_num_cal)

# write function to keep information of retained haplotypes only
polymorphism_detail_filter <- function(x){
	x <- as.matrix(x)
	filtered_polymorphisms_types <- as.numeric(unlist(strsplit(x[5], ",")))
	temp <- vector("list", 4)
	for(i in 1:4){
		if(x[i] == ""){myresult <- NA}
		else{
			position_haplotypes <- unlist(strsplit(as.character(x[i]), "[|]"))
			position <- position_haplotypes[1]
			haplotypes <- unlist(strsplit(position_haplotypes[2], ","))[filtered_polymorphisms_types]
			position_haplotypes <- paste(position, paste(haplotypes, collapse = ","), sep = "|")
			myresult <- position_haplotypes
		}
		temp[[i]] <- myresult
	}
	temp
}

# keep information of retained haplotypes only
polymorphism_detail_filtered <- as.data.frame(matrix(unlist(apply(Littoraria_data[, 116:120], 1, polymorphism_detail_filter)), ncol=4, byrow=T))
rm(polymorphism_detail_filter)

# gather data as in the original layout
names(polymorphism_detail_filtered) <- names(Littoraria_data)[116:119]
rownames(polymorphism_detail_filtered) <- rownames(Littoraria_data)
temp_data <- cbind(Littoraria_data[, 1:113], Littoraria_data[, 120], Littoraria_data[, 115], polymorphism_detail_filtered)
rm(polymorphism_detail_filtered)
names(temp_data) <- names(Littoraria_data)[1:119]
Littoraria_data <- temp_data
rm(temp_data)

###########################################################
## tag filter: tags with all SNPs having only two states ##
###########################################################

# write function to count number of states in a SNP
states_per_SNP_cal <- function(x){
	if(!is.na(x)){length(unique(unlist(strsplit(unlist(strsplit(as.character(x), "[|]"))[2], ","))))}
	else{NA}
}

# count number of states in a SNP
states_per_SNP <- as.data.frame(apply(Littoraria_data[, 116:119], c(1, 2), states_per_SNP_cal))
rm(states_per_SNP_cal)

# count tags that turned monomorphic
sum(apply(states_per_SNP, 1, function(x){all(x[!is.na(x)] == 1)}))
# result: 5532 tags

# identify tags where all SNPs have two states
tags_SNP_2states <- apply(states_per_SNP, 1, function(x){all(x[!is.na(x)] <= 2) & any(x[!is.na(x)] !=1 )})
rm(states_per_SNP)

# retain tags with all SNPs having only two states
Littoraria_data <- Littoraria_data[tags_SNP_2states, ]
rm(tags_SNP_2states)

# print number of tags at this stage
nrow(Littoraria_data)
# result: 29,623 tags

##################################################
## retain polymorphic positions only, i.e. SNPs ##
##################################################

# write function to count number of states in a SNP
states_per_SNP_cal <- function(x){
	if(!is.na(x)){length(unique(unlist(strsplit(unlist(strsplit(as.character(x), "[|]"))[2], ","))))}
	else{NA}
}

# count number of states in a SNP
states_per_SNP <- as.data.frame(apply(Littoraria_data[, 116:119], c(1, 2), states_per_SNP_cal))
names(states_per_SNP) <- paste("states_SNP", seq(1, 4, 1), sep = "")
rm(states_per_SNP_cal)

# retain polymorphic positions only, i.e. SNPs
Littoraria_data[, 116:119][states_per_SNP == 1] <- NA
rm(states_per_SNP)

################################################################
## replace hap numbers with continuous integers starting at 1 ##
################################################################

# subset data to keep only haplotypes for each individual and tag
m <- as.matrix(Littoraria_data[, 1:113])

# replace haplotype numbers for continuous integers starting at 1
for(i in 1:nrow(m)){
	haps <- length(unique(m[i, ]))
	for(j in 1:haps){
		m[i, ][m[i, ] == sort(unique(m[i, ]))[j]] <- j
	}
}
rm(i, haps, j)





##############################################
##############################################

# for each tag, retain only the kept sequences
sequences_to_retain <- function(x){
	paste(unlist(strsplit(as.character(x[2]), ","))[as.numeric(unlist(strsplit(as.character(x[1]), ",")))], collapse = ",")
}
retained_sequences <- apply(Littoraria_data[, 114:115], 1, sequences_to_retain)
Littoraria_data <- cbind(Littoraria_data[, 1:114], retained_sequences, Littoraria_data[, 116:119])
rm(sequences_to_retain, retained_sequences)

##############################################
##############################################





# summarise haplotype numbers for each tag into a single element
Polymor_types <- apply(m, 1, function(x){paste(sort(unique(x)), collapse = ",")})

# gather data as in the original layout
Littoraria_data <- cbind(m, Polymor_types, Littoraria_data[, 115:119])
rm(m, Polymor_types)

# save data as it is at this stage
save(Littoraria_data, file = "<PATH>/Littoraria_data")
load(file = "<PATH>/Littoraria_data")

##################################################
## convert polymorphism detail into binary data ##
##################################################

# write function to convert polymorphism details into binary data
binary_conversion<-function(x){
	x<-as.character(x)
	if(!is.na(x)){
		position_haplotypes<-unlist(strsplit(x,"[|]"))
		position<-as.numeric(position_haplotypes[1])
		haplotypes<-unlist(strsplit(position_haplotypes[2],","))
		ancestral<-haplotypes[1]
		haplotypes[haplotypes==ancestral]<-0
		haplotypes[haplotypes!=0]<-1
		haplotypes<-paste(haplotypes,collapse=",")
		position_haplotypes<-paste(position,haplotypes,sep="|",collapse="")
		position_haplotypes
	}
	else{NA}
}

# convert polymorphism details into binary data
binary_polymorphisms<-as.data.frame(apply(as.data.frame(apply(Littoraria_data[,116:119],c(1,2),binary_conversion)),c(1,2),as.character))
rm(binary_conversion)

#########################################
## assemble possible binary haplotypes ##
#########################################

# write function to assemble possible binary haplotypes for EACH tag
haplotype_assembly_each<-function(seg1,seg2,seg3,seg4){
	seg1<-as.character(seg1)
	seg2<-as.character(seg2)
	seg3<-as.character(seg3)
	seg4<-as.character(seg4)
	if(!is.na(seg1)){seg1<-unlist(strsplit(strsplit(seg1,"[|]")[[1]][2],","))}
	if(!is.na(seg2)){seg2<-unlist(strsplit(strsplit(seg2,"[|]")[[1]][2],","))}
	if(!is.na(seg3)){seg3<-unlist(strsplit(strsplit(seg3,"[|]")[[1]][2],","))}
	if(!is.na(seg4)){seg4<-unlist(strsplit(strsplit(seg4,"[|]")[[1]][2],","))}
	haplotypes<-as.matrix(data.frame(seg1,seg2,seg3,seg4))
	hap_list<-vector("list",nrow(haplotypes))
	for(i in 1:nrow(haplotypes)){
		hap_list[[i]]<-paste(haplotypes[i,][!is.na(haplotypes[i,])],collapse="")	
	}
	unlist(hap_list)
}

# assemble possible binary haplotypes for ALL tags
possible_haplotypes<-vector("list",nrow(binary_polymorphisms))
for(i in 1:nrow(binary_polymorphisms)){
	possible_haplotypes[[i]]<-haplotype_assembly_each(binary_polymorphisms[i,1], binary_polymorphisms[i,2], binary_polymorphisms[i,3], binary_polymorphisms[i,4])
}
rm(binary_polymorphisms,haplotype_assembly_each,i)

##############################################################
## bind info on filtered haplotypes and possible haplotypes ##
##############################################################

# convert possible haplotypes from list into dataframe
possible_haplotypes<-do.call(rbind.data.frame,possible_haplotypes)
colnames(possible_haplotypes)<-paste("hap_",1:ncol(possible_haplotypes))
rownames(possible_haplotypes)<-rownames(Littoraria_data)

# bind filtered haplotypes and possible haplotypes
filtered_haplotypes<-cbind(Littoraria_data[,1:113],possible_haplotypes)
rm(possible_haplotypes)

#####################################
## calculate positions of segsites ##
#####################################

# write function to extract positions of segsites
segsite_position_extraction<-function(x){
	x<-as.character(x)
	if(!is.na(x)){
		position_haplotypes<-unlist(strsplit(x,"[|]"))
		position<-as.numeric(position_haplotypes[1])
		position
	}
	else{NA}
}

# extract positions of segsites
segsite_positions<-as.data.frame(apply(as.data.frame(apply(Littoraria_data[,116:119],c(1,2),segsite_position_extraction)),c(1,2),as.character))
rm(Littoraria_data,segsite_position_extraction)

# write function to assemble positions of segsites for each tag
segsite_position_calculator<-function(x){
	x<-as.numeric(as.character(as.matrix(x)))
	seg1<-round(x[1]/82,4)
	seg2<-round(x[2]/82,4)
	seg3<-round(x[3]/82,4)
	seg4<-round(x[4]/82,4)
	positions<-c(seg1,seg2,seg3,seg4)
	positions[!is.na(positions)]
}

# assemble positions of segsites for each tag
segsite_positions<-t(apply(segsite_positions,1,segsite_position_calculator))
rm(segsite_position_calculator)

##################################################################
## assign binary haplotypes to individuals and generate ms file ##
##################################################################

# write function to replace haplotype number with binary haplotype for EACH tag
haplotype_replacement<-function(x){
	individuals<-x[1:113]
	haplotype_number<-max(individuals,na.rm=T)
	haplotypes<-x[114:length(x)][1:haplotype_number]
	replacement<-function(h){
		if(is.na(h)){return(NA)}
		else{for(i in 1:haplotype_number){if(h==i){return(haplotypes[i])}}}
	}
	binary_haplotypes<-matrix(as.character(as.matrix(as.data.frame(sapply(individuals,replacement)))))
	binary_haplotypes<-as.data.frame(binary_haplotypes)
	rownames(binary_haplotypes)<-colnames(x)[1:113]
	colnames(binary_haplotypes)<-rownames(x)
	na.omit(binary_haplotypes)
}

# replace haplotype number with binary haplotype for ALL tags and generate ms file
for(i in 1:nrow(filtered_haplotypes)){
	replaced_haplotypes<-haplotype_replacement(filtered_haplotypes[i,])
	segsites_number<-nchar(as.character(replaced_haplotypes[1,1]))
	segsites_positions<-paste(segsite_positions[[i]],collapse=" ")
	dummy_line<-data.frame(paste("\n","//\n","segsites: ",segsites_number,"\npositions: ",segsites_positions,sep=""))
	colnames(dummy_line)<-colnames(replaced_haplotypes)
	replaced_haplotypes<-rbind(dummy_line,replaced_haplotypes)
	write.table(replaced_haplotypes,file="<PATH>/Littoraria_ms.txt",append=T,quote=F,row.names=F,col.names=F)
}
rm(dummy_line,haplotype_replacement,i,replaced_haplotypes,segsites_positions,segsites_number)

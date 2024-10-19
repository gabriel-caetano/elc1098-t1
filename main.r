library('jsonlite')
library('arules')

json <- fromJSON('padaria_trab.json')

types <- unique(sapply(unlist(json[2]), function(x) strsplit(x, " ")[[1]][1]))


mat <- matrix(0, nrow = nrow(json), ncol = length(types))

colnames(mat) <- types

for (i in 1:nrow(json)) {
    produtos <- json$produtos[[i]]
    prod_types <- unique(sapply(produtos, function(x) strsplit(x, " ")[[1]][1]))
    mat[i,prod_types] <- 1
}

rules = apriori(mat, parameter = list(supp = 0.17, conf = 0.4, minlen = 2))

# filtered = subset(rules, lhs %pin% "Queijo")
# inspect(filtered)
inspect(rules)

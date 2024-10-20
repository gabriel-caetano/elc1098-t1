library('jsonlite')
library('arules')

json <- fromJSON('padaria_trab.json')

# limpeza
list_of_products = unique(unlist(json[2]))
get_first_word <- function(x) strsplit(x, " ")[[1]][1]
types <- unique(sapply(list_of_products, get_first_word))

# transformação
mat <- matrix(0, nrow = nrow(json), ncol = length(types))
colnames(mat) <- types
for (i in 1:nrow(json)) {
    produtos <- json$produtos[[i]]
    prod_types <- unique(sapply(produtos, get_first_word))
    mat[i,prod_types] <- 1
}

# principais regras
rules = apriori(mat, parameter = list(supp = 0.2, conf = 0.4, minlen = 2))
inspect(rules)

# regras que implicam em doces
rules = apriori(mat, parameter = list(supp = 0.1, conf = 0.2, minlen = 2))
filtered = subset(rules, rhs %in% "Doce")
inspect(filtered)
library('jsonlite')
library('arules')

json <- fromJSON('padaria_trab.json')

# limpeza
products = unique(unlist(unique(json[2])))

get_first_word <- function(x) strsplit(x, " ")[[1]][1]
types <- unique(sapply(products, get_first_word))


# transformação
mat_p <- matrix(0, nrow = nrow(json), ncol = length(products))
colnames(mat_p) <- products
for (i in 1:nrow(json)) {
    p <- json$produtos[[i]]
    # prod_types <- unique(sapply(produtos, get_first_word))
    mat_p[i,p] <- 1
}

mat_t <- matrix(0, nrow = nrow(json), ncol = length(types))
colnames(mat_t) <- types
for (i in 1:nrow(json)) {
    p <- json$produtos[[i]]
    pt <- unique(sapply(p, get_first_word))
    mat_t[i,pt] <- 1
}

# mineração
# principais regras
rules_p = apriori(mat_p, parameter = list(supp = 0.06, conf = 0.1, minlen = 2))
inspect(rules_p)
rules_t = apriori(mat_t, parameter = list(supp = 0.2, conf = 0.4, minlen = 2))
inspect(rules_t)


# regras que implicam em doces
rules_p = apriori(mat_p, parameter = list(supp = 0.03, conf = 0.05, minlen = 2))
filtered = subset(rules_p, rhs %in% "Doce Goiabada" | rhs %in% "Doce Leite" | rhs %in% "Doce Amendoim")
inspect(filtered)

rules_t = apriori(mat_t, parameter = list(supp = 0.1, conf = 0.2, minlen = 2))
filtered = subset(rules_t, rhs %in% "Doce")
inspect(filtered)
# Mineraração de dados em um conjunto de transações de uma padaria

## Detalhes
Universidade Federal de Santa Maria (UFSM)\
Centro de Tecnologia (CT)\
Disciplina de Mineração de dados (ELC1098)\
Professor Dr. Joaquim Assunção\
Autores: Bruno Perussatto & Gabriel Vinicius Schmitt Caetano\
Trabalho prático 1\
peso: 6

Descrição:\
Uma padaria resolveu extrair dados de compra do seu sistema e verificar quais produtos
vendem mais em associação com outros produtos. A padaria vende variações dos seguintes
produtos: "Café", "Pão", "Presunto", "Queijo", "Pastel", "Doce", "Refri". A ideia é ver quais
produtos tendem a serem vendidos juntos.\
Abra o arquivo (padaria_trab.json). Este arquivo é composto por transações que contém os
produtos. Faça o devido pré-processamento antes de extrair as regras.\
Extraia as 5 principais regras e diga qual o produto mais influente 1 para 1 (i.e, prodA =>
prodB). Posteriormente, encontre a regra dos produtos que implicam compra de “doce” (e.g.,
“=> {Doce}”).

Obs: calibre o suporte e a confiança até obter os resultados desejados.

Dica: Em R, use o pacote “jsonlite” para abrir seu arquivo.

## Entrega
Um documento contendo um resumo do que foi feito como pré-processamento (1 a 3 páginas),
as respostas, e as regras que suportam as respostas. Em anexo deve estar seu script para
transformação dos dados e geração das regras (caso haja). O envio deve ser por e-mail, com o
título do PDF contendo o nome dos membros no seguinte formato “[DM] alunoA, alunoB”.

## Avaliação
A avaliação será dada de acordo com o PDF entregue, contendo a descrição do processo e as
regras geradas com suas respectivas métricas. Caso seja feito por ferramentas externas (e.g.,
WEKA), o documento deve ser maior, contendo cada passo realizado.

## Prazo
O trabalho deve ser entregue por e-mail até dia 29/out às 18:00h 

# Etapas do processo
## Seleção
Partimos da premissa que já recebemos os dados corretamente selecionados e ignoramos esta etapa.

## Pré-processamento
Para o pré processamento, apenas uma pequena correção manual no arquivo e a limpeza dos dados foram necessários para o objetivo do trabalho

Usando um formatador json identificamos e corrigimos um erro na gramática do arquivo adicionando uma vírgula no final da linha 737\
Carregamos o arquivo json com a lib jsonlite para o script R \
`json <- fromJSON('padaria_trab.json')`

### Limpeza dos dados (cleaning)
Para a limpeza dos dados executamos um script para filtrar os produtos e obter a lista de tipos únicos
("Café", "Pão", "Presunto", "Queijo", "Pastel", "Doce", "Refri") da lista de compras
```
list_of_products = unique(unlist(json[2]))
get_first_word <- function(x) strsplit(x, " ")[[1]][1]
types <- unique(sapply(list_of_products, get_first_word))
```
Em resumo o script lista todos os produtos únicos da lista de transações, aplica uma função para extrair apenas a primeira palavra (que identifica o tipo do produto), e aplica novamente um filtro unique para manter apenas um elemento de cada tipo.\
Identificando assim todos os tipos de produtos existentes no arquivo lido.

## Transformação
Considerando que usaremos o algoritmo a priori para encontrar as regras de associação, transformaremos a lista de transações em uma matriz transação x produto.\
Para isso criamos uma matriz contendo o número de transações em linhas e o número de tipos de produtos como colunas totalmente preenchida com zeros\
`mat <- matrix(0, nrow = nrow(json), ncol = length(types))`

Definimos o nome das colunas conforme os tipos identificados\
`colnames(mat) <- types`

E então preenchemos a matriz com os valores conforme as transações do arquivo importado.
Para cada transação, as colunas dos produtos comprados recebem o valor 1, os demais são mantidos como 0 conforme definido na criação da matriz
```
for (i in 1:nrow(json)) {
    produtos <- json$produtos[[i]]
    prod_types <- unique(sapply(produtos, get_first_word))
    mat[i,prod_types] <- 1
}
```
Assim obtemos uma matriz de\
**[quantidade de compras] linhas x [quantidade de tipos de produtos] colunas**\
com valores `0` ou `1`, que permitirá a aplicação do algoritmo _apriori_

## Mineração de dados
Nessa etapa usamos o algoritmo apriori com o parâmetro minlen = 2 para ignorar associações entre conjuntos vazios e ajustando os parâmetros de suporte e confiança para encontrar os resultados esperados.\
Após alguns testes chegamos aos seguintes resultados:

`rules = apriori(mat, parameter = list(supp = 0.2, conf = 0.4, minlen = 2))`\
Usando os parâmetros:\
supp = 0.2\
conf = 0.4\
minlen = 2 (para eliminar associações de ausência de compra)

encontramos apenas 6 regras válidas

    lhs           rhs        support   confidence coverage  lift     count
    {Presunto} => {Pão}      0.2520325 0.5849057  0.4308943 1.284704 31
    {Pão}      => {Presunto} 0.2520325 0.5535714  0.4552846 1.284704 31   
    {Presunto} => {Queijo}   0.2439024 0.5660377  0.4308943 1.141355 30
    {Queijo}   => {Presunto} 0.2439024 0.4918033  0.4959350 1.141355 30
    {Pão}      => {Queijo}   0.2845528 0.6250000  0.4552846 1.260246 35
    {Queijo}   => {Pão}      0.2845528 0.5737705  0.4959350 1.260246 35

dessa forma identificamos que as 5 principais regras deste conjunto são

1. quem compra pão tem grande chance de comprar queijo
   - confiança = 0.625
   - suporte = 0.2845528
   - cobertura = 0.4552846
   - lift = 1.260246
   - quantidade de ocorrências = 35
2. quem compra queijo tem grande chance de comprar pão
   - confiança = 0.5737705
   - suporte = 0.2845528
   - cobertura = 0.4959350
   - lift = 1.260246
   - quantidade de ocorrências = 35
3. quem compra presunto tem grande chance de comprar pão
   - confiança = 0.5849057
   - suporte = 0.2520325
   - cobertura = 0.4308943
   - lift = 1.284704
   - quantidade de ocorrências = 31
4. quem compra pão tem grande chance de comprar presunto
   - confiança = 0.5535714
   - suporte = 0.2520325
   - cobertura = 0.4552846
   - lift = 1.284704
   - quantidade de ocorrências = 31
1. quem compra presunto tem grande chance de comprar queijo
   - confiança = 0.5660377
   - suporte = 0.2439024
   - cobertura = 0.4308943
   - lift = 1.141355
   - quantidade de ocorrências = 30

E o produto mais influente 1 para 1 é o pão => Queijo, ou seja, quem compra pão tem grandes chances de comprar queijo, com as seguintes métricas:
 - confiança = 0.625
 - suporte = 0.2845528
 - cobertura = 0.4552846
 - lift = 1.260246
 - quantidade de ocorrências = 35 


Para as regras que implicam a compra de doce foram aplicados os seguintes parâmetros\
`rules = apriori(mat, parameter = list(supp = 0.1, conf = 0.2, minlen = 2))`\
supp = 0.1\
conf = 0.2

E filtramos apenas as regras que implicam em doce\
`filtered = subset(rules, rhs %in% "Doce")`\
e chegamos no seguinte resultado

    lhs           rhs    support    confidence coverage  lift      count
    {Café}     => {Doce} 0.1382114  0.3953488  0.3495935 1.0571284 17
    {Refri}    => {Doce} 0.1463415  0.3600000  0.4065041 0.9626087 18   
    {Presunto} => {Doce} 0.1219512  0.2830189  0.4308943 0.7567678 15
    {Pastel}   => {Doce} 0.1626016  0.3389831  0.4796748 0.9064112 20
    {Pão}      => {Doce} 0.1463415  0.3214286  0.4552846 0.8594720 18
    {Queijo}   => {Doce} 0.1463415  0.2950820  0.4959350 0.7890235 18

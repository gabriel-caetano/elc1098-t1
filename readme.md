usando um formatador identificamos e corrigimos um erro na gramática do arquivo adicionando uma vírgula no final da linha 737

carregamos o arquivo json com a lib jsonlite para o script R

executamos um script para filtrar os produtos e obter a lista de tipos únicos
("Café", "Pão", "Presunto", "Queijo", "Pastel", "Doce", "Refri") da lista de compras

definimos uma matriz contendo em cada linha o registro de uma compra e em cada coluna o item comprado
desconsiderando a especificidade do item

preenchemos a matriz com os valores de acordo com o json

executamos o algoritmo apriori com os seguintes parâmetros
supp = 0.17
conf = 0.4
minlen = 2 (para eliminar associações de ausência de compra)

encontramos apenas 6 regras válidas

    lhs           rhs        support   confidence coverage  lift     count
[1] {Pão}      => {Queijo}   0.2845528 0.6250000  0.4552846 1.260246 35
[2] {Queijo}   => {Pão}      0.2845528 0.5737705  0.4959350 1.260246 35
[3] {Presunto} => {Pão}      0.2520325 0.5849057  0.4308943 1.284704 31
[4] {Pão}      => {Presunto} 0.2520325 0.5535714  0.4552846 1.284704 31   
[5] {Presunto} => {Queijo}   0.2439024 0.5660377  0.4308943 1.141355 30
[6] {Queijo}   => {Presunto} 0.2439024 0.4918033  0.4959350 1.141355 30

dessa forma identificamos que as 5 principais regras deste conjunto são

1. quem compra pão tem grande chance de comprar queijo
2. quem compra queijo tem grande chance de comprar pão
3. quem compra presunto tem grande chance de comprar pão
4. quem compra pão tem grande chance de comprar presunto
5. quem compra presunto tem grande chance de comprar queijo
% BASE DE CONOCIMIENTOS

escribio(elsaBornemann, socorro).
escribio(neilGaiman, sandman).
escribio(alanMoore, watchmen).
escribio(brianAzarello, cienBalas).
escribio(warrenEllis, planetary).
escribio(frankMiller, elCaballeroOscuroRegresa).
escribio(frankMiller, batmanAnioUno).
escribio(neilGaiman, americanGods).
escribio(neilGaiman, buenosPresagios).
escribio(terryPratchett, buenosPresagios).
escribio(isaacAsimov, fundacion).
escribio(isaacAsimov, yoRobot).
escribio(isaacAsimov, elFinDeLaEternidad).
escribio(isaacAsimov, laBusquedaDeLosElementos).
escribio(joseHernandez, martinFierro).
escribio(stephenKing, it).
escribio(stephenKing, misery).
escribio(stephenKing, carrie).
escribio(stephenKing, elJuegoDeGerald).
escribio(julioCortazar, rayuela).
escribio(jorgeLuisBorges, ficciones).
escribio(jorgeLuisBorges, elAleph).
escribio(horacioQuiroga, cuentosDeLaSelva).
escribio(horacioQuiroga, cuentosDeLocuraAmorYMuerte).

% Si es cierto que alguien escribió determinada obra.
% Quién/es escribieron una obra.
% Qué obra/s escribió cierta persona.
% Si es cierto que cierta persona escribió alguna obra, sin importar cuál.
% Si es cierto que cierta obra existe.

% Queremos agregar la información de cuáles de las obras son cómics. 
%Por ejemplo, quiero preguntar si sandman es un cómic.

esComic(sandman).
esComic(cienBalas).
esComic(watchmen).
esComic(planetary).
esComic(elCaballeroOscuroRegresa).
esComic(batmanAnioUno).

% Queremos saber si alguien es artista del noveno arte: 
% lo es cuando escribió algún cómic.

/* esArtistaDelNovenoArte(neilGaiman).
esArtistaDelNovenoArte(alanMoore). */

% r <= p ^ q
esArtistaDelNovenoArte(Artista):-
    esComic(Obra),
    escribio(Artista,Obra).

  % Variable: libre.
  % Variable: ligada o unificada.

/*
1. Queremos saber si determinada obra es un best-seller, es decir, si tiene más de 50.000 copias vendidas.
2. Queremos saber si es reincidente un/a autor/a, que es cuando escribió más de una obra.
3.  Queremos saber si conviene contratar a un/a artista, que es cuando es reincidente o escribió un bestseller.
4. Queremos saber si a gus le gusta una obra. A Gus le gusta todo lo que escribió Asimov y sandman.
5. Queremos saber si una obra es rioplatense, que es cuando la nacionalidad de su autor/a es Uruguay o Argentina.
6. Ver si es un libro: cuando fue escrito pero no es cómic
*/

% copiasVendidas(Obra,Cantidad)
copiasVendidas(socorro, 10000).
copiasVendidas(sandman, 20000).
copiasVendidas(watchmen, 30000).
copiasVendidas(cienBalas, 40000).
copiasVendidas(planetary, 50000).
copiasVendidas(elCaballeroOscuroRegresa, 60000).
copiasVendidas(batmanAnioUno, 70000).
copiasVendidas(americanGods, 80000).
copiasVendidas(buenosPresagios, 90000).
copiasVendidas(buenosPresagios, 10000).
copiasVendidas(fundacion, 20000).
copiasVendidas(yoRobot, 30000).
copiasVendidas(elFinDeLaEternidad, 30000).
copiasVendidas(laBusquedaDeLosElementos, 40000).
copiasVendidas(martinFierro, 50000).
copiasVendidas(it, 70000).
copiasVendidas(misery, 70000).
copiasVendidas(carrie, 80000).
copiasVendidas(elJuegoDeGerald, 90000).
copiasVendidas(rayuela, 10000).
copiasVendidas(ficciones, 20000).
copiasVendidas(elAleph, 30000).
copiasVendidas(cuentosDeLaSelva, 40000).
copiasVendidas(cuentosDeLocuraAmorYMuerte, 50000).

esBestSeller(Obra) :-
    copiasVendidas(Obra, Cantidad),
    Cantidad > 50000.

esReincidente(Autor) :-
    escribio(Autor, UnaObra),
    escribio(Autor, OtraObra),
    UnaObra \= OtraObra.

convieneContratar(Artista) :-
    esReincidente(Artista).

convieneContratar(Artista) :-
    escribio(Artista, Obra),
    esBestSeller(Obra).

leGustaAGus(Obra) :-
    escribio(isaacAsimov, Obra).

leGustaAGus(sandman).

esLibro(Obra) :-
    esObra(Obra),
    not(esComic(Obra)).

esObra(Obra) :-
    escribio(_, Obra).

/*5. Queremos saber si una obra es rioplatense, que es cuando la nacionalidad de su autor/a es Uruguay o Argentina. */

nacionalidad(elsaBornemann, argentina).
nacionalidad(jorgeLuisBorges, argentina).
nacionalidad(joseHernandez, argentina).
nacionalidad(julioCortazar, argentina).
nacionalidad(horacioQuiroga, uruguaya).



%esta manera lo hizo yo 
esObraRioplatense(Obra) :-
    escribio(Artista,Obra),
    nacionalidad(Artista,argentina).

esObraRioplatense(Obra) :-
    escribio(Artista,Obra),
    nacionalidad(Artista,uruguaya).

%Es mejor hacerlo para no repetir logica%

esAutorRioPlatense(Autor):-
    nacionalidad(Autor,argentina).

esAutorRioPlatense(Autor):-
    nacionalidad(Autor,uruguaya).

esObraRioplatenseMejor(Obra) :-
    escribio(Autor,Obra),
    esAutorRioPlatense(Autor).


%para todo%
%forall(PARAMETRO1 , PARAMETRO2)%

soloEscribioComics(Autor):-
    escribio(Autor,_), %no hay que ligar la obra por que si no pregunta cada obra antes de entrar%
    %utilizamos escribio antes para cotar el dominio%
    forall(escribio(Autor,Obra),esComic(Obra)). %los forall no ligan, es de orden superior%


%individuos complejos%
%functores de tipo de libro
%esDeTipo
esDeTipo(it, novela(terror, 11)).
esDeTipo(misery, novela(terror, 20)).
esDeTipo(carrie, novela(terror, 30)).
esDeTipo(cuentosDeLaSelva, libroDeCuentos(11)).
esDeTipo(elUniversoEnUnaTabla, cientifico(quimica)).
esDeTipo(elUltimoTeoremaDeFermat, cientifico(matematica)).
esDeTipo(yoRobot, bestSeller(10,253)).
esDeTipo(sandman, fantastica([yelmo, bolsaDeArena, rubi])).

/*
estaBuena(Obra):-
    esDeTipo(Obra,novela(terror, _)).

estaBuena(Obra):-
    esDeTipo(Obra,novela(policial, Capitulos)),
    Capitulos<12.

estaBuena(Obra):-
    esDeTipo(Obra,libroDeCuentos(Capitulos)),
    Capitulos>10.

estaBuena(Obra):-
    esDeTipo(Obra,cientifico(fisicaCuantica)).

estaBuena(Obra):-
    esDeTipo(Obra,bestSeller(PrecioPorPagina,_)),
    PrecioPorPagina < 50.*/

%mejora de no repetir logica de "esDeTipo" y de es "novela"%
/*
estaBuena(Obra):-
    esDeTipo(Obra,Tipo),
    obraBuenaPorTipo(Tipo).

obraBuenaPorTipo(novela(Genero, Capitulos)):-
    novelaBuena(Genero, Capitulos).

novelaBuena(terror,_).

novelaBuena(policial,Capitulos):-
    Capitulos<12.

obraBuenaPorTipo(libroDeCuentos(Capitulos)):-
    Capitulos>10.

obraBuenaPorTipo(bestSeller(PrecioTotal,CantidadDePaginas)):-
    PrecioTotal / CantidadDePaginas < 50.
*/
estaBuena(Obra):-
    esDeTipo(Obra , TipoDeObra),
    tipoDeObraBueno(TipoDeObra).

tipoDeObraBueno(novela(policial , Capitulos)):-
    Capitulos<12.
tipoDeObraBueno(novela(terror , _)).

tipoDeObraBueno(libroDeCuentos(CantidadDeCuentos)):-
    CantidadDeCuentos>10.

tipoDeObraBueno(cientifico(fisicaCuantica)).

tipoDeObraBueno(bestSeller(PrecioPorPagina , _)):-
    PrecioPorPagina<50.


cantidadDePaginas(Obra,Paginas):-
    esDeTipo(Obra , TipoDeObra),
    paginasPorTipo(TipoDeObra,Paginas). %POLIMORFISMO%


paginasPorTipo(novela(_,Capitulos),Paginas):-
    Paginas is (Capitulos * 20).

paginasPorTipo(libroDeCuentos(Cuento),Paginas):-
    Paginas is (Cuento * 5).

paginasPorTipo(cientifico(_),1000).

paginasPorTipo(bestSeller(_ , CantidadDePaginas),CantidadDePaginas).

% "is" liga un valor, es como el "=" pero se usa cuando hay una cuenta del otro lado. Tiene q haber una operacion aritmetica%


tienePuntaje(Autor,Puntaje):-
    cantidadObrasBestSellerQueEscribio(Autor,Cantidad),
    Puntaje is 3 * Cantidad.

escribioBestSeller(Autor,Obra):-
    escribio(Autor,Obra),
    esBestSeller(Obra).

cantidadObrasBestSellerQueEscribio(Autor,Cantidad):-
    obrasBetsellerQueEscribio(Autor,Betsellers),
    %length viene pre definido: length(LISTA,CANTIDAD(De elementos de la lista)).
    length(Betsellers,Cantidad).

obrasBetsellerQueEscribio(Autor,Betsellers):-
    escribio(Autor,_),
    %findall(ELEMENTOS(que guardamos en la lista), CONDICION , LISTA)
    findall(Obra,escribioBestSeller(Autor,Obra),Betsellers).

obrasBetsellerQueLeGustanAGus(Obras) :-
    findall(Obra,leGustaAGusBetseller(Obra),Obras).

leGustaAGusBetseller(Obra):-
    leGustaAGus(Obra),
    esBestSeller(Obra).

%se incorpora un nuevo tipo de obra: frantastica(ElementosMagicos)
%queremos ver si la obra fantastica es copada. esto ocurre cuando uno de sus elementos es un "rubi"
%por ejemplo tenemos: esDeTipo(sandman,fantasia[yelmo,bolsaDeArena,rubi])

tipoDeObraBueno(fantastica(ElementosMagicos)):-
    %member(ELEMENTO,LISTA) funciona como el ELEM
    member(rubi,ElementosMagicos).

promedioDeCopiaVendidas(Autor,Promedio):-
    escribio(Autor,_), 
    findall(Copias,ventasDeUnaObraDeUnAutor(Autor,Copias),ListaDeCopias),
    length(ListaDeCopias,Cantidad),
    %sum_list(LISTA,SUMATORIA) funciona como el SUM
    sum_list(ListaDeCopias, TotalDeCopiasVendidas),    
    Promedio is TotalDeCopiasVendidas / Cantidad.

ventasDeUnaObraDeUnAutor(Autor,Cantidad):-
    escribio(Autor,Obra),
    copiasVendidas(Obra,Cantidad).

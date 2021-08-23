%Base De Conocimiento
%persona(Apodo, Edad, Peculiaridades).
persona(ale, 15, [claustrofobia, cuentasRapidas, amorPorLosPerros]).
persona(agus, 25, [lecturaVeloz, ojoObservador, minuciosidad]).
persona(fran, 30, []).
persona(rolo, 12, []).

%esSalaDe(NombreSala, Empresa).
esSalaDe(elPayasoExorcista, salSiPuedes).
esSalaDe(socorro, salSiPuedes).
esSalaDe(linternas, elLaberintoso).
esSalaDe(guerrasEstelares, escapepepe).
esSalaDe(fundacionDelMulo, escapepepe).

%terrorifica(CantidadDeSustos, EdadMinima).
%familiar(Tematica, CantidadDeHabitaciones).
%enigmatica(Candados).

%sala(Nombre, Experiencia).
sala(elPayasoExorcista, terrorifica(100, 18)).
sala(socorro, terrorifica(20, 12)).
sala(linternas, familiar(comics, 2)).
sala(guerrasEstelares, familiar(futurista, 7)).
sala(fundacionDelMulo, enigmatica([combinacionAlfanumerica, deLlave, deBoton])).

% 1 
nivelDeDificultadDeLaSala(Nombre,Dificultad):-
    sala(Nombre,Experiencia),
    dificultadoPorExperiencia(Experiencia,Dificultad).

dificultadoPorExperiencia(terrorifica(CantidadDeSustos,EdadMinima),Dificultad):-
    Dificultad is CantidadDeSustos - EdadMinima.
dificultadoPorExperiencia(familiar(futurista,_),15).
dificultadoPorExperiencia(familiar(Tematica,CantidadDeHabitaciones),CantidadDeHabitaciones):-
    Tematica \= futurista.
dificultadoPorExperiencia(enigmatica(Candados),Dificultad):-
    length(Candados, Dificultad).
    
% 2
puedeSalir(Persona,Sala):-
    persona(Persona,_,Peculiaridades),
    not(member(claustrofobia,Peculiaridades)),
    nivelDeDificultadDeLaSala(Sala,1).

puedeSalir(Persona,Sala):-
    persona(Persona,Edad,Peculiaridades),
    not(member(claustrofobia,Peculiaridades)),
    Edad > 13,
    nivelDeDificultadDeLaSala(Sala,Dificultad),
    Dificultad < 5.

% 3
tieneSuerte(Persona,Sala):-
    persona(Persona, _, []),
    puedeSalir(Persona,Sala).
%4
esMacabra(Empresa):-
    esSalaDe(_, Empresa),
    forall(esSalaDe(NombreSala, Empresa),sala(NombreSala, terrorifica(_,_))).

%5
empresaCopada(Empresa):-
    esSalaDe(_, Empresa),
    promedioDeDificultad(Empresa,Promedio),
    Promedio < 4,
    not(esMacabra(Empresa)).

promedioDeDificultad(Empresa,Promedio):-
    findall(Dificultad,dificultadDeSalasDeEmpresa(Empresa,Dificultad),Dificultades),
    length(Dificultades, Cantidad),
    sumlist(Dificultades, Suma),
    Promedio is Suma / Cantidad.


dificultadDeSalasDeEmpresa(Empresa,Dificultad):-
    esSalaDe(Sala, Empresa),
    nivelDeDificultadDeLaSala(Sala,Dificultad).

%6
%esSalaDe(NombreSala, Empresa).
esSalaDe(estrellasDePelea, supercelula).
esSalaDe(choqueDeLaRealeza, supercelula).

%sala(Nombre, Experiencia).
sala(estrellasDePelea, familiar(videojuegos, 7)).
%sala(choqueDeLaRealeza, familiar(videojuegos,desconocido )).

esSalaDe(miseriaDeLaNoche, sKPista).
sala(miseriaDeLaNoche, terrorifica(150, 21)).

%esSalaDe(, vertigo).
%quedaEn(Boliche, Localidad)
quedaEn(pachuli, generalLasHeras).
quedaEn(why, generalLasHeras).
quedaEn(chaplin, generalLasHeras).
quedaEn(masDe40, sanLuis).
quedaEn(qma, caba).

%entran(Boliche, CapacidadDePersonas)
entran(pachuli, 500).
entran(why, 1000).
entran(chaplin, 700).
entran(masDe40, 1200).
entran(qma, 800).

%sirveComida(Boliche)
sirveComida(chaplin).
sirveComida(qma).

%tematico(tematica)
%cachengue(listaDeCancionesHabituales)
%electronico(djDeLaCasa, horaQueEmpieza, horaQueTermina)

%esDeTipo(Boliche, Tipo)
esDeTipo(why, cachengue([elYYo, prrrram, biodiesel, buenComportamiento])).
esDeTipo(masDe40, tematico(ochentoso)).
esDeTipo(qma, electronico(djFenich, 2, 5)).

%1

esPiola(Boliche):-
    sirveComida(Boliche),
    esGrandeOQuedaEnGralLasHeras(Boliche).

esGrandeOQuedaEnGralLasHeras(Boliche):-
    esGrande(Boliche).

esGrande(Boliche):-
    entran(Boliche, CapacidadDePersonas),
    CapacidadDePersonas > 700.

esGrandeOQuedaEnGralLasHeras(Boliche):-
    quedaEn(Boliche, generalLasHeras).

%2
soloParaBailar(Boliche):-
    quedaEn(Boliche, _),
    not(sirveComida(Boliche)).

%3
podemosIrConEsa(Localidad):-
    quedaEn(_, Localidad),
    forall(quedaEn(Boliche, Localidad),esPiola(Boliche)).

%4

puntaje(Boliche,Puntaje):-
    esDeTipo(Boliche, Tipo),
    puntajePorTipo(Boliche,Tipo,Puntaje).

puntajePorTipo(_,tematico(ochentoso),9).
puntajePorTipo(_,tematico(Tematica),7):-
    Tematica \= ochentoso.
puntajePorTipo(_,electronico(_, HoraQueEmpieza, HoraQueTermina),Puntaje):-
    Puntaje is HoraQueEmpieza + HoraQueTermina.
puntajePorTipo(_,cachengue(ListaDeCanciones),10):-
    suenanTemaikenes(ListaDeCanciones).

suenanTemaikenes(ListaDeCanciones):-
    member(biodiesel,ListaDeCanciones),
    member(buenComportamiento,ListaDeCanciones).

%5
elMasGrande(Boliche,Localidad):-
    quedaEn(Boliche,Localidad),
    forall((quedaEn(OtroBoliche,Localidad), OtroBoliche \= Boliche),tieneMasCapacidadQue(Boliche,OtroBoliche) ).

tieneMasCapacidadQue(Boliche,OtroBoliche):-
    entran(Boliche, CapacidadBoliche),
    entran(OtroBoliche, CapacidadOtroBoliche),
    CapacidadBoliche >= CapacidadOtroBoliche.

%6
puedeAbastecer(Localidad,CantidadDePersonas):-
    capacidadDeTodosLosBoliches(Localidad,Capacidad),
    Capacidad >= CantidadDePersonas.

capacidadDeTodosLosBoliches(Localidad,CapacidadDeLaLocalidad):-
    quedaEn(_, Localidad),
    findall(CapacidadDeBoliche,(quedaEn(Boliche, Localidad),entran(Boliche, CapacidadDeBoliche)),Capacidades),
    sum_list(Capacidades,CapacidadDeLaLocalidad).

%7
%Trabajamos y nos divertimos
quedaEn(trabajamosYNosDivertimos, concordia).
esDeTipo(trabajamosYNosDivertimos, tematico(oficina)).
entran(trabajamosYNosDivertimos, 500).
sirveComida(trabajamosYNosDivertimos).
%El fin del mundo
quedaEn(elFinDelMundo,ushuaia).
entran(elFinDelMundo,1500).
esDeTipo(elFinDelMundo, electronico(djLuis, 0, 6)).
%Misterio
entran(misterio,1000000).
sirveComida(misterio).
% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).
tripulante(law, heart).
tripulante(bepo, heart).
tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).
% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy,arlongPark, 30000000).
impactoEnRecompensa(luffy,baroqueWorks, 70000000).
impactoEnRecompensa(luffy,eniesLobby, 200000000).
impactoEnRecompensa(luffy,marineford, 100000000).
impactoEnRecompensa(luffy,dressrosa, 100000000).
impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).
impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).
impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).
impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).
impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).
impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo,240000000).
impactoEnRecompensa(law, dressrosa, 60000000).
impactoEnRecompensa(bepo,sabaody,500).
impactoEnRecompensa(arlong, llegadaAEastBlue,20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

%1
participaronEn(Evento,Tripulacion1,Tripulacion2):-
    participoEn(Evento,Tripulacion1),
    participoEn(Evento,Tripulacion2),
    Tripulacion1 \= Tripulacion2.

participoEn(Evento,Tripulacion):-
    impactoEnRecompensa(Pirata,Evento,_),
    tripulante(Pirata, Tripulacion).

%2 
masDestacoEn(Evento,Pirata):-
    impactoEnRecompensa(Pirata,Evento,RecompensaPirata),
    forall(impactoEnRecompensa(_,Evento,RecompensaDeOtro),RecompensaPirata>=RecompensaDeOtro).

%3
pasoDesapercibidoEn(Evento,Pirata):-
    tripulante(Pirata, Tripulacion),
    participoEn(Evento,Tripulacion),
    noFueRecompensadoEn(Evento,Pirata).

noFueRecompensadoEn(Evento,Pirata):-
    not(impactoEnRecompensa(Pirata,Evento,_)).

%4
recompesaTotalDe(Tripulacion,RecompensaTripulacion):-
    tripulante(_, Tripulacion),
    findall(Recompensa,(tripulante(Pirata, Tripulacion), recompesaTotalDePirata(Pirata,Recompensa)),Recompensas),
    sumlist(Recompensas,RecompensaTripulacion).

%5

esTemible(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion),esPeligroso(Pirata)).

esTemible(Tripulacion):-
    recompesaTotalDe(Tripulacion,RecompensaTripulacion),
    RecompensaTripulacion > 500000000.

esPeligroso(Pirata):-
    recompesaTotalDePirata(Pirata,Recompensa),
    Recompensa > 100000000.
%esPeligroso del punto 7
esPeligroso(Pirata):-
    comioLaFrutaDelDiablo(Pirata,Fruta,Tipo),
    frutaDelDiabloPeligora(Fruta,Tipo).

recompesaTotalDePirata(Pirata,RecompensaDelPirata):-
    tripulante(Pirata, _),
    findall(Recompensa,impactoEnRecompensa(Pirata,_,Recompensa),Recompensas),
    sumlist(Recompensas,RecompensaDelPirata).

%6
% tipoDeFrutaDelDiablo(Fruta,tipo(efectos))
frutaDelDiabloPeligora(opeope,paramecia).
frutaDelDiabloPeligora(_,zoan(lobo)).
frutaDelDiabloPeligora(_,zoan(leopardo)).
frutaDelDiabloPeligora(_,zoan(anaconda)).
frutaDelDiabloPeligora(_,logia).

% comioLaFrutaDelDiablo(Pirata,Fruta,tipo)

comioLaFrutaDelDiablo(luffy,gomugomu,paramecia).
comioLaFrutaDelDiablo(buggy,barbara,paramecia).
comioLaFrutaDelDiablo(law,opeope,paramecia).
comioLaFrutaDelDiablo(chopper,hitohito,zoan(humano)).
comioLaFrutaDelDiablo(lucci,nekoneko,zoan(leopardo)).
comioLaFrutaDelDiablo(smoker,mokumoku,logia).

%OtraForma
frutaPeligrosa(paramecia(opeope)).
frutaPeligrosa(zoan(_, Especie)):-
    especieFeroz(Especie).
frutaPeligrosa(logia(_,_)).

especieFeroz(lobo).
especieFeroz(leopardo).
especieFeroz(anaconda).

%7

piratasDelAsfalto(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(tripulante(Pirata, Tripulacion),noPuedeNadar(Pirata)).

noPuedeNadar(Pirata):-
    comioLaFrutaDelDiablo(Pirata,_,_).
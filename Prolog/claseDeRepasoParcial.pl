% https://docs.google.com/document/d/1VUNyZQXITv9CiSz9VjFwoQRVe8o03CtyvTS79UNl0O8/edit

% iLógico
%Punto1
personaje(pepe).
sigueA(juan, pepe).
%Original
todosSiguenA(Rey) :-
    personaje(Rey),
    not((personaje(Personaje), not(sigueA(Personaje, Rey)))).
% Cambio
todosSiguenA(Rey) :-
    personaje(Rey),
    forall(personaje(Personaje), not(sigueA(Personaje, Rey))).

%Punto 2


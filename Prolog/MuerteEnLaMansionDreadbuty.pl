%Base de Conocimiento%
%Tía Agatha, el mayordomo y Charles son las únicas personas que viven en la mansión Dreadbury.%

viveEnLaMansion(charles).
viveEnLaMansion(aghata).
viveEnLaMansion(mayordomo).


odia(charles,Odiados) :-
    viveEnLaMansion(Odiados), %sumo el dominio de los que viven en la mansion para que sea inversible %
    not(odia(aghata,Odiados)).

odia(aghata,Odiados) :-
    viveEnLaMansion(Odiados),
    Odiados \= mayordomo.

odia(mayordomo,Odiados) :-
    odia(aghata,Odiados).

esMasRicoQue(aghata,Persona) :-
    not(odia(mayordomo,Persona)),
    viveEnLaMansion(Persona).


matoA(Victima,Asesino) :-
    odia(Asesino,Victima),
    viveEnLaMansion(Asesino),
    esMasRicoQue(Victima,Asesino).

/*
1-A)El programa debe resolver el problema de quién mató a la tía Agatha. 
"matoA(aghata,Asesino)." Resuelve el problema

1-B)Mostrar la consulta utilizada y la respuesta obtenida.

1 ?- matoA(aghata,Asesino).
Asesino = mayordomo.
*/

/*
2.
Agregar los mínimos hechos y reglas necesarios para poder consultar:
Mostrar las consultas utilizadas para conseguir lo anterior, junto con las respuestas obtenidas.
*/
/*
- Si existe alguien que odie a milhouse.
Existe Alguien?:
?- odia(_,milhouse).        
true .

Quien?:
?- odia(Odiador,milhouse).
Odiador = charles .
*/
/*
- A quién odia charles.
?- odia(charles,Odiados).
Odiados = mayordomo.
*/
/*
- El nombre de quien odia a tía Ágatha.
?- odia(aghata,Odiados).  
Odiados = charles ;
Odiados = aghata ;
*/
/*
- Todos los odiadores y sus odiados.
?- odia(Odiadores,Odiados).
Odiadores = charles,
Odiados = mayordomo ;
Odiadores = aghata,
Odiados = charles ;
Odiadores = Odiados, Odiados = aghata ;
Odiadores = mayordomo,
Odiados = charles ;
Odiadores = mayordomo,
Odiados = aghata ;
false.
*/
/*
- Si es cierto que el mayordomo odia a alguien.
Existe Alguien?:
?- odia(mayordomo,_).
true .

Quien?:
?- odia(mayordomo,Odiados). 
Odiados = charles ;
Odiados = aghata ;
false.
*/

%Base de Conocimiento%


viveEnLaMansion(charles).
viveEnLaMansion(aghata).
viveEnLaMansion(mayordomo).


odia(charles,Odiado) :-
    viveEnLaMansion(Odiado),
    not(odia(aghata,Odiado)).

odia(aghata,Odiado) :-
    viveEnLaMansion(Odiado),
    Odiado \= mayordomo.

odia(mayordomo,Odiado) :-
    odia(aghata,Odiado).

esMasRicoQue(aghata,Persona) :-
    viveEnLaMansion(Persona),
    not(odia(mayordomo,Persona)).



matoA(Victima,Asesino) :-
    viveEnLaMansion(Asesino),
    odia(Asesino,Victima),
    not(esMasRicoQue(Victima,Asesino)).

/*
1-A)El programa debe resolver el problema de quién mató a la tía Agatha. 
"matoA(aghata,Asesino)." Resuelve el problema

1-B)Mostrar la consulta utilizada y la respuesta obtenida.

1 ?- matoA(aghata,Asesino).
Asesino = aghata.
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
false.

Quien?:
?- odia(Odiador,milhouse). 
false.
*/

/*
- A quién odia charles.
?- odia(charles,Odiado).
Odiado = mayordomo.
*/
/*
- El nombre de quien odia a tía Ágatha.
?- odia(aghata,Odiado).  
Odiado = charles ;
Odiado = aghata ;
*/
/*
- Todos los odiadores y sus Odiado.
?- odia(aghata,Odiado). 
Odiado = charles ;
Odiado = aghata ;
false.

11 ?- odia(Odiadores,Odiado).
Odiadores = charles,
Odiado = mayordomo ;
Odiadores = aghata,
Odiado = charles ;
Odiadores = Odiado, Odiado = aghata ;
Odiadores = mayordomo,
Odiado = charles ;
Odiadores = mayordomo,
Odiado = aghata ;
false.
*/
/*
- Si es cierto que el mayordomo odia a alguien.
Existe Alguien?:
?- odia(mayordomo,_).
true .

Quien?:
?- odia(mayordomo,Odiado). 
Odiado = charles ;
Odiado = aghata ;
false.
*/

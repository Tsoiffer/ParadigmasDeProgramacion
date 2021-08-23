%atiendeElDiaEnElHorario(Persona,DIAS,Entrada,Salida)
%1
atiendeElDiaEnElHorario(dodain,lunes,9,15).
atiendeElDiaEnElHorario(dodain,miercoles,9,15).
atiendeElDiaEnElHorario(lucas,martes,10,20).
atiendeElDiaEnElHorario(juanC,sabado,18,22).
atiendeElDiaEnElHorario(juanC,domingo,18,22).
atiendeElDiaEnElHorario(juanFdS,jueves,10,20).
atiendeElDiaEnElHorario(juanFdS,viernes,12,20).
atiendeElDiaEnElHorario(leoC,lunes,14,18).
atiendeElDiaEnElHorario(leoC,miercoles,14,18).
atiendeElDiaEnElHorario(martu,miercoles,23,24).

atiendeElDiaEnElHorario(vale,Dia,Entrada,Salida):-
    atiendeElDiaEnElHorario(dodain,Dia,Entrada,Salida).

atiendeElDiaEnElHorario(vale,Dia,Entrada,Salida):-
    atiendeElDiaEnElHorario(juanC,Dia,Entrada,Salida).

%no es necesario escribir que nadie realiza el horario de leoC, por el concepto de universo cerrado si no esta definido nadie mas en ese horario es lo mismo que no exista
%no es necesario escribir el horario que maiu esta pensando, en la base de conocimiento se escriben hechos y no posibilidades.

%2
seEncuentraEnElKiosco(Persona,Dia,Hora):-
    atiendeElDiaEnElHorario(Persona,Dia,Entrada,Salida),
    Entrada =< Hora,
    Salida >= Hora.

%3
ateindeSola(Persona,Dia,Hora):-
    seEncuentraEnElKiosco(Persona,Dia,Hora),
    forall((atiendeElDiaEnElHorario(OtraPersona,_,_,_), Persona \= OtraPersona),
    not(seEncuentraEnElKiosco(OtraPersona,Dia,Hora))
    ).


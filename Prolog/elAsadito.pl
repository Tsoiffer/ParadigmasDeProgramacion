%asadoEn(MotivoConvocatoria,lugar)
asadoEn(llegoLaVacuna, parque).
asadoEn(finDeLaCuarentena, patio).
%asadoCon(MotivoConvocatoria,alimento)
asadoCon(llegoLaVacuna, chori).
asadoCon(llegoLaVacuna, tiraDeAsado).
asadoCon(llegoLaVacuna, provoleta).
asadoCon(finDeLaCuarentena, vacio).
asadoCon(finDeLaCuarentena, provoleta).
%asistio(MotivoConvocatoria,Persona,AccionDestacable)
asistio(llegoLaVacuna, flor, asador).
asistio(llegoLaVacuna, marina, hizoChistes(3)).
asistio(llegoLaVacuna, marina, toca(guitarra, bien)).
asistio(llegoLaVacuna, pablo, toca(violin, mal)).
asistio(llegoLaVacuna, pablo, contoAnecdotaDe([marina,pablo])).
asistio(finDeLaCuarentena, pablo, hizoChistes(1)).
asistio(finDeLaCuarentena, marina, toca(guitarra, mal)).
%sumamos a Carlos
asistio(llegoLaVacuna, carlos, contoAnecdotaDe([carlos,parejaCarlos])).
asistio(finDeLaCuarentena, carlos, asador).

%1
%a
%leGuataComerA(Persona,Alimento).
%leGuataComerA(flor,chori).
leGuataComerA(marina,chori).
leGuataComerA(pablo,provoleta).

leGuataComerA(pablo,Carne):-
    esCarne(Carne).
leGuataComerA(marina,provoleta).

leGuataComerA(marina,Carne):-
    esCarne(Carne).

leGuataComerA(carlos,provoleta).

leGuataComerA(carlos,Carne):-
    esCarne(Carne).

esCarne(chori).
esCarne(tiraDeAsado).
esCarne(vacio).
%b
%como no aclara en cual asado fue asador y en cual conto chistes pero sabemos que flor fue el asador de "llegoLaVacuna" 
%asimo que fue asador en "finDeLaCuarentena" y conto anecdotas en "llegoLaVacuna"

%ii. como no asistio no en nesesario incluirla en la base de conocimiento

%iii. se responde en el punto "i."


%2
asadoExitoso(Asado):-
    asadoEn(Asado, _),
    forall(asistio(Asado, Persona, _),leGustanTodosLosAlimentosDe(Asado, Persona)).

%para hacer reversible leGustanTodosLosAlimentosDe se puede sumar el generador: asistio(Asado, Persona, _).
leGustanTodosLosAlimentosDe(Asado, Persona):-
    forall(asadoCon(Asado, Alimento),leGuataComerA(Persona, Alimento)).

%b
asadoAceptable(Asado):-
    asadoEn(Asado, _),
    forall(asistio(Asado, Persona, _),leGustanUnAlimentoDe(Asado, Persona)).

leGustanUnAlimentoDe(Asado, Persona):-
    asadoCon(Asado, Alimento),
    leGuataComerA(Persona, Alimento).

%C
asadoFracasado(Asado,Persona):-
    asistio(Asado, Persona, _),
    not(leGustanUnAlimentoDe(Asado, Persona)).

%3

buenaOnda(Asado,Persona):-
    asistio(Asado, Persona, hizoChistes(Chistes)),
    Chistes >= 3.

buenaOnda(Asado,Persona):-
    asistio(Asado, Persona, toca(_, bien)).

buenaOnda(Asado,Persona):-
    asistio(Asado, Persona, contoAnecdotaDe(Involucrados)),
    asistieronLaMayoriaAlAsado(Involucrados,Asado).

asistieronLaMayoriaAlAsado(Involucrados,Asado):-
    asadoEn(Asado, _),
    findall(Persona,(asistio(Asado, Persona, _),member(Persona,Involucrados)),Personas),
    length(Personas,CantidadPresentes),
    length(Involucrados,CantidadInvolucrados),
    CantidadPresentes > CantidadInvolucrados / 2.

%4
% Teorico
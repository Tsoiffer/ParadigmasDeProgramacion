import Text.Show.Functions

type Propiedad = (String, Float)

type Accion = (Persona -> Persona)

data Persona = UnaPersona
  { nombre :: String,
    dinero :: Float,
    tactica :: String,
    propiedades :: [Propiedad],
    acciones :: [Accion]
  }
  deriving (Show)

-- PROPIEDADES
wilde :: Propiedad
wilde = ("wilde", 200)

chingolo :: Propiedad
chingolo = ("chingolo", 330)

recoleta :: Propiedad
recoleta = ("recoleta", 550)

-- JUGADORES
carolina :: Persona
carolina = UnaPersona "Carolina" 500 "Accionista" [("capilla sixtina", 100), ("Casa Caro", 200)] [pasarPorElBanco, pagarAAccionistas]

manuel :: Persona
manuel = UnaPersona "Manuel" 500 "Oferente singular" [("torre de pizza", 100)] [pasarPorElBanco, enojarse]

tomas :: Persona
tomas = UnaPersona "Tomas" 500 "Oferente singular" [("Casa Tomas", 100)] [pasarPorElBanco, enojarse, gritar, cobrarAlquileres, pagarAAccionistas, hacerBerrinchePor chingolo, subastar wilde]

--FUNCIONES
pasarPorElBanco :: Accion
pasarPorElBanco jugador = editarTactica (const "Comprador compulsivo") . (editarDinero (+ 40)) $ jugador

enojarse :: Accion
enojarse jugador = editarAcciones (++ [gritar]) . (editarDinero (+ 50)) $ jugador

gritar :: Accion
gritar jugador = editarNombre (\nombreJgador -> "AHHHH" ++ nombreJgador) jugador

subastar :: Propiedad -> Accion
subastar propiedad jugador = verificacion propiedad jugador (tactica jugador == "Oferente singular" || esAccionista jugador) jugador

cobrarAlquileres :: Accion
cobrarAlquileres jugador = editarDinero (+ (dineroDeAlquileres . propiedades $jugador)) jugador

pagarAAccionistas :: Accion
pagarAAccionistas jugador
  | esAccionista jugador = editarDinero (+ 200) jugador
  | otherwise = editarDinero (\numero -> numero - 100) jugador

hacerBerrinchePor :: Propiedad -> Accion
hacerBerrinchePor propiedad jugador = verificacion propiedad jugador ((dinero jugador) >= (snd propiedad)) (continuarConBerrinche propiedad jugador)

ultimaRonda :: Persona -> Accion
ultimaRonda jugador = foldl1 (.) (acciones jugador)

juegoFinal :: Persona -> Persona -> Persona
juegoFinal jugador1 jugador2
  | (dineroFinal jugador1) > (dineroFinal jugador2) = jugador1
  | otherwise = jugador2

--Funciones Auxiliares

dineroDeAlquileres :: [Propiedad] -> Float
dineroDeAlquileres propiedadesDelJugador = sum (map barataOCara propiedadesDelJugador)

esAccionista :: Persona -> Bool
esAccionista jugador = tactica jugador == "Accionista"

barataOCara :: Propiedad -> Float
barataOCara (_, valor)
  | valor > 150 = 20
  | otherwise = 10

comprarPropiedad :: Propiedad -> Persona -> Persona
comprarPropiedad propiedad jugador = sumarPropiedad (++ [propiedad]) . (editarDinero ((-) . snd $propiedad)) $ jugador

continuarConBerrinche :: Propiedad -> Accion
continuarConBerrinche propiedad jugador = (hacerBerrinchePor propiedad) . gritar $ editarDinero (+ 10) jugador

verificacion :: Propiedad -> Persona -> Bool -> Persona -> Persona
verificacion propiedad jugador condicion otroCaso
  | condicion = comprarPropiedad propiedad jugador
  | otherwise = otroCaso

dineroFinal :: Persona -> Float
dineroFinal jugador = dinero . (ultimaRonda jugador) $ jugador

--Mappers
editarTactica :: (String -> String) -> Persona -> Persona
editarTactica funcion jugador = jugador {tactica = funcion . tactica $ jugador}

editarDinero :: (Float -> Float) -> Persona -> Persona
editarDinero funcion jugador = jugador {dinero = funcion . dinero $ jugador}

editarAcciones :: ([Accion] -> [Accion]) -> Persona -> Persona
editarAcciones funcion jugador = jugador {acciones = funcion . acciones $ jugador}

editarNombre :: (String -> String) -> Persona -> Persona
editarNombre funcion jugador = jugador {nombre = funcion . nombre $ jugador}

sumarPropiedad :: ([Propiedad] -> [Propiedad]) -> Persona -> Persona
sumarPropiedad funcion jugador = jugador {propiedades = funcion . propiedades $ jugador}
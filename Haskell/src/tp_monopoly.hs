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
pasarPorElBanco jugador = (editarTactica "Comprador compulsivo") . (editarDinero (+) 40) $ jugador

enojarse :: Accion
enojarse jugador = (sumarAcciones gritar) . (editarDinero (+) 50) $ jugador

gritar :: Accion
gritar jugador = editarNombre "AHHHH" jugador

subastar :: Propiedad -> Accion
subastar propiedad jugador
  | tactica jugador == "Oferente singular" || tactica jugador == "Accionista" = comprarPropiedad propiedad jugador
  | otherwise = jugador

cobrarAlquileres :: Accion
cobrarAlquileres jugador = editarDinero (+) (dineroDeAlquileres (propiedades jugador)) jugador

pagarAAccionistas :: Accion
pagarAAccionistas jugador
  | tactica jugador == "Accionista" = editarDinero (+) 200 jugador
  | otherwise = editarDinero (-) 100 jugador

hacerBerrinchePor :: Propiedad -> Accion
hacerBerrinchePor propiedad jugador
  | (dinero jugador) >= (snd propiedad) = comprarPropiedad propiedad jugador
  | otherwise = (hacerBerrinchePor propiedad) . gritar $ editarDinero (+) 10 jugador

ultimaRonda :: Persona -> Accion
ultimaRonda jugador = foldl1 (.) (acciones jugador)

juegoFinal :: Persona -> Persona -> Persona
juegoFinal jugador1 jugador2
  | (dineroFinal jugador1) > (dineroFinal jugador2) = jugador1
  | otherwise = jugador2

--Funciones Auxiliares

dineroDeAlquileres :: [Propiedad] -> Float
dineroDeAlquileres propiedadesDelJugador = sum (map barataOCara propiedadesDelJugador)

barataOCara :: Propiedad -> Float
barataOCara (_, valor)
  | valor > 150 = 2 * 10
  | otherwise = 1 * 10

comprarPropiedad :: Propiedad -> Persona -> Persona
comprarPropiedad propiedad jugador = (sumarPropiedad propiedad) . (editarDinero (-) (snd propiedad)) $ jugador

dineroFinal :: Persona -> Float
dineroFinal jugador = dinero . (ultimaRonda jugador) $ jugador

--Mappers
editarTactica :: String -> Persona -> Persona
editarTactica nuevaTactica jugador = jugador {tactica = nuevaTactica}

editarDinero :: (Float -> Float -> Float) -> Float -> Persona -> Persona
editarDinero funcion diferencia jugador = jugador {dinero = funcion (dinero jugador) diferencia}

sumarAcciones :: Accion -> Persona -> Persona
sumarAcciones accion jugador = jugador {acciones = (:) accion (acciones jugador)}

editarNombre :: String -> Persona -> Persona
editarNombre prefijo jugador = jugador {nombre = prefijo ++ (nombre jugador)}

sumarPropiedad :: Propiedad -> Persona -> Persona
sumarPropiedad nuevaPropiedad jugador = jugador {propiedades = (:) nuevaPropiedad (propiedades jugador)}
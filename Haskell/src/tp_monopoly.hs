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
pasarPorElBanco jugador = jugador {tactica = "Comprador compulsivo", dinero = dinero jugador + 40}

enojarse :: Accion
enojarse jugador = jugador {acciones = acciones jugador ++ [gritar], dinero = dinero jugador + 50}

gritar :: Accion
gritar jugador = jugador {nombre = "AHHHH" ++ nombre jugador}

subastar :: Propiedad -> Accion
subastar propiedad jugador
  | tactica jugador == "Oferente singular" = jugador {dinero = (dinero jugador) - (snd propiedad), propiedades = (propiedades jugador) ++ [propiedad]}
  | tactica jugador == "Accionista" = jugador {dinero = (dinero jugador) - (snd propiedad), propiedades = (propiedades jugador) ++ [propiedad]}
  | otherwise = jugador

cobrarAlquileres :: Accion
cobrarAlquileres jugador = jugador {dinero = dinero jugador + 10 * sum (map barataOCara (propiedades jugador))}

barataOCara :: Propiedad -> Float
barataOCara (_, valor)
  | valor > 150 = 2
  | otherwise = 1

pagarAAccionistas :: Accion
pagarAAccionistas jugador
  | tactica jugador == "Accionista" = jugador {dinero = 200 + dinero jugador}
  | otherwise = jugador {dinero = dinero jugador - 100}

hacerBerrinchePor :: Propiedad -> Accion
hacerBerrinchePor propiedad jugador
  | (dinero jugador) >= (snd propiedad) = jugador {dinero = (dinero jugador) - (snd propiedad), propiedades = (propiedades jugador) ++ [propiedad]}
  | otherwise = (hacerBerrinchePor propiedad) . gritar $ (jugador {dinero = dinero jugador + 10})

ultimaRonda :: Persona -> Accion
ultimaRonda jugador = foldl1 (.) (acciones jugador)

juegoFinal :: Persona -> Persona -> String
juegoFinal jugador1 jugador2
  | (dineroFinal jugador1) > (dineroFinal jugador2) = "Gano " ++ nombre jugador1 ++ "!"
  | (dineroFinal jugador2) > (dineroFinal jugador1) = "Gano " ++ nombre jugador2 ++ "!"
  | otherwise = "Empate!"

dineroFinal :: Persona -> Float
dineroFinal jugador = dinero . (ultimaRonda jugador) $ jugador
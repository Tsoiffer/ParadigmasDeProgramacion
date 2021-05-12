import Text.Show.Functions

type Propiedad = (String, Float)

type Accion = (Persona -> Persona)

data Persona = UnaPersona
  { nombre :: String,
    dinero :: Int,
    tactica :: String,
    propiedades :: [Propiedad],
    acciones :: [(Accion)]
  }
  deriving (Show)

-- PROPIEDADES
wilde :: Propiedad
wilde = ("wilde", 200)

recoleta :: Propiedad
recoleta = ("recoleta", 550)

-- JUGADORES
carolina :: Persona
carolina = UnaPersona "Carolina" 500 "Accionista" [("capilla sixtina", 100), ("tomasss", 200)] [pasarPorElBanco, pagarAAccionistas]

manuel :: Persona
manuel = UnaPersona "Manuel" 500 "Oferente singular" [("torre de pizza", 100)] [pasarPorElBanco, enojarse]

pasarPorElBanco :: Persona -> Persona
pasarPorElBanco jugador = jugador {tactica = "Comprador compulsivo", dinero = dinero jugador + 40}

enojarse :: Persona -> Persona
enojarse jugador = jugador {acciones = acciones jugador ++ [gritar], dinero = dinero jugador + 50}

gritar :: Persona -> Persona
gritar jugador = jugador {nombre = "AHHHH" ++ nombre jugador}

subastar :: Persona -> Persona
subastar jugador
  | tactica jugador == "Oferente singular" = jugador {nombre = "AHHHH" ++ nombre jugador}
  | tactica jugador == "Accionista" = jugador {nombre = "AHHHH" ++ nombre jugador}
  | otherwise = jugador

cobrarAlquileres :: Persona -> Persona
cobrarAlquileres jugador = jugador {dinero = dinero jugador + 10 * (sum . (map (ceiling . (/ 150) . snd)) $ (propiedades jugador))}

pagarAAccionistas :: Persona -> Persona
pagarAAccionistas jugador
  | tactica jugador == "Accionista" = jugador {dinero = 200 + dinero jugador}
  | otherwise = jugador {dinero = dinero jugador - 100}

hacerBerrinchePor :: Propiedad -> Persona -> Persona
hacerBerrinchePor propiedad jugador
  | fromIntegral (dinero jugador) >= (snd propiedad) = jugador
  | otherwise = (hacerBerrinchePor propiedad) . gritar $ (jugador {dinero = dinero jugador + 10})
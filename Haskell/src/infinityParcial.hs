data Personaje = Personaje
  { nombre :: String,
    cantidadPoder :: Int,
    derrotas :: [Derrota],
    equipamiento :: [Equipamiento]
  }

type Equipamiento = Personaje -> Personaje

type Derrota = (String, Int)

mapCantidadPoder :: (Int -> Int) -> Personaje -> Personaje
mapCantidadPoder unaFuncion unPersonaje = unPersonaje {cantidadPoder = unaFuncion . cantidadPoder $ unPersonaje}

mapNombre :: (String -> String) -> Personaje -> Personaje
mapNombre unaFuncion unPersonaje = unPersonaje {nombre = unaFuncion . nombre $ unPersonaje}

mapDerrotas :: ([Derrota] -> [Derrota]) -> Personaje -> Personaje
mapDerrotas unaFuncion unPersonaje = unPersonaje {derrotas = unaFuncion . derrotas $ unPersonaje}

entrenamiento :: [Personaje] -> [Personaje]
entrenamiento personajes = map (mapCantidadPoder ((*) . length $ personajes)) personajes

rivalesDignos :: [Personaje] -> [Personaje]
rivalesDignos personajes = filter esRivalDigno . entrenamiento $ personajes

esRivalDigno :: Personaje -> Bool
esRivalDigno unPersonaje = cantidadPoder unPersonaje > 500 && derrotoA "Hijo de Thanos" unPersonaje

derrotoA :: String -> Personaje -> Bool
derrotoA unHeroe unPersonaje = elem unHeroe . map fst . derrotas $ unPersonaje

guerraCivil :: Int -> [Personaje] -> [Personaje] -> [Personaje]
guerraCivil año unosPersonajes otrosPersonajes = zipWith (pelear año) unosPersonajes otrosPersonajes

pelear :: Int -> Personaje -> Personaje -> Personaje
pelear año unPersonaje otroPersonaje
  | cantidadPoder unPersonaje > cantidadPoder otroPersonaje = derrotar año unPersonaje otroPersonaje
  | otherwise = derrotar año otroPersonaje unPersonaje

derrotar :: Int -> Personaje -> Personaje -> Personaje
derrotar año ganador perdedor = mapDerrotas ((nombre perdedor, año) :) ganador

escudo :: Equipamiento
escudo unPersonaje
  | (< 5) . length . derrotas $ unPersonaje = mapCantidadPoder (+ 50) unPersonaje
  | otherwise = mapCantidadPoder (subtract 100) unPersonaje

trajeMecanizado :: Int -> Equipamiento
trajeMecanizado version unPersonaje = mapNombre (\nombre -> "Iron " ++ nombre ++ " V" ++ show version) unPersonaje

equipamientoExclusivo :: String -> Personaje -> Equipamiento -> Equipamiento
equipamientoExclusivo nombrePersonaje unPersonaje equipamiento
  | nombre unPersonaje == nombrePersonaje = equipamiento
  | otherwise = id

stormBreaker :: Equipamiento
stormBreaker unPersonaje = equipamientoExclusivo "Thor" unPersonaje (mapNombre (++ " dios del trueno") . mapDerrotas (const [])) $ unPersonaje

gemaDelAlma :: Equipamiento
gemaDelAlma unPersonaje = equipamientoExclusivo "Thanos" unPersonaje (mapDerrotas (++ derrotasExtras)) $ unPersonaje

derrotasExtras :: [Derrota]
derrotasExtras = zip extras [2018 ..]

extras :: [String]
extras = map agregarExtra [1 ..]

agregarExtra :: Int -> String
agregarExtra valor = ("extra numero " ++) . show $ valor

guanteleteInfinito :: [Equipamiento] -> Personaje -> Personaje
guanteleteInfinito unosEquipamientos unPersonaje = foldr ($) unPersonaje (filter esGemaDelInfinito unosEquipamientos)

esGemaDelInfinito :: Equipamiento -> Bool
esGemaDelInfinito unEquipamiento = True

{-
  Parte C
  a. Se cuelga porque definí derrotoAMuchos con un length, y el length de una lista infinita no termina de evaluar.
     Se puede definir derrotoAMuchos de forma de que sea lazy y pueda terminar de evaluar, como:
     derrotoAMuchos = not . null . drop 5 . derrotas
  b. Si no es fuerte luego de entrenar con el resto del equipo, termina bien.
     Si es fuerte y el hijo de thanos se encuentra entre sus derrotados, termina bien.
     En caso contrario, no termina.
  c. Si. Porque haskell trabaja con evaluación perezosa, y no es necesario evaluar toda la lista para tomar los primeros 100 elementos.
-}
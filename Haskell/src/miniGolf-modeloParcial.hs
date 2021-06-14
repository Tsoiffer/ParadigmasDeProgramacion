import Text.Show.Functions

-- Modelo inicial
data Jugador = UnJugador
  { nombre :: String,
    padre :: String,
    habilidad :: Habilidad
  }
  deriving (Eq, Show)

data Habilidad = Habilidad
  { fuerzaJugador :: Int,
    precisionJugador :: Int
  }
  deriving (Eq, Show)

-- Jugadores de ejemplo
bart :: Jugador
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)

todd :: Jugador
todd = UnJugador "Todd" "Ned" (Habilidad 15 80)

rafa :: Jugador
rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro
  { velocidad :: Int,
    precision :: Int,
    altura :: Int
  }
  deriving (Eq, Show)

type Puntos = Int

-- Funciones útiles
between n m x = elem x [n .. m]

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

--1
type Palo = Habilidad -> Tiro

putter :: Palo
putter unaHabilidad = UnTiro 10 (2 * precisionJugador unaHabilidad) 0

madera :: Palo
madera unaHabilidad = UnTiro 100 (div 2 . precisionJugador $ unaHabilidad) 5

hierros :: Int -> Palo
hierros n unaHabilidad = UnTiro (caracteristicaTiro n 1 ((*) (fuerzaJugador unaHabilidad))) (caracteristicaTiro n 1 (div (precisionJugador unaHabilidad))) (caracteristicaTiro n 3 (subtract 3))

caracteristicaTiro :: (Enum a, Eq a, Num a) => a -> a -> (a -> a) -> a
caracteristicaTiro n numeroIncial funcion
  | between numeroIncial 10 n = funcion n
  | otherwise = 0

palos :: [Palo]
palos = [putter, madera, hierros 10]

--2

golpe :: Jugador -> Palo -> Tiro
golpe unJugador unPalo = unPalo . habilidad $ unJugador

--3
data Obstaculo = UnObstaculo
  { puedeSuperar :: Tiro -> Bool,
    efectoLuegoDeSuperar :: Tiro -> Tiro
  }

estiroOptimo :: (Tiro -> Bool) -> (Tiro -> Tiro) -> Tiro -> Tiro
estiroOptimo condicion variacionFinal unTiro
  | condicion unTiro = variacionFinal unTiro
  | otherwise = UnTiro 0 0 0

--A
túnel :: Obstaculo
túnel = UnObstaculo condicionTunel superoElTunel

condicionTunel :: Tiro -> Bool
condicionTunel unTiro = precision unTiro > 90 && altura unTiro == 0

superoElTunel :: Tiro -> Tiro
superoElTunel = editarVelocidad (* 2) . editarPrecision (const 100) . editarAltura (const 0)

--B
laguna :: Int -> Obstaculo
laguna largo = UnObstaculo condicionLaguna (superoLaguna largo)

condicionLaguna :: Tiro -> Bool
condicionLaguna unTiro = velocidad unTiro > 80 && between 1 5 (altura unTiro)

superoLaguna :: Int -> Tiro -> Tiro
superoLaguna largo = editarAltura (flip div largo)

--C
hoyo :: Obstaculo
hoyo = UnObstaculo condicionHoyo superoElHoyo

condicionHoyo :: Tiro -> Bool
condicionHoyo unTiro = between 5 20 (velocidad unTiro) && altura unTiro == 0 && precision unTiro > 95

superoElHoyo :: Tiro -> Tiro
superoElHoyo = editarVelocidad (const 0) . editarPrecision (const 0) . editarAltura (const 0)

--4
--A
palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles unjugador unObstaculo = filter (puedePasar unObstaculo unjugador) palos

puedePasar :: Obstaculo -> Jugador -> Palo -> Bool
puedePasar unObstaculo unjugador palo = puedeSuperar unObstaculo . golpe unjugador $ palo

--B
cuantosObstaculosConsecutivosSupera :: Tiro -> [Obstaculo] -> Int
cuantosObstaculosConsecutivosSupera tiro [] = 0
cuantosObstaculosConsecutivosSupera tiro (obstaculo : obstaculos)
  | puedeSuperar obstaculo tiro =
    1 + cuantosObstaculosConsecutivosSupera (efectoLuegoDeSuperar obstaculo tiro) obstaculos
  | otherwise = 0

--C
paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos =
  maximoSegun (flip cuantosObstaculosConsecutivosSupera obstaculos . golpe jugador) palos

--5

jugadorDeTorneo = fst

puntosGanados = snd

pierdenLaApuesta :: [(Jugador, Puntos)] -> [String]
pierdenLaApuesta puntosDeTorneo =
  (map (padre . jugadorDeTorneo) . filter (not . gano puntosDeTorneo)) puntosDeTorneo

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano puntosDeTorneo puntosDeUnJugador =
  ( all ((< puntosGanados puntosDeUnJugador) . puntosGanados)
      . filter (/= puntosDeUnJugador)
  )
    puntosDeTorneo

--mappers
editarVelocidad :: (Int -> Int) -> Tiro -> Tiro
editarVelocidad funcion unTiro = unTiro {velocidad = funcion . velocidad $ unTiro}

editarPrecision :: (Int -> Int) -> Tiro -> Tiro
editarPrecision funcion unTiro = unTiro {precision = funcion . precision $ unTiro}

editarAltura :: (Int -> Int) -> Tiro -> Tiro
editarAltura funcion unTiro = unTiro {altura = funcion . altura $ unTiro}

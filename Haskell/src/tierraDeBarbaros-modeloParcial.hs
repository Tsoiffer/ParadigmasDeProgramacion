import Text.Show.Functions

-- Punto 1
type Objeto = Barbaro -> Barbaro

data Barbaro = Barbaro
  { nombre :: String,
    fuerza :: Float,
    habilidades :: [String],
    objetos :: [Objeto]
  }
  deriving (Show)

dave :: Barbaro
dave = Barbaro "Dave" 100 ["tejer", "escribirPoesia"] [ardilla, varitasDefectuosas]

tomas :: Barbaro
tomas = Barbaro "Tomas" 200 ["tejer", "Escribir Poesia Atroz"] [espada 20, cuerda megafono varitasDefectuosas]

faffy :: Barbaro
faffy = Barbaro "Faffy" 100 ["tejer", "escribirPoesia"] [ardilla, varitasDefectuosas]

astro :: Barbaro
astro = Barbaro "Astro" 100 ["tejer", "escribirPoesia"] [ardilla, varitasDefectuosas]

--Objetos

espada :: Float -> Objeto
espada peso = editarFuerza (+ 2 * peso)

amuletoMistico :: String -> Objeto
amuletoMistico unaHailidad = editarHbilidades (++ [unaHailidad])

varitasDefectuosas :: Objeto
varitasDefectuosas = editarHbilidades (++ ["hacer magia"]) . editarObjetos (const [])

ardilla :: Objeto
ardilla = id

cuerda :: Objeto -> Objeto -> Objeto
cuerda objeto1 objeto2 = objeto1 . objeto2

-- Punto 2

megafono :: Objeto
megafono = editarHbilidades (habilidaesEnMayusculas)

habilidaesEnMayusculas :: [String] -> [String]
habilidaesEnMayusculas = map (map toUpper)

toUpper :: Char -> Char
toUpper = id

megafonoBarbarico :: Objeto
megafonoBarbarico = cuerda megafono ardilla

--Punto 3 - Aventuras
type Aventura = Barbaro -> Bool

--1
invasionDeSuciosDuendes :: Aventura
invasionDeSuciosDuendes = sabeEscribirPoesia

sabeEscribirPoesia :: Barbaro -> Bool
sabeEscribirPoesia = elem ("Escribir Poesia Atroz") . habilidades

--2
cremalleraDelTiempo :: Aventura
cremalleraDelTiempo = noTienePulgares

sinPulgares :: [String]
sinPulgares = ["Faffy", "Astro"]

noTienePulgares :: Barbaro -> Bool
noTienePulgares = flip elem sinPulgares . nombre

--3
ritualDeFechorias :: Aventura
ritualDeFechorias = algunaFechoria

algunaFechoria :: Barbaro -> Bool
algunaFechoria unBarbaro = any ($unBarbaro) [saqueo, gritoDeGuerra, caligrafia]

saqueo :: Barbaro -> Bool
saqueo unBarbaro = elem "robar" (habilidades unBarbaro) && 40 < fuerza unBarbaro

gritoDeGuerra :: Barbaro -> Bool
gritoDeGuerra unBarbaro = poderGritoDeGuerra unBarbaro > 4 * length (objetos unBarbaro)

poderGritoDeGuerra :: Barbaro -> Int
poderGritoDeGuerra = length . concat . habilidades

caligrafia :: Barbaro -> Bool
caligrafia unBarbaro = tresVocales (habilidades unBarbaro) && cominzanConMayusculas (habilidades unBarbaro)

tresVocales :: [String] -> Bool
tresVocales unasHabilidades = all ((3 <=) . length . soloVocales) unasHabilidades

soloVocales :: String -> String
soloVocales nombreConVocales = filter (flip elem listaVocales) nombreConVocales

listaVocales :: String
listaVocales = "aeiouAEIOU"

cominzanConMayusculas :: [String] -> Bool
cominzanConMayusculas unasHabilidades = all (esMayuscula . head) unasHabilidades

esMayuscula :: Char -> Bool
esMayuscula unaLetra = unaLetra == toUpper unaLetra

sobrevivientes :: [Barbaro] -> Aventura -> [Barbaro]
sobrevivientes unosBarbaros unaAventura = filter unaAventura unosBarbaros

--Punto 4 - Dinastía
--A
sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos unasHabilidades = foldl descartarRepetidos [] unasHabilidades

descartarRepetidos :: Eq a => [a] -> a -> [a]
descartarRepetidos lista elemento
  | elem elemento lista = lista
  | otherwise = lista ++ [elemento]

--B
descendientes :: Barbaro -> [Barbaro]
descendientes unBarbaro = iterate generarDecendiente unBarbaro

generarDecendiente :: Barbaro -> Barbaro
generarDecendiente = aplicarObjetos . editarHbilidades (sinRepetidos) . editarNombre (++ "*")

aplicarObjetos :: Barbaro -> Barbaro
aplicarObjetos unBarbaro = foldr ($) unBarbaro (objetos unBarbaro)

--C
-- ¿Se podría aplicar sinRepetidos sobre la lista de objetos?
-- No por que Objeto es una funcion que va de Barbaro a Barbaro y las funciones no se pueden comparar
-- ¿Y sobre el nombre de un bárbaro? ¿Por qué?
-- Si se puede aplicar sobre el nombre, lo va a reconocer como una lista de caracteres y va a descartar los caracteres repetidos

--mappers
editarNombre :: (String -> String) -> Barbaro -> Barbaro
editarNombre funcion unBarbaro = unBarbaro {nombre = funcion . nombre $ unBarbaro}

editarFuerza :: (Float -> Float) -> Barbaro -> Barbaro
editarFuerza funcion unBarbaro = unBarbaro {fuerza = funcion . fuerza $ unBarbaro}

editarHbilidades :: ([String] -> [String]) -> Barbaro -> Barbaro
editarHbilidades funcion unBarbaro = unBarbaro {habilidades = funcion . habilidades $ unBarbaro}

editarObjetos :: ([Objeto] -> [Objeto]) -> Barbaro -> Barbaro
editarObjetos funcion unBarbaro = unBarbaro {objetos = funcion . objetos $ unBarbaro}

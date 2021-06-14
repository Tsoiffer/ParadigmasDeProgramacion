import Text.Show.Functions

-- PARTE A
--1
data Persona = UnaPersona
  { nombre :: String,
    direccion :: String,
    dinero :: Float,
    comidaFavorita :: Comida,
    cupones :: [Cupon]
  }
  deriving (Show)

--2
data Comida = UnaComida
  { nombreComida :: String,
    costo :: Float,
    ingredientes :: [String]
  }
  deriving (Show)

--3
paula :: Persona
paula = UnaPersona "Paula" "Thames al 1585" 3600 hamburguesaDeluxe []

--4
hamburguesaDeluxe :: Comida
hamburguesaDeluxe = UnaComida "hamburguesa deluxe" 350 ["pan", "carne", "lechuga", "tomate", "panceta", "queso", "huevo frito"]

--5
tomas :: Persona
tomas = UnaPersona "Tomas" "Calle falsa 123" 5000 pizzaNapolitana [findeVegetariano, semanaVegana]

pizzaNapolitana :: Comida
pizzaNapolitana = UnaComida "Pizza Napolitana" 600 ["harina", "salsa", "queso", "tomate", "ajo", "cebolla"]

ensalada :: Comida
ensalada = UnaComida "Ensalada" 20 ["tomate", "lechuga", "rucula", "ajo", "cebolla"]

hamburguesaBarata :: Comida
hamburguesaBarata = UnaComida "hamburguesa barata" 50 ["pan", "carne", "lechuga", "tomate", "panceta", "queso", "huevo frito"]

--B
--1
comprar :: Comida -> Persona -> Persona
comprar unaComida unaPersona
  | (dinero unaPersona) >= (costo unaComida) = editarDinero (subtract (costo unaComida)) . nuevaComidaFavorita unaComida $ unaPersona
  | otherwise = unaPersona

nuevaComidaFavorita :: Comida -> Persona -> Persona
nuevaComidaFavorita unaComida unaPersona
  | costo unaComida < 200 = unaPersona {comidaFavorita = unaComida}
  | otherwise = unaPersona

--2
carritoDeCompras :: [Comida] -> Persona -> Persona
carritoDeCompras listaComida unaPersona = editarDinero (subtract 100) . foldr comprar unaPersona $ listaComida

--Cupones
type Cupon = Comida -> Comida

--1
listaNoVegana :: [String]
listaNoVegana = ["carne", "hevo", "queso"]

semanaVegana :: Cupon
semanaVegana unaComida = verSiTiene listaNoVegana unaComida (flip (/) 2)

verSiTiene :: [String] -> Comida -> (Float -> Float) -> Comida
verSiTiene lista unaComida descuento
  | tieneIngredientesDe lista unaComida = unaComida
  | otherwise = editarCosto descuento unaComida

tieneIngredientesDe :: [String] -> Comida -> Bool
tieneIngredientesDe listaingredientes unaComida = any (flip elem listaingredientes) (ingredientes unaComida)

--2

esoNoEsCocaPapi :: String -> Cupon
esoNoEsCocaPapi bebida unaComida = editarNombreComida (++ bebida) . editarIngredientes ((:) bebida) $ unaComida

--3
sinTACCis :: Cupon
sinTACCis unaComida = editarIngredientes (map (++ "libre de gluten")) unaComida

--4
findeVegetariano :: Cupon
findeVegetariano unaComida = verSiTiene ["carne"] unaComida (* 0.7)

--5
largaDistancia :: Cupon
largaDistancia unaComida = editarCosto (+ 50) . editarIngredientes (perderIngredientes) $ unaComida

perderIngredientes :: [String] -> [String]
perderIngredientes listaIngredientes = filter ((10 >) . length) listaIngredientes

--C
--1
comprarConCupones :: Persona -> Persona
comprarConCupones unaPersona = flip comprar unaPersona . (aplicarDescuentos unaPersona) $ (comidaFavorita unaPersona)

aplicarDescuentos :: Persona -> Comida -> Comida
aplicarDescuentos unaPersona unaComida = foldl1 (.) (cupones unaPersona) $ unaComida

--2
superComida :: [Comida] -> Comida
superComida conjuntoDeComidas = UnaComida (nombreSuperComida conjuntoDeComidas) (costoSuperComida conjuntoDeComidas) (ingredientesSuperComida conjuntoDeComidas)

nombreSuperComida :: [Comida] -> String
nombreSuperComida listaDeComidas = sacarVocales . concat . map nombreComida $ listaDeComidas

listaVocales :: String
listaVocales = "aeiouAEIOU"

sacarVocales :: String -> String
sacarVocales nombreConVocales = filter (not . flip elem listaVocales) nombreConVocales

costoSuperComida :: [Comida] -> Float
costoSuperComida listaDeComidas = sum . map costo $ listaDeComidas

ingredientesSuperComida :: [Comida] -> [String]
ingredientesSuperComida listaDeComidas = listaSinRepetidos . concat . map ingredientes $ listaDeComidas

listaSinRepetidos :: [String] -> [String]
listaSinRepetidos listaDeIngredientes = foldl descartarRepetidos [] listaDeIngredientes

descartarRepetidos :: [String] -> String -> [String]
descartarRepetidos lista elemento
  | elem elemento lista = lista
  | otherwise = elemento : lista

--3
compraDeluxe :: Persona -> [Comida] -> Persona
compraDeluxe unaPersona listaDeComidas = flip comprar unaPersona . superComida . filtrarComidas $ listaDeComidas

filtrarComidas :: [Comida] -> [Comida]
filtrarComidas listaDeComidas = map (editarCosto (* 2.0)) . filter ((< 400) . costo) $ listaDeComidas

--mappers

editarDinero :: (Float -> Float) -> Persona -> Persona
editarDinero funcion unaPersona = unaPersona {dinero = funcion (dinero unaPersona)}

editarCosto :: (Float -> Float) -> Comida -> Comida
editarCosto funcion unaComida = unaComida {costo = funcion (costo unaComida)}

editarNombreComida :: (String -> String) -> Comida -> Comida
editarNombreComida funcion unaComida = unaComida {nombreComida = funcion (nombreComida unaComida)}

editarIngredientes :: ([String] -> [String]) -> Comida -> Comida
editarIngredientes funcion unaComida = unaComida {ingredientes = funcion (ingredientes unaComida)}
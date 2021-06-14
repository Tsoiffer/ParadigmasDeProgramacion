import Text.Show.Functions

--Parte A

data Persona = UnaPersona
  { nombre :: String,
    calorias :: Int,
    hidratacion :: Int,
    tiempo :: Int,
    equipamientos :: [String]
  }
  deriving (Show)

type Ejercicio = Persona -> Persona

--Personas y Rutina Para hacer pruebas
tomas :: Persona
tomas = UnaPersona "Tomas" 500 80 30 ["pesa", "pesa"]
gustavo :: Persona
gustavo = UnaPersona "Gus" 300 0 30 ["pesa", "soga"]
maxi :: Persona
maxi = UnaPersona "Maxi" 300 20 50 ["soga"]

grupoPdeP :: [Persona]
grupoPdeP = [tomas,gustavo,maxi]

veinteFlexionesYCincoAbdominales :: Rutina
veinteFlexionesYCincoAbdominales = UnaRutina 20 [flexiones 20, abdominales 5]

--1
abdominales :: Int -> Ejercicio
abdominales repeticiones = perdidaDe editarCalorias repeticiones 8

--2
flexiones :: Int -> Ejercicio
flexiones repeticiones = perdidaDe editarCalorias repeticiones 16 . perdidaDe editarHidratacion  (div repeticiones 10) 2

--3
levantarPesas :: Int -> Int -> Ejercicio
levantarPesas repeticiones peso unaPersona = cumpleCon tienePesa (perdidaDe editarCalorias repeticiones 32) (perdidaDe editarHidratacion  (div repeticiones 10) peso) unaPersona


--4
laGranHomeroSimpson :: Ejercicio
laGranHomeroSimpson = id

--Acciones
type Accion = Persona -> Persona

--1
renovarEquipo :: Accion
renovarEquipo = editarEquipamientos equipoNuevo 

--2
volverseYoguista :: Accion
volverseYoguista = editarEquipamientos (const ["colchoneta"]) . editarCalorias (flip div 2) . editarHidratacion (*2)

--3
volverseBodyBuilder :: Accion
volverseBodyBuilder unaPersona = cumpleCon esBodyBuilder (editarNombre (++"BB")) (editarCalorias (*2)) unaPersona

--4
comerUnSandwich :: Accion
comerUnSandwich = editarCalorias (+500) . editarHidratacion (+100)

--Parte B
data Rutina = UnaRutina
  { 
    tiempoRutina :: Int,
    ejerciciosRutina :: [Ejercicio]
  }
  deriving (Show)

esPeligrosa :: Rutina -> Persona -> Bool
esPeligrosa rutina unaPersona = quedoAgotado .ejecutarRutina rutina $ unaPersona
esBalanceada :: Rutina -> Persona -> Bool
esBalanceada rutina unaPersona = quedoBalanceado (calorias unaPersona) .ejecutarRutina rutina $ unaPersona

elAbominableAbdominal :: Rutina
elAbominableAbdominal = UnaRutina 60 infinitosAbdominales

infinitosAbdominales :: [Ejercicio]
infinitosAbdominales = map abdominales [1,2..]

--Parte C
--1
seleccionarGrupoDeEjercicio :: Persona -> [Persona] ->[Persona]
seleccionarGrupoDeEjercicio unaPersona unasPersonas = filter (tienenElMismoTiempo unaPersona) unasPersonas

--2

promedioDeRutina :: Rutina -> [Persona] -> (Int,Int)
promedioDeRutina rutina unasPersonas =  promedioDeCaloriasYHidratacion .map (ejecutarRutina rutina) $ unasPersonas

--Auxiliares
perdidaDe :: ((Int->Int) -> Persona -> Persona) -> Int -> Int -> Persona -> Persona
perdidaDe mapper repeticiones caloriasPerdidas  = mapper (subtract (repeticiones*caloriasPerdidas))

tienePesa :: Persona -> Bool
tienePesa unaPersona = elem "pesa" (equipamientos unaPersona)

equipoNuevo :: [String]->[String]
equipoNuevo listaDeEquipo = map ("Nuevo"++) listaDeEquipo

menorHidraracionMaxima :: (Int->Int) -> Persona -> Bool
menorHidraracionMaxima funcion unaPersona = funcion (hidratacion unaPersona) < 100

esBodyBuilder :: Persona -> Bool
esBodyBuilder unaPersona = all ("pesa"==) (equipamientos unaPersona)

quedoAgotado :: Persona -> Bool
quedoAgotado unaPersona = calorias unaPersona < 50 && hidratacion unaPersona < 10

ejecutarRutina :: Rutina -> Persona -> Persona
ejecutarRutina unaRutina unaPersona
 | alcanzaEltiempo (tiempoRutina unaRutina) unaPersona = foldl1 (.)  (ejerciciosRutina unaRutina) $ unaPersona
 | otherwise = unaPersona

alcanzaEltiempo :: Int -> Persona -> Bool
alcanzaEltiempo tiempodeRutina unaPersona = tiempodeRutina < tiempo unaPersona

quedoBalanceado :: Int -> Persona -> Bool
quedoBalanceado  caloriasAntes unaPersona = calorias unaPersona < (div caloriasAntes 2) && hidratacion unaPersona > 80

tienenElMismoTiempo :: Persona -> Persona -> Bool
tienenElMismoTiempo unaPersona otraPersona = tiempo unaPersona == tiempo otraPersona

promedioDeCaloriasYHidratacion :: [Persona] -> (Int,Int)
promedioDeCaloriasYHidratacion unasPersonas = (promedioDe calorias unasPersonas,promedioDe hidratacion unasPersonas)

promedioDe :: (Persona -> Int) -> [Persona] -> Int
promedioDe funcion unasPersonas =  div (sum .map funcion $ unasPersonas) (length unasPersonas)

cumpleCon :: (Persona -> Bool) -> Accion -> Accion -> Ejercicio
cumpleCon condicion accion1 accion2 unaPersona
 | condicion unaPersona = accion1 . accion2 $ unaPersona
 | otherwise = unaPersona
--mappers

editarCalorias :: (Int->Int) -> Persona -> Persona
editarCalorias funcion unaPersona = unaPersona {calorias = funcion (calorias unaPersona)}

editarHidratacion :: (Int->Int) -> Persona -> Persona
editarHidratacion funcion unaPersona 
 | menorHidraracionMaxima funcion unaPersona = unaPersona {hidratacion = funcion (hidratacion unaPersona)}
 | otherwise = unaPersona {hidratacion = 100}

editarEquipamientos :: ([String]->[String]) -> Persona -> Persona
editarEquipamientos funcion unaPersona = unaPersona {equipamientos = funcion (equipamientos unaPersona)}

editarNombre :: (String->String) -> Persona -> Persona
editarNombre funcion unaPersona = unaPersona {nombre = funcion (nombre unaPersona)}
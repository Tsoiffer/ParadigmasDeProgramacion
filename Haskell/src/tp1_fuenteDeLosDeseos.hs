import Text.Show.Functions

type Sueño = Persona -> Persona

type Ciudad = String

data Persona = UnaPersona
  { edad :: Int,
    sueñosAcumplir :: [Sueño],
    nombre :: String,
    felicidonios :: Int,
    habilidades :: [String]
  }
  deriving (Show)

lucas :: Persona
lucas = UnaPersona 22 [(recibirseDeUnaCarrera "Sistemas"), (enamorarseDe carolina), (todoSigaIgual)] "Lucas" 150 ["juagar Jueguitos", "estudiar paradigmas"]

tomas :: Persona
tomas = UnaPersona 26 [(recibirseDeUnaCarrera "Sistemas"), (viajarA ["Lanu", "España"])] "Tomas Soiffer" 65 ["juagar Jueguitos", "Tocar la guitarra"]

eduardo :: Persona
eduardo = UnaPersona 24 [comboPerfecto] "Eduardo" 23 ["juagar Futbol", "Tocar el bajo", "Leer libros"]

carolina :: Persona
carolina = UnaPersona 32 [(recibirseDeUnaCarrera "Psicologa"), (viajarA ["Indonesia", "Madrid"])] "Carolina" 100 ["Corredora", "Tocar la guitarra", "Contadora"]

--PUNTO 1
--A Coeficiente de Satisfaccion

cantidadSueñosACumplir :: Persona -> Int
cantidadSueñosACumplir = length . sueñosAcumplir

verificacionDeFelicidonios :: Persona -> (Persona -> Int) -> (Persona -> Int) -> (Persona -> Int) -> Int
verificacionDeFelicidonios unaPersona funcion1 funcion2 funcion3
  | felicidonios unaPersona > 100 = (funcion1 unaPersona) * (felicidonios unaPersona)
  | felicidonios unaPersona > 50 = (funcion2 unaPersona) * (cantidadSueñosACumplir unaPersona)
  | otherwise = funcion3 unaPersona

coeficienteDeSatisfaccion :: Persona -> Int
coeficienteDeSatisfaccion unaPersona = verificacionDeFelicidonios unaPersona edad felicidonios ((flip div 2) . felicidonios)

--B Grado de ambicion

gradoDeAmbicion :: Persona -> Int
gradoDeAmbicion unaPersona = verificacionDeFelicidonios unaPersona cantidadSueñosACumplir edad ((* 2) . cantidadSueñosACumplir)

--PUNTO 2
--A
-- Usamos aplicacion parcial con (10<) y componemos con el resto de las funciones
nombreLargo :: Persona -> Bool
nombreLargo unaPersona = (> 10) . length . nombre $ unaPersona

--B
-- Usamos aplicacion parcial con (3*) y componemos con el resto de las funciones
personaSuertuda :: Persona -> Bool
personaSuertuda unaPersona = even . (3 *) . coeficienteDeSatisfaccion $ unaPersona

--C
-- Usamos aplicacion parcial con (== 'a') y componemos con el resto de las funciones

nombreLindo :: Persona -> Bool
nombreLindo unaPersona = (== 'a') . last . nombre $ unaPersona

--PUNTO 3

-- Item 1:
recibirseDeUnaCarrera :: String -> Persona -> Persona
recibirseDeUnaCarrera unaCarrera unaPersona = modificarFelicidoniosAPersona (+ (felicidoniosOtorgadosXLista 1000 unaCarrera)) . (modificarHabilidades (++ [unaCarrera])) $ unaPersona

-- Item 2:

-- Adiciona puntos felicidonios  a determinada  persona por las ciudades que visito
viajarA :: [Ciudad] -> Persona -> Persona
viajarA listaDeCiudadesVisitadas unaPersona = modificarEdad (+ 1) . modificarFelicidoniosAPersona (+ (felicidoniosOtorgadosXLista 100 listaDeCiudadesVisitadas)) $ unaPersona

-- Item 3
-- Adiciona a una primera persona los puntos de una segunda si el sueño a cumplir de la primera es "seEmoroDE" (no bidireccional)
enamorarseDe :: Persona -> Persona -> Persona
enamorarseDe platonica enamorado = modificarFelicidoniosAPersona (+ felicidonios platonica) enamorado

-- Item 4
-- Devuelve la misma persona que tiene ese sueño
todoSigaIgual :: Sueño
todoSigaIgual = id

-- Item 5
-- Se realiza el combo perfecto, se recibe de la carrera de "Medicina", viaja a "Berazategui" y "París"

comboPerfecto :: Sueño
comboPerfecto unaPersona = modificarFelicidoniosAPersona (+ 100) . (viajarA ["Berazategui", "Paris"]) . (recibirseDeUnaCarrera "Medicina") $ unaPersona

--funciones Auxiliares

felicidoniosOtorgadosXLista :: Int -> [a] -> Int
felicidoniosOtorgadosXLista puntosXElemento lista = ((* puntosXElemento) . length) lista

-- Mappers
modificarFelicidoniosAPersona :: (Int -> Int) -> Persona -> Persona
modificarFelicidoniosAPersona funcion unaPersona = unaPersona {felicidonios = funcion . felicidonios $ unaPersona}

modificarEdad :: (Int -> Int) -> Persona -> Persona
modificarEdad funcion unaPersona = unaPersona {edad = funcion . edad $ unaPersona}

modificarHabilidades :: ([String] -> [String]) -> Persona -> Persona
modificarHabilidades funcion unaPersona = unaPersona {habilidades = funcion . habilidades $unaPersona}

modificarSueños :: ([Sueño] -> [Sueño]) -> Persona -> Persona
modificarSueños funcion unaPersona = unaPersona {sueñosAcumplir = funcion . sueñosAcumplir $ unaPersona}

----------------------------------------------------------------------------------
--casos de prueba
eugenia :: Persona
eugenia = UnaPersona 22 [(recibirseDeUnaCarrera "deseñoDeinteriores"), (viajarA ["Paris"]), (enamorarseDe manuel)] "Eugenia" 5000 ["juagar Jueguitos", "estudiar paradigmas"]

manuel :: Persona
manuel = UnaPersona 22 [] "Manuel" 15 ["jugar Jueguitos", "estudiar paradigmas"]

martina :: Persona
martina = UnaPersona 22 [comboPerfecto, recibirseDeUnaCarrera "medicina", enamorarseDe mateo, viajarA ["Barcelona"]] "Martina" 500 ["jugar Jueguitos", "estudiar paradigmas"]

mateo :: Persona
mateo = UnaPersona 22 [] "Mateo" 0 ["jugar Jueguitos", "estudiar paradigmas"]

type Fuente = Persona -> Persona

--PUNTO 4

--A
fuenteMinimalista :: Fuente
fuenteMinimalista unaPersona = retirarPrimerSueño . cumplirPrimerSueño $ unaPersona

cumplirPrimerSueño :: Persona -> Persona
cumplirPrimerSueño unaPersona = head (sueñosAcumplir unaPersona) unaPersona

retirarPrimerSueño :: Persona -> Persona
retirarPrimerSueño unaPersona = modificarSueños tail unaPersona

--B
--version 1 con recursividad
fuenteCopada :: Fuente
fuenteCopada persona
  | (length (sueñosAcumplir persona)) == 0 = persona
  | otherwise = fuenteCopada . fuenteMinimalista $ persona

--version 2 sin recursividad
fuenteCopadaV2 :: Fuente
fuenteCopadaV2 unaPersona = retirarSueños . cumplirSueños $ unaPersona

cumplirSueños :: Persona -> Persona
cumplirSueños unaPersona = foldr ($) unaPersona (sueñosAcumplir unaPersona)

retirarSueños :: Persona -> Persona
retirarSueños unaPersona = modificarSueños (const []) unaPersona

--C
fuenteAPedido :: Int -> Fuente
fuenteAPedido numeroDeSueño persona = ((sueñosAcumplir persona) !! numeroDeSueño) persona

--D
fuenteSorda :: Fuente
fuenteSorda = id

--PUNTO 5
listaDeFuentes :: [(Fuente)]
listaDeFuentes = [fuenteAPedido 0, fuenteCopada, fuenteMinimalista, fuenteSorda]

fuenteDeMasFelicidonios :: Persona -> [Fuente] -> (Fuente)
fuenteDeMasFelicidonios persona fuentes = compararFuente persona fuentes (>) (felicidonios)

fuenteDeMenosFelicidonios :: Persona -> [Fuente] -> (Fuente)
fuenteDeMenosFelicidonios persona fuentes = compararFuente persona fuentes (<) (felicidonios)

fuenteDeMasHabilidades :: Persona -> [Fuente] -> (Fuente)
fuenteDeMasHabilidades persona fuentes = compararFuente persona fuentes (>) (length . habilidades)

compararFuente :: Persona -> [Fuente] -> (Int -> Int -> Bool) -> (Persona -> Int) -> (Fuente)
compararFuente persona fuentes comparacion funcion = foldl1 (fuenteGanadora comparacion funcion persona) fuentes

fuenteGanadora :: (Int -> Int -> Bool) -> (Persona -> Int) -> Persona -> (Fuente) -> (Fuente) -> (Fuente)
fuenteGanadora comparacion queSeCompara persona fuente1 fuente2
  | comparacion (queSeCompara . fuente1 $ persona) (queSeCompara . fuente2 $ persona) = fuente1
  | otherwise = fuente2

-- Para invocar cualquiera de las 3 funciones se debe enviar la persona y luego la lista de fuentes (en este caso se puede usar listaDeFuentes)  esto de vuelvue una Fuente(que es una funcionion de Persona -> Persona).
-- Si luego se utiliza $ con la persona nuevamente. Esto devuelve una persona con la fuente que corresponda según el criterio aplicada.

--PUNTO 6
-- ver verificar sueños valiosos es que tiene que tener la persona mas de 100 felicidonios, no la diferencia
sueñosValiosos :: Persona -> [Sueño]
sueñosValiosos unaPersona = filter (verificarSueño (> 100) unaPersona) (sueñosAcumplir unaPersona)

verificarSueño :: (Int -> Bool) -> Persona -> Sueño -> Bool
verificarSueño condicion unaPersona unSueño = condicion . diferenciaFelicidad unaPersona $ unSueño

diferenciaFelicidad :: Persona -> Sueño -> Int
diferenciaFelicidad unaPersona sueñoACumplir = subtract (felicidonios unaPersona) . felicidonios . sueñoACumplir $ unaPersona

--VerificarSueñosValiosos es de Orden superior por que recibe Sueño que es una funcion de Persona -> Persona
--Utilizamos aplicacion parcial en "(>100)" "(subtract (felicidonios unaPersona))" "(verificarSueñosValiosos unaPersona)"

sueñoRaro :: Persona -> Bool
sueñoRaro unaPersona = any (verificarSueño (== 0) unaPersona) (sueñosAcumplir unaPersona)

felicidadDelGrupo :: [Persona] -> Int
felicidadDelGrupo listaDePersonas = sum . (map (felicidonios . fuenteCopada)) $ listaDePersonas

--PUNTO 7

soñadorInfinito :: Persona
soñadorInfinito = UnaPersona 22 listaInfinita "Infinito" 150 ["estudiar paradigmas"]

listaInfinita :: [Sueño]
listaInfinita = map deCaracterASueño ['a', 'b' ..]

deCaracterASueño :: Char -> Sueño
deCaracterASueño caracter = recibirseDeUnaCarrera [caracter]

--fuenteMinimalista:
--fuenteMinimalista, le cumple el primer sueño y se lo retira a la persona y devuelve la persona con su lista de sueños infinita por lo cual queda imprimiendo en pantalla la lista infinita a menos que se interrupa la ejecucion.
--Se puede verificar que ejecuta la fuente ejecutando en la terminal: felicidonios.fuenteMinimalista $soñadorInfinito

--fuenteCopada:
--fuenteCopada, como la lista de sueños es infinita se queda ejecutando infinitos sueños y nunca termina.

--fuenteAPedido:
--fuenteAPedido, le cumple el enésimo sueño y devuelve la persona con su lista de sueños infinita por lo cual queda imprimiendo en pantalla la lista infinita a menos que se interrupa la ejecucion.
--Se puede verificar que ejecuta la fuente. Mando en la terminal: felicidonios.fuenteAPedido 5 $soñadorInfinito

--fuenteSorda:
--fuenteSorda,devuelve la persona sin cumplir ningun sueño con su lista de sueños infinita por lo cual queda imprimiendo en pantalla la lista infinita a menos que se interrupa la ejecucion.
--Se puede verificar que ejecuta la fuente. Mando en la terminal: nombre.fuenteSorda $soñadorInfinito

--Conclusion:

--El uso de Lazy Evaluation (Va de las funciones a los argumentos) en lugar de Eager Evaluation (Debe resolver los argumentos para poder aplicar la función)...
-- ...nos permite ejecutar todas las funciones ya que evalua solo los parametros que solicita la funcion, ...
-- ...entonces ejecuta la funcion sin la necesidad que la persona envie la lista infinita (esto si sucederia en Eager Evaluation quedando armando la lista infinita de sueños antes de ejecutar la funcion).
-- En el caso de la fuenteCopada podemos confirmar que queda en un loop de ejecucion infinito, ya que es recursiva con la fuenteMinimalista que se demostro que si se ejecuta.

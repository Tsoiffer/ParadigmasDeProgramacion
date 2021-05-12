data Persona = UnaPersona {
    edad:: Int,
    sueñosAcumplir:: [String],
    nombre:: String,
    felicidonios:: Int,
    habilidades:: [String]
} deriving (Show,Eq)

lucas :: Persona
lucas = UnaPersona 22 ["recibirte de sistemas","ganar el quini"] "Lucas" 150 ["juagar Jueguitos", "estudiar paradigmas"]
tomas :: Persona
tomas = UnaPersona 26 ["recibirte de sistemas","san lorenzo en Boedo"] "Tomas Soiffer" 65 ["juagar Jueguitos", "Tocar la guitarra"]
eduardo :: Persona
eduardo = UnaPersona 24 ["recibirte de sistemas","recibirte de electronica"] "Eduardo" 23 ["juagar Futbol", "Tocar el bajo", "Leer libros"]
carolina :: Persona
carolina = UnaPersona 32 ["recibirte de sistemas"] "Carolina" 100 ["Corredora", "Tocar la guitarra", "Contadora"]


--PUNTO 1
--A Coeficiente de Satisfaccion

coeficienteDeSatisfaccion :: Persona -> Int
coeficienteDeSatisfaccion  unaPersona
    | felicidonios unaPersona > 100 = edad unaPersona * felicidonios unaPersona
    | felicidonios unaPersona > 50  = felicidonios unaPersona * (length.sueñosAcumplir)  unaPersona 
    | otherwise = div (felicidonios unaPersona) 2

--B Grado de ambicion

gradoDeAmbicion :: Persona -> Int
gradoDeAmbicion  unaPersona
    | felicidonios unaPersona > 100 = felicidonios unaPersona * (length.sueñosAcumplir)  unaPersona 
    | felicidonios unaPersona > 50  = edad unaPersona * (length.sueñosAcumplir)  unaPersona
    | otherwise = (length.sueñosAcumplir) unaPersona * 2

--PUNTO 2
--A
-- Usamos aplicacion parcial con (10<) y componemos con el resto de las funciones
nombreLargo :: Persona -> Bool
nombreLargo unaPersona = (10<).length.nombre $ unaPersona

--B
-- Usamos aplicacion parcial con (3*) y componemos con el resto de las funciones
personaSuertuda :: Persona -> Bool
personaSuertuda unaPersona = even.(3*).coeficienteDeSatisfaccion $ unaPersona

--C
--
nombreLindo :: Persona -> Bool
nombreLindo unaPersona = (== 'a').head.reverse.nombre $ unaPersona 

--PUNTO 3


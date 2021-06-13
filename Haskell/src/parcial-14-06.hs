import Text.Show.Functions

type Objeto = Barbaro -> Barbaro

data Algo = Algo
  { nombre :: String,
    fuerza :: Float,
    habilidades :: [String],
    objetos :: [Objeto]
  }
  deriving (Show)

--mappers
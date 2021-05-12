type Titulo = String
type Autor = String
type CantidadDePaginas = Int
type Libro = (Titulo, Autor, CantidadDePaginas)

elVisitante :: Libro
elVisitante = ("el visitante", "Stephen King", 592)

shingekiNoKyojin1 :: Libro
shingekiNoKyojin1 = ("shingeki no kyojin 1 ", "Hajime Isayama", 40)

type Biblioteca = [Libro]
biblioteca :: Biblioteca
biblioteca = [elVisitante, shingekiNoKyojin1]

-- 1

promedioDePaginas :: Biblioteca -> Int
promedioDePaginas unaBiblioteca = div (cantidadDePaginasTotales unaBiblioteca) (length unaBiblioteca)

cantidadDePaginasTotales :: Biblioteca -> Int
cantidadDePaginasTotales unaBiblioteca = sum . map cantidadDePaginas $ unaBiblioteca

cantidadDePaginas :: Libro -> Int
cantidadDePaginas (_, _, unasPaginas) = unasPaginas

--2
lecturaObligatoria :: Libro -> Bool
lecturaObligatoria libro = "Stephen King" == (autorDelLibro libro)  || ("Isaac Asimov" ,230 ) == (autorYCantidadDePaginas libro)

autorYCantidadDePaginas :: Libro -> (String , Int)
autorYCantidadDePaginas (_,autor ,paginas ) = (autor ,paginas )

autorDelLibro :: Libro -> String
autorDelLibro (_,autor ,_ ) = autor

--3
fantasiosa :: Biblioteca -> Bool
fantasiosa unaBiblioteca = (elem True).(map libroFantasiosio) $ unaBiblioteca

libroFantasiosio :: Libro -> Bool
libroFantasiosio (_,autor ,_ ) = (autor == "Christopher Paolini") || (autor == "Neil Gaiman")

--4
nombreDeLaBiblioteca :: Biblioteca -> String
nombreDeLaBiblioteca unaBiblioteca = concat (map librosinvocal  unaBiblioteca)

librosinvocal :: Libro -> String
librosinvocal (nombreDelLibro,_ ,_ ) = (filter( 'u' /=)).(filter( 'o' /=)).(filter( 'i' /=)).(filter( 'e' /=)).(filter( 'a' /=)) $ nombreDelLibro
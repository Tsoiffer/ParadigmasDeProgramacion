module Lib
    ( someFunc
    ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"
precioTotal :: Fractional a => a->a->a->a->a
precioTotal precioUnitario cantidad descuento envio = aplicarCostoDeEnvio envio  (cantidad * (aplicarDescuento precioUnitario descuento))
productoCorriente :: String -> Bool
productoCorriente nombreProducto =  elem (head nombreProducto) ['a','e','i','o','u']
productoDeElite :: String -> Bool
productoDeElite nombreProducto = not . productoCorriente $ nombreProducto
aplicarDescuento :: Fractional a => a->a->a
aplicarDescuento precio descuento = precio * (100-descuento)/100
entregaSencilla :: String -> Bool
entregaSencilla diaDeEntrega = even.length $ diaDeEntrega
descodiciarProducto :: String -> String
descodiciarProducto nombreProducto = take 10 nombreProducto
productoCodiciado :: String -> Bool
productoCodiciado nombreProducto = 10 < length nombreProducto
productoDeLujo :: String -> Bool
productoDeLujo  nombreProducto = elem 'z' nombreProducto || elem 'x' nombreProducto
aplicarCostoDeEnvio :: Num a => a->a->a
aplicarCostoDeEnvio precio costoDeEnvio = precio + costoDeEnvio
productoXL :: String -> String
productoXL nombreProducto = nombreProducto ++ "XL"
versionBarata :: String -> String
versionBarata = reverse . descodiciarProducto


--take :: Int->String->String
--drop :: Int->String->String
--head :: String->Char
--elem :: Char->String->Bool
--reverse :: String->String
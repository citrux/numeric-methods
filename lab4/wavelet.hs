import Data.Complex;
import Text.Printf;

main = printTable [0.01, 0.02 .. 0.99] [0.01, 0.02 .. 0.99]

printTable [] ys = putStrLn ""
printTable (x:xs) ys = do
        printRow x ys
        printTable xs ys

printRow x [] = putStrLn ""
printRow x (y:ys) = do
        printf "%f %f %f\n" x y (s x y)
        printRow x ys

alpha = 0.5 :: Double
k0 = 0.1    :: Double
n = 100     :: Integer

f :: Double -> Double
f x = sin x

morle :: Double -> Complex Double
morle t = (exp x) * ((exp y) - (exp z))
    where
        x = - toComplex ((t / alpha) ** 2)
        y = (0:+1) * toComplex (k0 * t)
        z = - toComplex ((k0 * alpha / 2) ** 2)

psi = morle

transform :: [Double] -> Double -> Double -> Complex Double
transform ts a b = sum scal_prods / norm
    where
        scal_prod t = (toComplex $ f t) * (conjugate $ psi ((t - b) / a))
        scal_prods = map scal_prod ts
        norm = toComplex $ sum $ map (\t -> exp (-((t - b) / a / alpha) ** 2)) ts

toComplex :: Double -> Complex Double
toComplex x = x :+ 0

toDouble :: Complex Double -> Double
toDouble (x :+ _) = x

ts :: [Double]
ts = map (\i -> fromInteger i / fromInteger n) [0 .. n - 1]

w = transform ts

s :: Double -> Double -> Double
s a b = toDouble $ abs(w a b) ** 2

import Data.Complex;
import Text.Printf;

main = printTable [0.1, 0.15 .. 2] [0.01, 0.02 .. 0.99]

printTable [] ys = putStrLn ""
printTable (x:xs) ys = do
        printRow x ys
        printTable xs ys

printRow x [] = putStrLn ""
printRow x (y:ys) = do
        printf "%f %f %f\n" x y (s x y)
        printRow x ys

f :: Double -> Double
{-f x = exp t where t = -2 * (x - 0.5) ** 2-}
f x
    {-| (abs(x-0.5) < 0.1) = sin (2 * pi * x)-}
    | (abs(x-0.3) < 0.1) = cos (pi * x / 4)
    | otherwise          = 0

morle :: Double -> Double -> Double -> Complex Double
morle alpha k0 t = (exp x) * ((exp y) - (exp z))
    where
        x = - toComplex ((t / alpha) ** 2)
        y = (0:+1) * toComplex (k0 * t)
        z = - toComplex ((k0 * alpha / 2) ** 2)

psi = morle 0.5 (2 * pi)

transform :: [Double] -> Double -> Double -> Complex Double
transform ts a b = sum scal_prods / norm
    where
        scal_prod t = (toComplex . f) t * (conjugate . psi) ((t - b) / a)
        scal_prods = map scal_prod ts
        norm = (toComplex . sum) $ map (\t -> exp (-((t - b) / a / 0.5) ** 2)) ts

toComplex :: Double -> Complex Double
toComplex x = x :+ 0

cabs :: Complex Double -> Double
cabs x = t where (t, a) = polar x

ts :: [Double]
ts = map (\i -> i / 99) [0 .. 99]

w = transform ts

s :: Double -> Double -> Double
s a b = cabs(w a b) ** 2

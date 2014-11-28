module Wavelet where

import Data.Complex;

morle :: RealFloat a => a -> a -> a -> Complex a
morle alpha k0 t = (exp x) * ((exp y) - (exp z))
    where
        x = - toComplex ((t / alpha) ** 2)
        y = (0:+1) * toComplex (k0 * t)
        z = - toComplex ((k0 * alpha / 2) ** 2)

transform :: RealFloat a => [a] -> (a -> Complex a) -> a -> a -> Complex a
transform xs wavelet scale time = sum scal_prods / norm
    where
        n = length xs
        scal_prods = zipWith (*) (map toComplex xs) ws
        ts = map (\t -> fromIntegral t / fromIntegral n) [0 .. n - 1]
        ws = map (\t -> conjugate $ wavelet $ (t - time) / scale) ts
        norm = (toComplex . sum) $ map (\t -> exp (-((t - time) / scale / 0.5) ** 2)) ts

toComplex :: RealFloat a => a -> Complex a
toComplex x = x :+ 0

cabs :: RealFloat a => Complex a -> a
cabs x = t
    where (t, _) = polar x

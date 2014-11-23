extern crate num;
use num::complex::Complex;
use num::complex::Complex64;

fn main() {
    let n = 8u;
    let a: Vec<Complex64> = Vec::from_fn(n, |idx| Complex::new(signal(idx, n), 0.0));
    println!("{}", fft(a));
}

fn fft(xs: Vec<Complex64>) -> Vec<Complex64> {
    if xs.len() == 1 {return xs};
    let mut ys = Vec::new();
    ys.push_all(xs.as_slice());
    let pi = std::f64::consts::PI;
    let mut x0 = Vec::new();
    let mut x1 = Vec::new();
    let n = match xs.len().to_f64() {Some(m) => m, None => 0f64};
    let wn = Complex::from_polar(&1.0, &(2.0f64 * pi / n));
    let mut w = Complex::new(1.0f64, 0.0f64);
    for i in range(0u, xs.len()) {
        if i % 2 == 0 {
            x0.push(xs[i]);
        } else {
            x1.push(xs[i]);
        }
    }

    let y0 = fft(x0);
    let y1 = fft(x1);

    for i in range(0u, xs.len() / 2u) {
        *ys.get_mut(i) = y0[i] + w * y1[i];
        *ys.get_mut(i + xs.len() / 2u) = y0[i] - w * y1[i];
        w = w * wn;
    }
    return ys;
}

fn signal(i: uint, n: uint) -> f64 {
    let x = match i.to_f64() { Some(m) => m, None => 0f64 };
    let y = match n.to_f64() { Some(m) => m, None => 0f64 };
    let pi = std::f64::consts::PI;
    return (2.0f64 * pi * x / y).sin();
}

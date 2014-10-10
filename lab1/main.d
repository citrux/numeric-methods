module main;

import integral;

import std.stdio;
import std.math;

void test(real function(real) f, real left, real right, size_t n)
{
    writeln("lagrange       : ", lagrange!f(left, right, n));
    writeln("polynomial     : ", polynomial!f(left, right, n));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, n));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, n));
    writeln("tanh-sinh      : ", tanhSinh!f(left, right, n));
    writeln();
}

void demo()
{
    real left = 0, right = 4;
    size_t n;

    auto f = function(real x){return 1 / sqrt(x);};
    n = 5;
    writeln("int_0^4 1 / sqrt(x) dx по 5 точкам: ");
    test(f, left, right, n);

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    n = 3;
    writeln("int_0^4 1 / sqrt(x(4-x)) dx по 3 точкам: ");
    test(f, left, right, n);

    f = function(real x){return sqrt(x * (4 - x));};
    n = 3;
    writeln("int_0^4 sqrt(x(4-x)) dx по 3 точкам: ");
    test(f, left, right, n);

    f = function(real x){return sqrt(x);};
    n = 15;
    writeln("int_0^4 sqrt(x) dx по 15 точкам: ");
    test(f, left, right, n);

    f = function(real x){return x;};
    n = 2;
    writeln("int_0^4 x dx по 2 точкам: ");
    test(f, left, right, n);

    f = function(real x){return 1;};
    n = 15;
    writeln("int_0^4 dx по 15 точкам: ");
    test(f, left, right, n);

    f = function(real x){return 1 + x + x * x + x * x * x;};
    n = 2;
    writeln("int_0^4 x^3 + x^2 + x + 1 dx по 2 точкам: ");
    test(f, left, right, n);

    f = function(real x){return log(x);};
    n = 10;
    writeln("int_0^1 ln x dx по 10 точкам: ");
    test(f, left, 1, n);

    f = function(real x){return log(x) / sqrt(x);};
    n = 10;
    writeln("int_0^1 ln x / sqrt(x) dx по 10 точкам: ");
    test(f, left, 1, n);
}


void demoAdaptive()
{
    real left = 0, right = 4, precision = 1e-3;

    writeln("Адаптивные методы с точностью ", precision);
    auto f = function(real x){return 1 / sqrt(x);};
    writeln("int_0^4 1 / sqrt(x) dx");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    writeln("int_0^4 1 / sqrt(x(4-x)) dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return sqrt(x * (4 - x));};
    writeln("int_0^4 sqrt(x(4-x)) dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return x;};
    writeln("int_0^4 x dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return 1;};
    writeln("int_0^4 dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return 1 + x + x * x + x * x * x;};
    writeln("int_0^4 x^3 + x^2 + x + 1 dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return log(x);};
    right = 1;
    writeln("int_0^1 ln x dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();

    f = function(real x){return log(x) / sqrt(x);};
    writeln("int_0^1 ln x / sqrt(x) dx: ");
    writeln("leftRectangles   : ", integrate!(leftRectangles, f)(left, right, precision));
    //writeln("rightRectangles  : ", integrate!(rightRectangles, f)(left, right, precision));
    //writeln("middleRectangles : ", integrate!(middleRectangles, f)(left, right, precision));
    writeln("trapezoids       : ", integrate!(trapezoids, f)(left, right, precision));
    writeln("parabolas        : ", integrate!(parabolas, f)(left, right, precision));
    writeln("polynomial       : ", integrate!(polynomial, f)(left, right, precision));
    writeln("lagrange         : ", integrate!(lagrange, f)(left, right, precision));
    writeln("gaussLejendre    : ", integrate!(gaussLejendre, f)(left, right, precision));
    writeln("gaussChebyshev   : ", integrate!(gaussChebyshev, f)(left, right, precision));
    writeln("tanhSinh         : ", integrate!(tanhSinh, f)(left, right, precision));
    writeln();
}


void main()
{
    demo();
    demoAdaptive();
}


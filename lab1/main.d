module main;

import integral;

import std.stdio;
import std.math;

void demo()
{
    real left = 0, right = 4;

    auto f = function(real x){return 1 / sqrt(x);};
    writeln("int_0^4 1 / sqrt(x) dx по 5 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 5));
    writeln("polynomial     : ", polynomial!f(left, right, 5));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 5));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 5));
    writeln();

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    writeln("int_0^4 1 / sqrt(x(4-x)) dx по 3 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 3));
    writeln("polynomial     : ", polynomial!f(left, right, 3));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 3));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 3));
    writeln();

    f = function(real x){return sqrt(x * (4 - x));};
    writeln("int_0^4 sqrt(x(4-x)) dx по 3 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 3));
    writeln("polynomial     : ", polynomial!f(left, right, 3));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 3));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 3));
    writeln();

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx по 15 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 15));
    writeln("polynomial     : ", polynomial!f(left, right, 15));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 15));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 15));
    writeln();

    f = function(real x){return x;};
    writeln("int_0^4 x dx по 2 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 2));
    writeln("polynomial     : ", polynomial!f(left, right, 2));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 2));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 2));
    writeln();

    f = function(real x){return 1;};
    writeln("int_0^4 dx по 15 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 15));
    writeln("polynomial     : ", polynomial!f(left, right, 15));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 15));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 15));
    writeln();

    f = function(real x){return 1 + x + x * x + x * x * x;};
    writeln("int_0^4 x^3 + x^2 + x + 1 dx по 2 точкам: ");
    writeln("lagrange       : ", lagrange!f(left, right, 2));
    writeln("polynomial     : ", polynomial!f(left, right, 2));
    writeln("gaussLejendre  : ", gaussLejendre!f(left, right, 2));
    writeln("gaussChebyshev : ", gaussChebyshev!f(left, right, 2));
    writeln();
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
    writeln();
}


void main()
{
    demo();
    demoAdaptive();
}


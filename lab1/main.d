module main;

import std.stdio;
import std.math;
import integral;


void demo()
{
    real left = 0, right = 4;

    auto f = function(real x){return 1 / sqrt(x);};
    writeln("int_0^4 1 / sqrt(x) dx по 5 точкам: ");
    writeln("lagrange       : ", lagrange(5)(f, left, right));
    writeln("polynomial     : ", polynomial(5)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(5)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(5)(f, left, right));
    writeln();

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    writeln("int_0^4 1 / sqrt(x(4-x)) dx по 3 точкам: ");
    writeln("lagrange       : ", lagrange(3)(f, left, right));
    writeln("polynomial     : ", polynomial(3)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(3)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(3)(f, left, right));
    writeln();

    f = function(real x){return sqrt(x * (4 - x));};
    writeln("int_0^4 sqrt(x(4-x)) dx по 3 точкам: ");
    writeln("lagrange       : ", lagrange(3)(f, left, right));
    writeln("polynomial     : ", polynomial(3)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(3)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(3)(f, left, right));
    writeln();

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx по 15 точкам: ");
    writeln("lagrange       : ", lagrange(15)(f, left, right));
    writeln("polynomial     : ", polynomial(15)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(15)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(15)(f, left, right));
    writeln();

    f = function(real x){return x;};
    writeln("int_0^4 x dx по 2 точкам: ");
    writeln("lagrange       : ", lagrange(2)(f, left, right));
    writeln("polynomial     : ", polynomial(2)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(2)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(2)(f, left, right));
    writeln();

    f = function(real x){return 1;};
    writeln("int_0^4 dx по 15 точкам: ");
    writeln("lagrange       : ", lagrange(15)(f, left, right));
    writeln("polynomial     : ", polynomial(15)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(15)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(15)(f, left, right));
    writeln();

    f = function(real x){return 1 + x + x * x + x * x * x;};
    writeln("int_0^4 x^3 + x^2 + x + 1 dx по 2 точкам: ");
    writeln("lagrange       : ", lagrange(2)(f, left, right));
    writeln("polynomial     : ", polynomial(2)(f, left, right));
    writeln("gaussLejendre  : ", gaussLejendre(2)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(2)(f, left, right));
    writeln();
}


void demoAdaptive()
{
    real left = 0, right = 4, precision = 1e-3;

    writeln("Адаптивные методы с точностью ", precision);
    auto f = function(real x){return 1 / sqrt(x);};
    writeln("int_0^4 1 / sqrt(x) dx");
    //writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    //writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    //writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    //writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    writeln("int_0^4 1 / sqrt(x(4-x)) dx: ");
    //writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    //writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    //writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    //writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();

    f = function(real x){return sqrt(x * (4 - x));};
    writeln("int_0^4 sqrt(x(4-x)) dx: ");
    writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx: ");
    writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();

    f = function(real x){return x;};
    writeln("int_0^4 x dx: ");
    writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();

    f = function(real x){return 1;};
    writeln("int_0^4 dx: ");
    writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();

    f = function(real x){return 1 + x + x * x + x * x * x;};
    writeln("int_0^4 x^3 + x^2 + x + 1 dx: ");
    writeln("leftRectangles   : ", integrate(f, left, right, precision, leftRectangles()));
    writeln("rightRectangles  : ", integrate(f, left, right, precision, rightRectangles()));
    writeln("middleRectangles : ", integrate(f, left, right, precision, middleRectangles()));
    writeln("parabolas         : ", integrate(f, left, right, precision, parabolas()));
    writeln("polynomial (5)    : ", integrate(f, left, right, precision, polynomial(5)));
    writeln("lagrange (5)      : ", integrate(f, left, right, precision, lagrange(5)));
    writeln("gaussLejendre (5) : ", integrate(f, left, right, precision, gaussLejendre(5)));
    writeln();
}


void main()
{
    demo();
    demoAdaptive();
}

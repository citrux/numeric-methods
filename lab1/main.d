module main;

import std.stdio;
import std.math;
import integral;
import polynomials;


void main()
{
    real left = 0, right = 4;
    
    auto f = function(real x){return 1 / sqrt(x);};    
    writeln("int_0^4 1 / sqrt(x) dx по 5 точкам: ");
    writeln("lagrange       : ", lagrange(5)(f, left, right));
    writeln("polynomial     : ", polynomial(5)(f, left, right));
    writeln("gaussLejandre  : ", gaussLejandre(5)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(5)(f, left, right));
    writeln();

    f = function(real x){return 1 / sqrt(x * (4 - x));};    
    writeln("int_0^4 1 / sqrt(x(4-x)) dx по 3 точкам: ");
    writeln("lagrange       : ", lagrange(3)(f, left, right));
    writeln("polynomial     : ", polynomial(3)(f, left, right));
    writeln("gaussLejandre  : ", gaussLejandre(3)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(3)(f, left, right));
    writeln();

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx по 15 точкам: ");
    writeln("lagrange       : ", lagrange(15)(f, left, right));
    writeln("polynomial     : ", polynomial(15)(f, left, right));
    writeln("gaussLejandre  : ", gaussLejandre(15)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(15)(f, left, right));
    writeln();

    f = function(real x){return x;};
    writeln("int_0^4 x dx по 2 точкам: ");
    writeln("lagrange       : ", lagrange(2)(f, left, right));
    writeln("polynomial     : ", polynomial(2)(f, left, right));
    writeln("gaussLejandre  : ", gaussLejandre(2)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(2)(f, left, right));
    writeln();

    f = function(real x){return 1;};
    writeln("int_0^4 dx по 15 точкам: ");
    writeln("lagrange       : ", lagrange(15)(f, left, right));
    writeln("polynomial     : ", polynomial(15)(f, left, right));
    writeln("gaussLejandre  : ", gaussLejandre(15)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(15)(f, left, right));
    writeln();

    f = function(real x){return 1 + x + x * x + x * x * x;};
    writeln("int_0^4 x^3 + x^2 + x + 1 dx по 2 точкам: ");
    writeln("lagrange       : ", lagrange(2)(f, left, right));
    writeln("polynomial     : ", polynomial(2)(f, left, right));
    writeln("gaussLejandre  : ", gaussLejandre(2)(f, left, right));
    writeln("gaussChebyshev : ", gaussChebyshev(2)(f, left, right));
    writeln();
}

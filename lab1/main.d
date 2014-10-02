module main;

import std.stdio;
import std.math;
import integral;
import polynomials;


void main()
{
    real left = 0, right = 4;
    
    auto f = function(real x){return 1 / sqrt(x);};    
    writeln("int_0^4 1 / sqrt(x) dx по 15 точкам: ");
    writeln("lagrange          : ", lagrange(15)(f, left, right));
    writeln("polynomial        : ", polynomial(15)(f, left, right));
    writeln("gaussLejandre     : ", gaussLejandre(15)(f, left, right));
    writeln("gaussChebyshevMod : ", gaussChebyshevMod(15)(f, left, right));
    writeln();

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx по 15 точкам: ");
    writeln("lagrange          : ", lagrange(15)(f, left, right));
    writeln("polynomial        : ", polynomial(15)(f, left, right));
    writeln("gaussLejandre     : ", gaussLejandre(15)(f, left, right));
    writeln("gaussChebyshevMod : ", gaussChebyshevMod(15)(f, left, right));
    writeln();

    f = function(real x){return x;};
    writeln("int_0^4 x dx по 15 точкам: ");
    writeln("lagrange          : ", lagrange(15)(f, left, right));
    writeln("polynomial        : ", polynomial(15)(f, left, right));
    writeln("gaussLejandre     : ", gaussLejandre(15)(f, left, right));
    writeln("gaussChebyshevMod : ", gaussChebyshevMod(15)(f, left, right));
    writeln();

    f = function(real x){return 1;};
    writeln("int_0^4 dx по 15 точкам: ");
    writeln("lagrange          : ", lagrange(15)(f, left, right));
    writeln("polynomial        : ", polynomial(15)(f, left, right));
    writeln("gaussLejandre     : ", gaussLejandre(15)(f, left, right));
    writeln("gaussChebyshevMod : ", gaussChebyshevMod(15)(f, left, right));
    writeln();
}

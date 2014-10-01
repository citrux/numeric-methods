module main;

import std.stdio;
import std.math;
import integral;
import polynomials;


void main()
{
    writeln("Интегрирование:");
    writeln("sqrt x, 0 .. 9 с точностью 0.001: ");

    real left = 0, right = 9, precision = 0.001;
    auto f = function(real x){return sqrt(x);};
    
    writeln(integrate(f, left, right, precision, lagrange(10)));
    writeln(integrate(f, left, right, precision, polynomial(10)));
    writeln(integrate(f, left, right, precision, gaussLejandre(10)));

    writeln("Интегрирование:");
    writeln("sqrt x, 0 .. 9 по 5 точкам: ");

    writeln(lagrange(5)(f, left, right));
    writeln(polynomial(5)(f, left, right));
    writeln(gaussLejandre(5)(f, left, right));
}

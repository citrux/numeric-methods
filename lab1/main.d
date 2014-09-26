module main;

import std.stdio;
import std.math : sin, PI;
import integral;

void main() {
    writeln("");
    writeln("sin x, 0 .. pi: ");
    writeln("  * left_rectangles ", left_rectangles(function(real x){return sin(x);}, 0, PI, 16));
    writeln("  * right_rectangles ", right_rectangles(function(real x){return sin(x);}, 0, PI, 16));
    writeln("  * middle_rectangles ", middle_rectangles(function(real x){return sin(x);}, 0, PI, 16));
    writeln("  * trapezoids ", trapezoids(function(real x){return sin(x);}, 0, PI, 16));
    writeln("  * parabolas ", parabolas(function(real x){return sin(x);}, 0, PI, 16));
}

module main;

import std.stdio;
import std.math;
import integral;

void main() {
    writeln("");
    writeln("sqrt x, 0 .. 9: ");
    writeln("  * left_rectangles ", left_rectangles(function(real x){return x * x;}, 0, 9, 64));
    writeln("  * right_rectangles ", right_rectangles(function(real x){return x * x;}, 0, 9, 64));
    writeln("  * middle_rectangles ", middle_rectangles(function(real x){return x * x;}, 0, 9, 64));
    writeln("  * trapezoids ", trapezoids(function(real x){return x * x;}, 0, 9, 64));
    writeln("  * parabolas ", parabolas(function(real x){return x * x;}, 0, 9, 64));
}

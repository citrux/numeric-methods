module main;

import std.stdio;
import matrix;

void main() {
    auto A = Matrix(4, 4, [-7, 2, 1, 2,
                            3, -9, 2, 4,
                            7, 1, -13, 3,
                            9, 4, 1, -15]);
    auto b = Col([-6, 9, -5, -6]);
    auto x = LUPsolve(A, b);
    writeln(x);
}

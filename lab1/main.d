module main;

import std.stdio;
import matrix;

void main() {
    auto A = Matrix(3, 3, [0, 0, 0, 0, 0, 0, 7, 8, 8]);
    auto L = Matrix(3, 3);
    auto U = Matrix(3, 3);
    auto P = Matrix(3, 3);
    auto p = new size_t[3];
    LUP(A, p, L, U);
    foreach(i, el; p)
        P[i, el] = 1;
    writeln(P);
    writeln(L);
    writeln(U);
    writeln(P * L * U);
}
#pragma once
#include <iostream>
#include "matrix.hpp"

// solve matrix equation Ax = B, x = A^-1 B -- square matrix n×n
mat seidel( const mat & A, const mat & B, double eps )
{
    auto n = B.size();
    mat x(n);

    std::cout << "prepare" << endl;
    for (auto & r : x)
        r.assign(n,0);

    std::cout << "start" << endl;
    double delta;
    do {
        delta = 0;
        for (auto i = 0u; i < n; ++i)
        {
            vec sum(n);
            for (auto j = 0u; j < n; ++j)
                if (i != j)
                    sum += x[j] * A[i][j];
            vec dx = (B[i] - sum) / A[i][i] - x[i];
            delta = max(norm(dx), delta);
            x[i] += dx;
        }
        std::cout << delta << endl;
    }
    while ( delta > eps );
    return x;
}



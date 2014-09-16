module matrix;

import std.math;
import std.algorithm;
import std.stdio;


/***
    Структура для матрицы
***/
struct Matrix 
{
    private size_t _m, _n;
    private real[] _data;
    
    @property const size_t m() {return _m;};
    @property const size_t n() {return _n;};
    ref real opIndex(size_t i, size_t j=0) {return _data[i * _n + j];};
    Matrix opBinary(string op)(Matrix B)
    if (op == "-" || op == "+")
    {
        auto result = Matrix(m, n);
        foreach(i; 0 .. m)
            foreach(j; 0 .. n)
                mixin("result[i, j] = this[i, j]" ~ op ~ "B[i, j];");
        return result;
    }
    Matrix opBinary(string op)(real x)
    if (op == "*" || op == "/")
    {
        auto result = Matrix(m, n);
        foreach(i; 0 .. m)
            foreach(j; 0 .. n)
                mixin("result[i, j] = this[i, j]" ~ op ~ "x;");
        return result;
    }
    Matrix opBinary(string op)(Matrix B)
    if (op == "*")
    {
        auto result = Matrix(m, B.n);
        foreach(i; 0 .. result.m)
            foreach(j; 0 .. result.n)
                foreach(k; 0 .. n)
                    result[i, j] += this[i, k] * B[k, j];
        return result;
    }
    void swapRows(size_t i1, size_t i2)
    {
        foreach(j; 0 .. n)
            swap(this[i1, j], this[i2, j]);
    }
    this(size_t rows, size_t cols, real[] data)
    {
        _m = rows;
        _n = cols;
        _data = data;
    }
    this(size_t rows, size_t cols)
    {
        _m = rows;
        _n = cols;
        _data = new real[rows * cols];
        foreach(ref el; _data)
            el = 0;
    }
    this(size_t size) {this(size, size);}
}

Matrix Col(real[] data)
{
    return Matrix(data.length, 1, data);
}

Matrix Col(size_t n)
{
    return Matrix(n, 1);
}

unittest
{
    auto a = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    auto b = Matrix(3, 3, [9, 8, 7, 6, 5, 4, 3, 2, 1]);
    assert(a + b == Matrix(3, 3, [10, 10, 10, 10, 10, 10, 10, 10, 10]));
    assert(a - b == Matrix(3, 3, [-8, -6, -4, -2, 0, 2, 4, 6, 8]));
    assert(a * 6 == Matrix(3, 3, [6, 12, 18, 24, 30, 36, 42, 48, 54])); 
    assert((a * 6) / 3 == Matrix(3, 3, [2, 4, 6, 8, 10, 12, 14, 16, 18]));
    assert(a * b == Matrix(3, 3, [30, 24, 18, 84, 69, 54, 138, 114, 90]));
}

void LUP(Matrix B, out size_t[] p, out Matrix L, out Matrix U)
{
    auto n = B.n;
    // некрасивый способ скопировать матрицу B
    // в остальных случаях адреса A[i,j] будут совпадать с адресами B[i,j]
    auto A = Matrix(n);
    foreach(i; 0 .. n)
        foreach(j; 0 .. n)
            A[i, j] = B[i, j];

    L = Matrix(n);
    U = Matrix(n);
    p = new size_t[n];

    foreach(i, ref el; p)
        el = i;

    foreach(k; 0 .. n)
    {
        auto pivot = abs(A[k, k]);
        auto k1 = k;
        foreach(i; k + 1 .. n)
            if (abs(A[i, k]) > pivot)
            {
                pivot = abs(A[i, k]);
                k1 = i;
            }
        swap(p[k], p[k1]);
        A.swapRows(k, k1);
        foreach(i; k + 1 .. n)
        {
            if (A[k, k] != 0)
                A[i, k] /= A[k, k];
            foreach(j; k + 1 .. A.n)
                A[i, j] -= A[i, k] * A[k, j];
        }
    }
    foreach(i; 0 .. n)
        foreach(j; 0 .. n)
            if (i > j)
                L[i, j] = A[i, j];
            else
                U[i, j] = A[i, j];
    foreach(i; 0 .. n)
        L[i, i] = 1;
}

Matrix LUPsolve(Matrix A, Matrix b)
{
    auto n = A.n;
    auto x = Col(n);
    auto y = Col(n);
    Matrix L, U;
    size_t[] p;
    LUP(A, p, L, U);
    real sum;
    foreach(i; 0 .. n)
    {
        y[i] = b[p[i]];
        foreach(j; 0 .. i)
            y[i] -= L[i, j] * y[j];
    }
    foreach_reverse(i; 0 .. n)
    {
        x[i] = y[i];
        foreach(j; i + 1 .. n)
            x[i] -= U[i, j] * x[j];
        x[i] /= U[i, i];
    }
    return x;
}

unittest
{
    bool testLUP(Matrix A)
    {
        Matrix L, U, P;
        size_t[] p;
        //writeln(A);
        LUP(A, p, L, U);
        P = Matrix(p.length);
        foreach(i, el; p)
            P[i, el] = 1;
        //writeln(A);
        //writeln(L);
        //writeln(U);
        //writeln(P, " ", A);
        //writeln("PA ", P * A);
        //writeln("LU ", L * U);
        return (P * A == L * U);
    }

    // квадратные
    assert(testLUP(Matrix(1, 1, [0])));
    assert(testLUP(Matrix(1, 1, [1])));
    assert(testLUP(Matrix(2, 2, [1, 0,
                                 0, 1])));
    assert(testLUP(Matrix(2, 2, [1, 2,
                                 3, 4])));
    assert(testLUP(Matrix(2, 2, [1, 2,
                                 2, 1])));
    assert(testLUP(Matrix(3, 3, [1, 0, 0,
                                 0, 1, 0,
                                 0, 0, 1])));
    assert(testLUP(Matrix(3, 3, [0, 0, 0,
                                 0, 0, 0,
                                 7, 8, 8])));
    assert(testLUP(Matrix(3, 3, [1, 2, 3,
                                 4, 5, 6,
                                 7, 8, 8])));
    assert(testLUP(Matrix(3, 3, [0, 7, -6,
                                 0, 2, 1,
                                 0, 4, 2])));
    assert(testLUP(Matrix(4, 4, [0, 2, 3, 4,
                                 0, 1, 3, 2,
                                 0, 1, 3, 3,
                                 0, 0, 0, 4])));
    assert(testLUP(Matrix(5, 5, [0, 2, 3, 4, 5,
                                 0, 0, 3, 2, 1,
                                 0, 1, 3, 3, 5,
                                 0, 1, 3, 4, 2,
                                 1, 1, 3, 8, 2])));
    assert(testLUP(Matrix(5, 5, [0, 2, 3, 4, 5,
                                 0, 0, 2, 2, 1,
                                 0, 0, 0, 3, 5,
                                 0, 0, 3, 4, 2,
                                 1, 1, 3, 8, 2])));
    // прямоугольные
    //assert(testLUP(Matrix(1, 2, [1, 2])));
    //assert(testLUP(Matrix(3, 4, [0, 2, 3, 4,
    //                             0, 1, 3, 2,
    //                             0, 1, 3, 3])));
}

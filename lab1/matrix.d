module matrix;

import std.math : abs;
import std.algorithm : swap;


/***
    Структура для матрицы
***/
struct Matrix 
{
    private size_t _rows, _cols;
    real[] _data;
    
    @property const size_t rows() {return _rows;};
    @property const size_t cols() {return _cols;};
    
    ref real opIndex(size_t i, size_t j=0) {return _data[i * _cols + j];};
    
    Matrix opBinary(string op)(Matrix B)
    if (op == "-" || op == "+")
    {
        auto result = Matrix(_rows, _cols);
        foreach(i; 0 .. _rows)
            foreach(j; 0 .. _cols)
                mixin("result[i, j] = this[i, j]" ~ op ~ "B[i, j];");
        return result;
    }

    Matrix opBinary(string op)(real x)
    if (op == "*" || op == "/")
    {
        auto result = Matrix(_rows, _cols);
        foreach(i; 0 .. _rows)
            foreach(j; 0 .. _cols)
                mixin("result[i, j] = this[i, j]" ~ op ~ "x;");
        return result;
    }

    Matrix opBinary(string op)(Matrix B)
    if (op == "*")
    {
        auto result = Matrix(_rows, B.cols);
        foreach(i; 0 .. result.rows)
            foreach(j; 0 .. result.cols)
                foreach(k; 0 .. _cols)
                    result[i, j] += this[i, k] * B[k, j];
        return result;
    }
    
    void swapRows(size_t i1, size_t i2)
    {
        foreach(j; 0 .. _cols)
            swap(this[i1, j], this[i2, j]);
    }
    
    this(size_t rows, size_t cols, real[] data)
    {
        _rows = rows;
        _cols = cols;
        _data = data;
    }
    
    this(size_t rows, size_t cols)
    {
        _rows = rows;
        _cols = cols;
        _data = new real[rows * cols];
        foreach(ref el; _data)
            el = 0;
    }
    
    this(size_t size) {this(size, size);}
    
    this(this) {_data = _data.dup;};
}

Matrix Col(real[] data)
{
    return Matrix(data.length, 1, data);
}

Matrix Col(size_t cols)
{
    return Matrix(cols, 1);
}

Matrix Perm(size_t[] p)
{
    auto result = Matrix(p.length);
    foreach(i, el; p)
        result[i, el] = 1;
    return result;
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

void LUP(Matrix A, out size_t[] p, out Matrix L, out Matrix U)
{
    auto n = A.rows;

    L = Matrix(n);
    U = Matrix(n);
    p = new size_t[n];

    foreach(i, ref el; p)
        el = i;

    foreach(k; 0 .. n)
    {
        auto pivot = abs(A[k, k]);
        auto l = k;
        foreach(i; k + 1 .. n)
            if (abs(A[i, k]) > pivot)
            {
                pivot = abs(A[i, k]);
                l = i;
            }
        swap(p[k], p[l]);
        A.swapRows(k, l);
        foreach(i; k + 1 .. n)
        {
            if (A[k, k] != 0)
                A[i, k] /= A[k, k];
            foreach(j; k + 1 .. n)
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

unittest
{
    bool testLUP(Matrix A)
    {
        Matrix L, U, P;
        size_t[] p;
        LUP(A, p, L, U);
        P = Perm(p);
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

Matrix LUPsolve(Matrix A, Matrix b)
{
    auto cols = A.cols;
    auto x = Col(cols);
    auto y = Col(cols);
    Matrix L, U;
    size_t[] p;
    LUP(A, p, L, U);
    real sum;
    foreach(i; 0 .. cols)
    {
        y[i] = b[p[i]];
        foreach(j; 0 .. i)
            y[i] -= L[i, j] * y[j];
    }
    foreach_reverse(i; 0 .. cols)
    {
        x[i] = y[i];
        foreach(j; i + 1 .. cols)
            x[i] -= U[i, j] * x[j];
        x[i] /= U[i, i];
    }
    return x;
}

unittest
{
    bool testLUPsolve(Matrix A, Matrix b)
    {
        auto x = LUPsolve(A, b);
        return (A * x == b);
    }
    //assert(testLUPsolve(Matrix(4, 4, [-7, 2, 1, 2,
    //                                  3, -9, 2, 4,
    //                                  7, 1, -13, 3,
    //                                  9, 4, 1, -15]),
    //                    Col([-6, 9, -5, -6])
    //                    ));
}
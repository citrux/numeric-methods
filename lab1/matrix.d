module matrix;

import std.math;

/***
    Структуры для строк и столбцов
***/
class Vector
{
    real[] data;
    
    // доступ по индексу и присваивание по индексу
    real opIndex(size_t i) {return data[i];};
    void opIndexAssign(real value, size_t i) {data[i] = value;};
    // присваивание
    void opAssign(real[] value) {data = value;};
    // скалярное произведение 
    real opBinary(string op)(Vector other)
    if (op == "*")
    {
        real result = 0;
        foreach(i; 0 .. length)
            result += this[i] * other[i];
        return result;
    }
    Vector opBinary(string op)(Vector other)
    if (op == "+" || op == "-")
    {
        Vector result = new Vector(this.length);
        foreach(i; 0 .. length)
            mixin("result[i] += this[i] " ~ op ~ " other[i];");
        return result;
    }
    Vector opBinary(string op)(real x)
    if (op == "*" || op == "/")
    {
        auto result = new Vector(this.length);
        foreach(i; 0 .. this.length)
            mixin("result[i] = this[i]" ~ op ~ " x;");
        return result;
    }
    
    @property size_t length() {return data.length;};

    this() {};
    this(real[] array) {data = array;};
    this(size_t n)
    {
        data = new real[n];
        foreach(ref el; data)
            el = 0;
    };
}


class Row : Vector
{
    void opAssign(Vector other) {data = other.data;};
    this() {};
    this(real[] array) {super(array);};
    this(size_t n) {super(n);};
};


class Col : Vector
{
    void opAssign(Vector other) {data = other.data;};
    this() {};
    this(real[] array) {super(array);};
    this(size_t n) {super(n);};
};

alias Rows = Row[];
alias Cols = Col[];

unittest
{
    auto a = new Row([1,2,3]);
    auto b = new Col([1,2,3]);
    assert(a * b == 14);
    assert((a * 2).data == [2, 4, 6]);
    assert((a / 2).data == [0.5, 1.0, 1.5]);
}

/***
    Структура для матрицы
***/
struct Matrix 
{
    private real[] elements;
    private size_t n_rows, n_cols;
    
    @property size_t m() {return n_rows;};
    @property size_t n() {return n_cols;};
    real opIndex(size_t i, size_t j) {return elements[i * n + j];};
    void opIndexAssign(real value, size_t i, size_t j)
    {
        elements[i * n + j] = value;
    };
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
        foreach(i, r; this.rows())
            foreach(j, c; B.cols())
                result[i, j] = r * c;
        return result;
    }
    void change_rows(size_t i1, size_t i2)
    {
        auto A = this.rows();
        auto buf = A[i1];
        A[i1] = A[i2];
        A[i2] = buf;
        this = A.matrix();
    }
    this(size_t rows, size_t cols, real[] data)
    {
        n_rows = rows;
        n_cols = cols;
        elements = data;
    }
    this(size_t rows, size_t cols)
    {
        n_rows = rows;
        n_cols = cols;
        elements = new real[rows * cols];
        foreach(ref el; elements)
            el = 0;
    }
    this(size_t size) {this(size, size);}
}


unittest
{
    auto a = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    auto b = Matrix(3, 3, [9, 8, 7, 6, 5, 4, 3, 2, 1]);
    assert(a + b == Matrix(3, 3, [10, 10, 10, 10, 10, 10, 10, 10, 10]));
    assert(a - b == Matrix(3, 3, [-8, -6, -4, -2, 0, 2, 4, 6, 8]));
    a = a * 6;
    assert(a == Matrix(3, 3, [6, 12, 18, 24, 30, 36, 42, 48, 54]));
    a = a / 3; 
    assert(a == Matrix(3, 3, [2, 4, 6, 8, 10, 12, 14, 16, 18]));
}
/***
    Преобразование матрицы в массив строк
***/
Row row(Matrix A, size_t i)
{
    auto result = new Row(A.n);
    foreach(j; 0 .. A.n)
        result[j] = A[i, j];
    return result;
}

Rows rows(Matrix A)
{
    auto result = new Row[A.m];
    foreach(i; 0 .. A.m)
        result[i] = A.row(i);
    return result;
}

/***
    Преобразование массив строк в матрицу
***/
Matrix matrix(Rows rows)
{
    auto m = rows.length;
    auto n = rows[0].length;
    auto data = new real[m * n];
    foreach(i, r; rows)
        data[i * n .. (i + 1) * n] = r.data;
    return Matrix(m, n, data);
}

Matrix matrix(Row row)
{
    return [row].matrix();
}

/***
    Преобразование матрицы в массив столбцов
***/
Col col(Matrix A, size_t j)
{
    auto result = new Col(A.m);
    foreach(i; 0 .. A.m)
        result[i] = A[i, j];
    return result;
}

Cols cols(Matrix A)
{
    auto result = new Col[A.n];
    foreach(j; 0 .. A.n)
        result[j] = A.col(j);
    return result;
}

/***
    Преобразование массив столбцов в матрицу
***/
Matrix matrix(Cols cols)
{
    auto n = cols.length;
    auto m = cols[0].length;
    auto data = new real[m * n];
    foreach(j, c; cols)
        foreach(i, v; c.data)
            data[i * n + j] = v;
    return Matrix(m, n, data);
}

Matrix matrix(Col col)
{
    return [col].matrix();
}

/***
    Подматрица, получаемая вычеркиванием i строки и j столбца
***/
Matrix submatrix(Matrix A, size_t i, size_t j)
{
    Rows rows = A.rows();
    Rows new_rows = rows[0 .. i] ~ rows[i + 1 .. $];
    
    Cols cols = new_rows.matrix().cols();
    Cols new_cols = cols[0 .. j] ~ cols[j + 1 .. $];

    return new_cols.matrix();
}

unittest
{
    auto a = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 9]);
    auto b = a.submatrix(1, 1);
    assert(b == Matrix(2, 2, [1, 3, 7, 9]));
}

void LUP(Matrix A, out size_t[] P, out Matrix L, out Matrix U)
{
    auto m = A.m;
    auto n = A.n;
    P = new size_t[n];
    foreach(i, ref el; P)
        el = i;
    
    Cols L_cols = new Col[n];
    Rows U_rows = new Row[n];

    foreach(j; 0 .. n)
    {
        if (A[j, j] == 0)
        {
            foreach(i; j + 1 .. n)
                if (abs(A[i, j]) > abs(A[P[j], j]))
                {
                    auto buffer = P[j];
                    P[j] = P[i];
                    P[i] = buffer;
                }
            A.change_rows(j, P[j]);
        }

        Col v = A.col(j);
        Row u = A.row(j);
        
        if (v[j] != 0)
            v = v / v[j];
        else
            v[j] = 1;

        L_cols[j] = v;
        U_rows[j] = u;

        A = A - (v.matrix() * u.matrix());
    }
    L = L_cols.matrix();
    U = U_rows.matrix();
}

unittest
{
    bool testLUP(Matrix A)
    {
        if (A.n != A.m)
            return false;
        Matrix L, U, P;
        size_t[] p;
        LUP(A, p, L, U);
        foreach(i, el; p)
            P[i, el] = 1;
        return (A == P * L * U);
    }

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
                                 0, 1, 3, 2, 1,
                                 0, 1, 3, 3, 5,
                                 0, 1, 3, 4, 2,
                                 0, 1, 3, 8, 2])));
}
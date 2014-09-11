module matrix;

import std.math;
import std.stdio;

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


class Column : Vector
{
    void opAssign(Vector other) {data = other.data;};
    this() {};
    this(real[] array) {super(array);};
    this(size_t n) {super(n);};
};

alias Rows = Row[];
alias Cols = Column[];

unittest
{
    auto a = new Row([1,2,3]);
    auto b = new Column([1,2,3]);
    assert(a * b == 14);
    assert((a * 2).data == [2, 4, 6]);
    assert((a / 2).data == [0.5, 1.0, 1.5]);
}

/***
    Структура для матрицы
***/
struct Matrix 
{
    real[] elements;
    size_t m, n;

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
    this(size_t rows, size_t columns, real[] data)
    {
        m = rows;
        n = columns;
        elements = data;
    }
    this(size_t rows, size_t columns)
    {
        m = rows;
        n = columns;
        elements = new real[rows * columns];
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
Rows rows(Matrix A)
{
    auto result = new Row[A.m];
    foreach(i; 0 .. A.m)
        result[i] = new Row(A.elements[i * A.n .. (i + 1) * A.n]);
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

/***
    Преобразование матрицы в массив столбцов
***/
Cols cols(Matrix A)
{
    auto result = new Column[A.n];
    foreach(j; 0 .. A.n)
    {
        result[j] = new Column(A.m);
        foreach(i; 0 .. A.m)
            result[j][i] = A.elements[i * A.n + j];
    }
    return result;
}

/***
    Преобразование массив столбцов в матрицу
***/
Matrix matrix(Cols columns)
{
    auto n = columns.length;
    auto m = columns[0].length;
    auto data = new real[m * n];
    foreach(j, c; columns)
        foreach(i, v; c.data)
            data[i * n + j] = v;
    return Matrix(m, n, data);
}

/***
    Подматрица, получаемая вычеркиванием i строки и j столбца
***/
Matrix submatrix(Matrix A, size_t i, size_t j)
{
    Rows rows = A.rows();
    Rows new_rows = new Row[rows.length - 1];
    new_rows = rows[0 .. i] ~ rows[i + 1 .. $];
    
    Cols cols = new_rows.matrix().cols();
    Cols new_cols = new Column[cols.length - 1];
    new_cols = cols[0 .. j] ~ cols[j + 1 .. $];

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

    Cols L_cols = new Column[n];
    Rows U_rows = new Row[n];

    foreach(i; 0 .. n)
    {
        Column v = A.cols()[0];
        size_t max_pos = 0;
        if (v[0] == 0)
        {
            foreach(j; 1 .. A.n)
                if (abs(v[j]) > abs(v[max_pos]))
                    max_pos = j;
            A.change_rows(0, max_pos);
            auto buf = P[i];
            P[i] = P[max_pos + i];
            P[max_pos + i] = buf;
        }

        v = A.cols()[0];
        Row u = A.rows()[0];
        auto top = v[0];
        if (top != 0)
        {
            v = v / top;
        }
        L_cols[i] = new Column(n);
        L_cols[i].data[i .. $] = v.data; // нужно переписать не используя data

        U_rows[i] = new Row(n);
        U_rows[i].data[i .. $] = u.data; // аналогично

        if (i < n - 1)
        {
            A = A - ([v].matrix() * [u].matrix());
            A = A.submatrix(0, 0);
        }
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
        auto size = A.n;
        auto L = Matrix(size);
        auto U = Matrix(size);
        auto P = Matrix(size);
        auto p = new size_t[size];
        LUP(A, p, L, U);
        foreach(i, el; p)
            P[i, el] = 1;
        return (A == P * L * U);
    }

    assert(testLUP(Matrix(1, 1, [0])));
    assert(testLUP(Matrix(1, 1, [1])));
    assert(testLUP(Matrix(2, 2, [1, 2, 3, 4])));
    assert(testLUP(Matrix(2, 2, [1, 2, 2, 1])));
    assert(testLUP(Matrix(3, 3, [0, 0, 0, 0, 0, 0, 7, 8, 8])));
    assert(testLUP(Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 8])));

}
module matrix;

import std.math;

/***
    Структуры для строк и столбцов

    Нужно уйти от этого никому не нужного дублирования
    Проблема в том, что структуры наследовать нельзя
***/
struct Row
{
    real[] data;
    
    // доступ по индексу и присваивание по индексу
    real opIndex(size_t i){return data[i];};
    void opIndexAssign(real value, size_t i){data[i] = value;};
    // присваивание
    void opAssign(real[] value){data = value;};
    void opAssign(Row* r){this = *r;};  
    // умножение строки на столбец 
    real opBinary(string op)(Column b) if (op == "*")
    {
        real result = 0;
        foreach(i; 0 .. length)
            result += data[i] * b[i];
        return result;
    }
    
    @property size_t length() {return data.length;};
    
    this(real[] row){data = row;};
    this(size_t n){data = new real[n];};
};

struct Column
{
    real[] data;
    
    real opIndex(size_t i){return data[i];};
    void opIndexAssign(real value, size_t i){data[i] = value;};
    void opAssign(real[] value){data = value;};
    void opAssign(Column* c){this = *c;};   
    
    @property size_t length() {return data.length;};
    
    this(real[] col){data = col;};
    this(size_t n){data = new real[n];};
};

unittest
{
    auto a = Row([1,2,3]);
    auto b = Column([1,2,3]);
    assert(a * b == 14);
}

/***
    Структура для матрицы
***/
struct Matrix 
{
    real[] elements;
    size_t m, n;

    real opIndex(size_t i, size_t j){return elements[i * n + j];};
    void opIndexAssign(real value, size_t i, size_t j)
    {
        elements[i * n + j] = value;
    };
    Matrix opBinary(string op)(Matrix B) if (op == "+")
    {
        auto new_els = new real[m * n];
        foreach(i, ref el; new_els)
            el = elements[i] + B.elements[i];
        return Matrix(m, n, new_els);
    }
    Matrix opBinary(string op)(Matrix B) if (op == "-")
    {
        auto new_els = new real[m * n];
        foreach(i, ref el; new_els)
            el = elements[i] - B.elements[i];
        return Matrix(m, n, new_els);
    }
    Matrix opBinary(string op)(real x) if (op == "*")
    {
        auto new_els = new real[m * n];
        foreach(i, ref el; new_els)
            el = elements[i] * x;
        return Matrix(m, n, new_els);
    }
    Matrix opBinary(string op)(real x) if (op == "/")
    {
        return this * (1 / x);
    }
    Matrix opBinary(string op)(Matrix B) if (op == "*")
    {
        auto result = new Row[m];
        foreach(i, r; this.to_rows())
        {
            result[i] = new Row(B.n);
            foreach(j, c; B.to_columns())
                result[i][j] = r * c;
        }
        return result.from_rows();
    }
    void change_rows(size_t i1, size_t i2)
    {
        auto A = this.to_rows();
        auto buf = A[i1];
        A[i1] = A[i2];
        A[i2] = buf;
        this = A.from_rows();
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
Row[] to_rows(Matrix A)
{
    auto result = new Row[A.m];
    foreach(i; 0 .. A.m)
        result[i] = A.elements[i * A.n .. (i + 1) * A.n].dup;
    return result;
}

/***
    Преобразование массив строк в матрицу
***/
Matrix from_rows(Row[] rows)
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
Column[] to_columns(Matrix A)
{
    auto result = new Column[A.n];
    foreach(j; 0 .. A.n)
    {
        result[j] = new real[A.m];
        foreach(i; 0 .. A.m)
            result[j][i] = A.elements[i * A.n + j];
    }
    return result;
}

/***
    Преобразование массив столбцов в матрицу
***/
Matrix from_columns(Column[] columns)
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
    Row[] rows = A.to_rows();
    Row[] new_rows = new Row[rows.length - 1];
    foreach(k, el; rows)
        if (k <= i)
            new_rows[k] = el;
        else
            new_rows[k - 1] = el;
    
    Column[] cols = new_rows.from_rows().to_columns();
    Column[] new_cols = new Column[cols.length - 1];
    foreach(k, el; cols)
        if (k <= j)
            new_cols[k] = el;
        else
            new_cols[k - 1] = el;
    return new_cols.from_columns();
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

    auto a = Matrix(m, n, A.elements);
    
    Column[] L_cols = new Column[n];
    Row[] U_rows = new Row[n];

    foreach(i; 0 .. n)
    {
        Column v = a.to_columns()[0];
        size_t max_pos = 0;
        if (v[0] == 0)
        {
            foreach(j; 1 .. a.n)
                if (abs(v[j]) > abs(v[max_pos]))
                    max_pos = j;
            a.change_rows(0, max_pos);
            auto buf = P[i];
            P[i] = P[max_pos + i];
            P[max_pos + i] = P[i];
        }
        v = a.to_columns()[0];
        Row u = a.to_rows()[0];
        L_cols[i] = new Column(n);
        foreach(k; 0 .. i)
            L_cols[i][k] = 0;
        foreach(k; i .. n)
            L_cols[i][k] = v[k - i];
        foreach(k; 0 .. n)
            L_cols[i][k] = L_cols[i][k] / u[0];

        U_rows[i] = new Row(n);
        foreach(k; 0 .. i)
            U_rows[i][k] = 0;
        foreach(k; i .. n)
            U_rows[i][k] = u[k - i];

        if (i < n - 1)
        {
            a = a - ([v].from_columns() * [u].from_rows()) / u[0];
            a = a.submatrix(0, 0);
        }
    }
    L = L_cols.from_columns();
    U = U_rows.from_rows();
}

unittest
{
    auto A = Matrix(3, 3, [1, 2, 3, 4, 5, 6, 7, 8, 8]);
    auto L = Matrix(3, 3);
    auto U = Matrix(3, 3);
    auto P = Matrix(3, 3);
    auto p = new size_t[3];
    LUP(A, p, L, U);
    foreach(i, el; p)
        P[i, el] = 1;
    assert(A == P * L * U);
}
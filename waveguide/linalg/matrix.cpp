#include <algorithm>
#include "matrix.hpp"

// Внутренняя реализация разреженной матрицы в виде списка разреженных строк
// Разреженная строка -- вектор пар (индекс, значение)
// Описаны операции над разреженными строками
// Обёртка предоставляет интерфейс, скрывающий внутреннюю реализацию и
// позволяет пользоваться srow как вектором
double operator * (const srow & a, const vec & b)
{
    double res = 0;
    for (auto el : a.data)
            res += el.second * b[el.first];
    return res;
}

srow & operator *= (srow & a, const double b)
{
    for (auto & el : a.data)
        el.second *= b;
    return a;
}

srow & operator += (srow & a, const srow & b)
{
    for (auto el : b.data)
        a[el.first] += el.second;
    return a;
}

double & srow::operator[](const size_t index)
{
    // линейный поиск по строке
    sort(data.begin(), data.end());
    auto iter = data.begin();
    while (iter < data.end() and (*iter).first < index)
        ++iter;
    if (iter == data.end() or (*iter).first != index)
    {
        data.emplace_back(index, 0);
        iter = data.end() - 1;
    }
    return (*iter).second;
}


// Операции над разреженными матрицами
vec operator * (const smat & a, const vec & b)
{
    vec res(b.size());
    for (size_t i = 0; i < b.size(); ++i)
        res[i] = a[i] * b;
    return res;
}

smat & operator += (smat & a, const smat & b)
{
    for (size_t i = 0; i < b.size(); ++i)
        a[i] += b[i];
    return a;
}

smat operator + (smat a, const smat & b) { return a += b; }

smat operator - (smat a) { return a * (-1); }
smat & operator -= (smat & a, const smat & b) {return a +=-b; }
smat operator - (smat a, const smat & b) { return a -= b; }

smat operator * (smat a, const double b)
{
    for (auto & row : a)
        row *= b;
    return a;
}

// единичная разреженная матрица
smat I(const size_t n)
{
    smat res(n);
    for (size_t i = 0; i < n; ++i)
        res[i][i] = 1;
    return res;
}

// операции над обычными матрицами
vec operator * (const mat & a, const vec & b)
{
    vec res(b.size());
    for (size_t i = 0; i < a.size(); ++i)
        res[i] = a[i] * b;
    return res;
}

mat operator * (mat a, const double b)
{
    for (size_t i = 0; i < a.size(); ++i)
        a[i] *= b;
    return a;
}


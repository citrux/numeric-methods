#pragma once
#include "matrix.hpp"

struct eigen {double l; vec v;};

void orthogonalize(vec & a, const mat & vs)
{
    for (auto v : vs)
        a -= v * (v * a);
}

template <typename T>
eigen maxEigenValue(const T & A, const mat & O = {})
{
    double l = 0, l1 = 1, eps = 1e-10;
    vec x(A.size());
    // перебираем базисные вектора в поисках некомпланарного
    for (int i = 0; norm(x) < 10 * eps; ++i)
    {
        if(i)
            x[i-1] = 0;
        x[i] = 1;
        orthogonalize(x, O);
    }
    // берём ортогональный заданным векторам вектор и начинаем искать
    // максимальное из оставшихся собственных значений
    auto x1 = A * x;
    while(l1 - l > eps)
    {
        l = norm(x1) / norm(x);
        // нормировка, ятобы числа быстро не росли и точность не падала:
        x = x1 / norm(x1);
        x1 = A * x;
        // поиск ортогональной компоненты
        orthogonalize(x1, O);
        l1 = norm(x1) / norm(x);
    }
    if (x1 * x < 0 && l > 0)
        l = -l;
    x = x1 / norm(x1);
    return {l, x};
}

template <typename T>
vector<eigen> getEigens(const T & A, size_t count = 0)
{
    if (!count)
        count  = A.size();

    mat ev;
    vector<eigen> res;
    for (size_t i = 0; i < count; ++i)
    {
        auto e = maxEigenValue(A, ev);
        ev.push_back(e.v);
        res.push_back(e);
    }
    return res;
}

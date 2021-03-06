#include <fstream>
#include <iostream>
#include <cmath>
#include "linalg/eigens.hpp"
#include "linalg/seidel.hpp"

using namespace std;

struct mode {double a, b; size_t m, n; vec Z, Ex, Hx, Ey, Hy; double g2;};


// d/dy
smat ddy(size_t m, size_t n, double hy)
{
    smat Dy(m * n);
    for (size_t i = 1; i < n-1; ++i)
        for (size_t j = 0; j < m; ++j)
        {
            Dy[i*m+j][(i-1) * m + j] = -.5 / hy;
            Dy[i*m+j][(i+1) * m + j] = .5 / hy;
        }
    for (size_t j = 0; j < m; ++j)
    {
        Dy[j][j] = -1.5 / hy;
        Dy[j][m + j] = 2. / hy;
        Dy[j][2*m + j] = -.5 / hy;

        Dy[(n-1) * m + j][(n-1) * m + j] = 1.5 / hy;
        Dy[(n-1) * m + j][(n-2) * m + j] = -2. / hy;
        Dy[(n-1) * m + j][(n-3) * m + j] = .5 / hy;
    }
    return Dy;
}

// d/dx
smat ddx(size_t m, size_t n, double hx)
{
    smat Dx(m * n);
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 1; j < m-1; ++j)
        {
            Dx[i*m+j][i * m + j-1] = -.5 / hx;
            Dx[i*m+j][i * m + j+1] = .5 / hx;
        }
    for (size_t i = 0; i < n; ++i)
    {
        Dx[i*m][i*m] = -1.5 / hx;
        Dx[i*m][i*m + 1] = 2. / hx;
        Dx[i*m][i*m + 2] = -.5 / hx;

        Dx[(i+1) * m - 1][(i+1) * m - 1] = 1.5 / hx;
        Dx[(i+1) * m - 1][(i+1) * m - 2] = -2. / hx;
        Dx[(i+1) * m - 1][(i+1) * m - 3] = .5 / hx;
    }
    return Dx;
}


vector<mode> getEwavesFD(double a, double b, size_t m, size_t n, size_t count)
{
    smat D2((m-2) * (n-2));

    double hx = a / (m-1), hx2 = hx * hx, hy = b / (n-1), hy2 = hy * hy;
    // формируем поперечный оператор Лапласа
    for (size_t i = 0; i < n-2; ++i)
        for (size_t j = 0; j < m-2; ++j)
        {
            size_t ind = i * (m - 2) + j;
            D2[ind][ind] =  -2. / hy2 - 2. / hx2;
            if (j > 0)
                D2[ind][ind-1] = 1. / hx2;
            if (j < m-3)
                D2[ind][ind+1] = 1. / hx2;
            if (i > 0)
                D2[ind][ind-m+2] = 1. / hy2;
            if (i < n-3)
                D2[ind][ind+m-2] = 1. / hy2;
        }

    auto lmax = maxEigenValue(D2);
    // формируем новый оператор, высшие собственные значения которого
    // будут низшими собственными значениями оператора D2
    auto op = -D2 + I(D2.size()) * lmax.l;
    auto modes = getEigens(op, count);
    vector<mode> result(count);

    // операторы частных производных
    smat Dy = ddy(m, n, hy);
    smat Dx = ddx(m, n, hx);

    for (size_t k = 0; k < count; ++k)
    {
        vec Z(m * n);
        for (size_t i = 0; i < n; ++i)
            if (i > 0 && i < n-1)
                for (size_t j = 1; j < m-1; ++j)
                    Z[i * m + j] = modes[k].v[(i-1) * (m-2) + (j-1)];
        auto g2 = modes[k].l - lmax.l;
        auto h = sqrt(g2);
        auto omega = h * 1.4142 * 3e8;
        double eps = 8.85e-12;
        auto Ex = Dx * Z * (-h / g2);
        auto Ey = Dy * Z * (-h / g2);
        auto Hx = Ey * (-omega * eps / h);
        auto Hy = Ex * (omega * eps / h);
        result[k] = {a, b, m, n, Z, Ex, Hx, Ey, Hy, g2};
    }
    return result;
}

vector<mode> getHwavesFD(double a, double b, size_t m, size_t n, size_t count)
{
    smat D2(m * n);

    double hx = a / (m-1), hx2 = hx * hx, hy = b / (n-1), hy2 = hy * hy;
    // формируем поперечный оператор Лапласа
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < m; ++j)
        {
            size_t ind = i * m + j;
            D2[ind][ind] = -2 / hx2 - 2 / hy2;
            if (j > 0 && j < m-1)
            {
                D2[ind][ind-1] = 1. / hx2;
                D2[ind][ind+1] = 1. / hx2;
            }
            if (j == 0)
                D2[ind][ind+1] = 2. / hx2;
            if (j == m-1)
                D2[ind][ind-1] = 2. / hx2;

            if (i > 0 && i < n-1)
            {
                D2[ind][ind-m] = 1. / hy2;
                D2[ind][ind+m] = 1. / hy2;
            }
            if (i == 0)
                D2[ind][ind+m] = 2. / hy2;
            if (i == n-1)
                D2[ind][ind-m] = 2. / hy2;
        }

    auto xmax = maxEigenValue(D2);
    // формируем новый оператор, высшие собственные значения которого
    // будут низшими собственными значениями оператора D2
    auto op = -D2 + I(D2.size()) * xmax.l;
    // так как нулевая мода нас не интересует, придётся считать на одну
    // гармонику больше
    auto modes = getEigens(op, count+1);
    modes.erase(modes.begin());
    vector<mode> result(count);

    // операторы частных производных
    smat Dy = ddy(m, n, hy);
    smat Dx = ddx(m, n, hx);


    for (size_t k = 0; k < count; ++k)
    {
        auto Z = modes[k].v;
        auto g2 = modes[k].l - xmax.l;
        auto h = sqrt(g2);
        auto omega = h * 1.4142 * 3e8;
        double mu = 1.257e-6;
        auto Ex = Dy * Z * (-omega * mu / g2);
        auto Ey = Dx * Z * (omega * mu / g2);
        auto Hx = Ey * (-h / omega / mu);
        auto Hy = Ex * (h / omega / mu);
        result[k] = {a, b, m, n, Z, Ex, Hx, Ey, Hy, g2};

    }
    return result;
}

vector<mode> getEwavesFE(double a, double b, size_t m, size_t n, size_t count)
{
    mat D2((m-2) * (n-2));
    mat A((m-2) * (n-2));

    double hx = a / (m-1), hx2 = hx * hx, hy = b / (n-1), hy2 = hy * hy;
    // формируем поперечный оператор Лапласа
    for (size_t i = 0; i < n-2; ++i)
        for (size_t j = 0; j < m-2; ++j)
        {
            size_t ind = i * (m - 2) + j;

            D2[ind].assign((m-2) * (n-2), 0);
            A[ind].assign((m-2) * (n-2), 0);

            D2[ind][ind] =  -2. / hy2 - 2. / hx2;
            A[ind][ind] = 0.5;
            if (j > 0)
            {
                D2[ind][ind-1] = 1. / hx2;
                A[ind][ind-1] = 1. / 12;
            }
            if (j < m-3)
            {
                D2[ind][ind+1] = 1. / hx2;
                A[ind][ind+1] = 1. / 12;
            }
            if (i > 0)
            {
                D2[ind][ind-m+2] = 1. / hy2;
                A[ind][ind-m+2] = 1. / 12;
                if (j < m-3)
                    A[ind][ind-m+3] = 1. / 12;
            }
            if (i < n-3)
            {
                D2[ind][ind+m-2] = 1. / hy2;
                A[ind][ind+m-2] = 1. / 12;
                if (j > 0)
                    A[ind][ind+m-3] = 1. / 12;
            }
        }

    cout << "calc A^-1D2" << endl;
    D2 = seidel(A, D2, 1e-7);
    auto lmax = maxEigenValue(D2);
    // формируем новый оператор, высшие собственные значения которого
    // будут низшими собственными значениями оператора D2
    auto op = -D2;
    // dirty!
    for (auto i = 0u; i < D2.size(); ++i) {
        op[i][i] += lmax.l;
    }

    cout << "calc eigens" << endl;
    auto modes = getEigens(op, count);
    vector<mode> result(count);

    // операторы частных производных
    smat Dy = ddy(m, n, hy);
    smat Dx = ddx(m, n, hx);

    for (size_t k = 0; k < count; ++k)
    {
        vec Z(m * n);
        for (size_t i = 0; i < n; ++i)
            if (i > 0 && i < n-1)
                for (size_t j = 1; j < m-1; ++j)
                    Z[i * m + j] = modes[k].v[(i-1) * (m-2) + (j-1)];
        auto g2 = modes[k].l - lmax.l;
        auto h = sqrt(g2);
        auto omega = h * 1.4142 * 3e8;
        double eps = 8.85e-12;
        auto Ex = Dx * Z * (-h / g2);
        auto Ey = Dy * Z * (-h / g2);
        auto Hx = Ey * (-omega * eps / h);
        auto Hy = Ex * (omega * eps / h);
        result[k] = {a, b, m, n, Z, Ex, Hx, Ey, Hy, g2};
    }
    return result;
}

vector<mode> getHwavesFE(double a, double b, size_t m, size_t n, size_t count)
{
    mat D2(m * n);
    mat A(m * n);

    double hx = a / (m-1), hx2 = hx * hx, hy = b / (n-1), hy2 = hy * hy;
    // формируем поперечный оператор Лапласа
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < m; ++j)
        {
            size_t ind = i * m + j;

            D2[ind].assign(m * n, 0);
            A[ind].assign(m * n, 0);

            D2[ind][ind] =  -2. / hy2 - 2. / hx2;
            A[ind][ind] = 0.5;
            if (j > 0)
            {
                D2[ind][ind-1] = 1. / hx2;
                A[ind][ind-1] = 1. / 12;
                if (i==0 || i==n-1)
                {
                    A[ind][ind-1] = 5. / 24;
                    D2[ind][ind-1] = 1.5 / hx2;
                }
            }
            if (j < m-1)
            {
                D2[ind][ind+1] = 1. / hx2;
                A[ind][ind+1] = 1. / 12;
                if (i==0 || i==n-1)
                {
                    A[ind][ind+1] = 5. / 24;
                    D2[ind][ind+1] = 1.5 / hx2;
                }
            }
            if (i > 0)
            {
                D2[ind][ind-m] = 1. / hy2;
                A[ind][ind-m] = 1. / 12;
                if (j < m-1)
                    A[ind][ind-m+1] = 1. / 12;
                if (j==0 || j==m-1)
                {
                    A[ind][ind-m] = 5. / 24;
                    D2[ind][ind-m] = 1.5 / hy2;
                }
            }
            if (i < n-1)
            {
                D2[ind][ind+m] = 1. / hy2;
                A[ind][ind+m] = 1. / 12;
                if (j > 0)
                    A[ind][ind+m-1] = 1. / 12;
                if (j==0 || j==m-1)
                {
                    A[ind][ind+m] = 5. / 24;
                    D2[ind][ind+m] = 1.5 / hy2;
                }
            }
            if (i==0 || j==0 || i==n-1 || j == m-1)
                A[ind][ind] = 11. / 12;
            if (i==0 || i==n-1)
                D2[ind][ind] =  -1. / hy2 - 3. / hx2;
            if (j==0 || j == m-1)
                D2[ind][ind] =  -3. / hy2 - 1. / hx2;
            if ((i==0 || i == n-1) && (j==0 || j==m-1))
            {
                A[ind][ind] = 7. / 4;
                D2[ind][ind] =  -1.5 / hy2 - 1.5 / hx2;
            }
    }

    D2 = seidel(A, D2, 1e-7);
    auto lmax = maxEigenValue(D2);
    // формируем новый оператор, высшие собственные значения которого
    // будут низшими собственными значениями оператора D2
    auto op = -D2;
    // dirty!
    for (auto i = 0u; i < D2.size(); ++i) {
        op[i][i] += lmax.l;
    }

    cout << "calc eigens" << endl;
    auto modes = getEigens(op, count+1);
    modes.erase(modes.begin());
    vector<mode> result(count);


    // операторы частных производных
    smat Dy = ddy(m, n, hy);
    smat Dx = ddx(m, n, hx);


    for (size_t k = 0; k < count; ++k)
    {
        auto Z = modes[k].v;
        auto g2 = modes[k].l - lmax.l;
        auto h = sqrt(g2);
        auto omega = h * 1.4142 * 3e8;
        double mu = 1.257e-6;
        auto Ex = Dy * Z * (-omega * mu / g2);
        auto Ey = Dx * Z * (omega * mu / g2);
        auto Hx = Ey * (-h / omega / mu);
        auto Hy = Ex * (h / omega / mu);
        result[k] = {a, b, m, n, Z, Ex, Hx, Ey, Hy, g2};

    }
    return result;
}

string vec2npmatrix(const vec & v, size_t m, size_t n)
{
    string res = "np.array([";
    for (size_t i = 0; i < n; ++i)
    {
        res += "[";
        for (size_t j = 0; j < m; ++j)
        {
            if (j)
                res += " ";
            res += to_string(v[i * m + j]) + ",]"[j == m-1];
        }
        if (i < n - 1)
            res += ",\n";
    }
    res += "])";
    return res;
}

string mode2npmatrices(const mode & g)
{
    string res = "{\n"
    "'a' : " + to_string(g.a) + ",\n"
    "'b' : " + to_string(g.b) + ",\n"
    "'m' : " + to_string(g.m) + ",\n"
    "'n' : " + to_string(g.n) + ",\n"
    "'g2' : " + to_string(g.g2) + ",\n"
    "'x' : np.mgrid[0:" + to_string(g.b) + ":" + to_string(g.n) + "j," +
          "0:" + to_string(g.a) + ":" + to_string(g.m) + "j][1],\n"
    "'y' : np.mgrid[0:" + to_string(g.b) + ":" + to_string(g.n) + "j," +
          "0:" + to_string(g.a) + ":" + to_string(g.m) + "j][0],\n"
    "'Z' :" + vec2npmatrix(g.Z, g.m, g.n) + ",\n"
    "'Ex' :" + vec2npmatrix(g.Ex, g.m, g.n) + ",\n"
    "'Ey' :" + vec2npmatrix(g.Ey, g.m, g.n) + ",\n"
    "'Hx' :" + vec2npmatrix(g.Hx, g.m, g.n) + ",\n"
    "'Hy' :" + vec2npmatrix(g.Hy, g.m, g.n) + "\n}\n";
    return res;
}

void createPy()
{
    ofstream py;
    py.open("waves.py");
    py << "import numpy as np\n";
    py.close();
}

void write2py(const string name, const vector<mode> & modes)
{
    ofstream py;
    py.open("waves.py", ios::app);
    py << name << " = [";
    for (size_t i = 0; i < modes.size(); ++i)
    {
        py << mode2npmatrices(modes[i]) << ",\n";
    }
    py << "]\n";
    py.close();
}

void FD(double a, double b, size_t m, size_t n, size_t count)
{
    auto hw = getHwavesFD(a, b, m, n, count);
    auto ew = getEwavesFD(a, b, m, n, count);
    write2py("hwfd", hw);
    write2py("ewfd", ew);
}

void FE(double a, double b, size_t m, size_t n, size_t count)
{
    auto hw = getHwavesFE(a, b, m, n, count);
    auto ew = getEwavesFE(a, b, m, n, count);
    write2py("hwfe", hw);
    write2py("ewfe", ew);
}

int main()
{
    createPy();

    // конечные разности
    FD(0.023, 0.010, 30, 15, 2);

    // конечные элементы 
    FE(0.023, 0.010, 30, 15, 2);
}

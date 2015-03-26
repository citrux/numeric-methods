#include <fstream>
#include <cmath>
#include "linalg/eigens.hpp"

using namespace std;

struct grid {double a, b; size_t m, n; vec Z, Ex, Hx, Ey, Hy; double g2;};

vector<grid> getEwaves(double a, double b, size_t m, size_t n, size_t count)
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
    vector<grid> result(count);

    // определим парочку нужных операторов:
    smat Dy(m * n);
    smat Dx(m * n);

    // d/dy
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

    // d/dx
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


    for (size_t k = 0; k < count; ++k)
    {
        vec Z(m * n);
        for (size_t i = 0; i < n; ++i)
            if (i > 0 && i < n-1)
                for (size_t j = 1; j < m-1; ++j)
                    Z[i * m + j] = modes[k].v[(i-1) * (m-2) + (j-1)];
        auto g2 = modes[k].l - lmax.l;
        auto h = sqrt(g2);
        auto omega = h * 1.4142;
        double eps = 1;
        auto Ex = Dx * Z * (-h / g2);
        auto Ey = Dy * Z * (-h / g2);
        auto Hx = Ey * (-omega * eps / h);
        auto Hy = Ex * (omega * eps / h);
        result[k] = {a, b, m, n, Z, Ex, Hx, Ey, Hy, g2};
    }
    return result;
}

vector<grid> getHwaves(double a, double b, size_t m, size_t n, size_t count)
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
    auto modes = getEigens(op, count+1);
    vector<grid> result(count);

    // определим парочку нужных операторов:
    smat Dy(m * n);
    smat Dx(m * n);

    // d/dy
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

    // d/dx
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


    for (size_t k = 0; k < count; ++k)
    {
        auto Z = modes[k+1].v;
        auto g2 = modes[k+1].l - xmax.l;
        auto h = sqrt(g2);
        auto omega = h * 1.4142;
        double mu = 1;
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

string grid2npmatrices(const grid & g)
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

void write2py(const string fname, const vector<grid> & grids)
{
    ofstream py;
    py.open(fname);
    py << "import numpy as np\n";
    py << "modes = [";
    for (size_t i = 0; i < grids.size(); ++i)
    {
        py << grid2npmatrices(grids[i]) << ",\n";
    }
    py << "]\n";
    py.close();
}

int main()
{
    auto hw = getHwaves(5, 4, 50, 40, 3);
    auto ew = getEwaves(5, 4, 50, 40, 3);
    write2py("hw.py", hw);
    write2py("ew.py", ew);
}

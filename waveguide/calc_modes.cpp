#include <fstream>
#include "linalg/eigens.hpp"

using namespace std;

struct grid {double a, b; size_t m, n; mat data; double g2;};

mat vec2mat(const vec & v, size_t m, size_t n)
{
    mat result(m);
    for (size_t i = 0; i < m; ++i)
    {
        result[i].assign(n, 0);
        for (size_t j = 0; j < n; ++j)
            result[i][j] = v[i * n + j];
    }
    return result;
}

vector<grid> getEwaves(double a, double b, size_t m, size_t n, size_t count)
{
    smat D2((m-2) * (n-2));

    double hx = a / (m-1), hx2 = hx * hx, hy = b / (n-1), hy2 = hy * hy;
    // формируем поперечный оператор Лапласа
    for (size_t i = 0; i < m-2; ++i)
        for (size_t j = 0; j < n-2; ++j)
        {
            size_t ind = i * (n - 2) + j;
            D2[ind][ind] =  -2. / hx2 - 2. / hy2;
            if (j > 0)
                D2[ind][ind-1] = 1. / hy2;
            if (j < n-3)
                D2[ind][ind+1] = 1. / hy2;
            if (i > 0)
                D2[ind][ind-n+2] = 1. / hx2;
            if (i < m-3)
                D2[ind][ind+n-2] = 1. / hx2;
        }

    auto xmax = maxEigenValue(D2);
    // формируем новый оператор, высшие собственные значения которого
    // будут низшими собственными значениями оператора D2
    auto op = -D2 + I(D2.size()) * xmax.l;
    auto modes = getEigens(op, count);
    vector<grid> result(count);
    for (size_t k = 0; k < count; ++k)
    {
        mat data(m);
        for (size_t i = 0; i < m; ++i)
        {
            data[i].assign(n, 0);
            if (i > 0 && i < m-1)
            {
                for (size_t j = 1; j < n-1; ++j)
                    data[i][j] = modes[k].v[(i-1) * (n-2) + (j-1)];
            }
        }
        result[k] = {a, b, m, n, data, modes[k].l + xmax.l};
        if (!k)
        {
            ofstream fs;
            fs.open("e0.dat");
            for (size_t i = 0; i < m-2; ++i)
            {
                for (size_t j = 0; j < n-2; ++j)
                    fs << (i+1) * hx << " " << (j+1) * hy << " " <<
                          modes[k].v[i * (n-2) + j] << endl;
                fs << endl;
            }
            fs.close();
        }
    }
    return result;
}

vector<grid> getHwaves(double a, double b, size_t m, size_t n, size_t count)
{
    smat D2(m * n);

    double hx = a / (m-1), hx2 = hx * hx, hy = b / (n-1), hy2 = hy * hy;
    // формируем поперечный оператор Лапласа
    for (size_t i = 0; i < m; ++i)
        for (size_t j = 0; j < n; ++j)
        {
            size_t ind = i * n + j;
            D2[ind][ind] = -2 / hx2 - 2 / hy2;
            if (j > 0 && j < n-1)
            {
                D2[ind][ind-1] = 1. / hy2;
                D2[ind][ind+1] = 1. / hy2;
            }
            if (j == 0)
                D2[ind][ind+1] = 2. / hy2;
            if (j == n-1)
                D2[ind][ind-1] = 2. / hy2;

            if (i > 0 && i < m-1)
            {
                D2[ind][ind-n] = 1. / hx2;
                D2[ind][ind+n] = 1. / hx2;
            }
            if (i == 0)
                D2[ind][ind+n] = 2. / hx2;
            if (i == m-1)
                D2[ind][ind-n] = 2. / hx2;
        }

    auto xmax = maxEigenValue(D2);
    // формируем новый оператор, высшие собственные значения которого
    // будут низшими собственными значениями оператора D2
    auto op = -D2 + I(D2.size()) * xmax.l;
    auto modes = getEigens(op, count+1);
    vector<grid> result(count);
    for (size_t k = 0; k < count; ++k)
    {
        mat data = vec2mat(modes[k+1].v, m, n);
        result[k] = {a, b, m, n, data, modes[k+1].l + xmax.l};
    }
    return result;
}

string grid2npmatrix(const grid & g)
{
    string res = "np.array([";
    for (size_t i = 0; i < g.m; ++i)
    {
        res += "[";
        for (size_t j = 0; j < g.n; ++j)
        {
            if (j)
                res += " ";
            res += to_string(g.data[i][j]) + ",]"[j == g.n-1];
        }
        if (i < g.m - 1)
            res += ",\n";
    }
    res += "])";
    return res;
}

void write2py(const string fname, const vector<grid> & grids)
{
    ofstream py;
    py.open(fname);
    py << "import numpy as np\n";
    py << "import matplotlib.pyplot as plt\n";
    py << "from mpl_toolkits.mplot3d import Axes3D\n";
    py << "y,x = np.mgrid[0:" << grids[0].a << ":"<< grids[0].m <<"j," <<
          "0:" << grids[0].b << ":" << grids[0].n << "j]\n";
    for (size_t i = 0; i < grids.size(); ++i)
    {
        py << "f" << i+1 << " = " << grid2npmatrix(grids[i]) << "\n";
        py << "plt.axes(projection='3d').plot_surface(x, y, f" << i+1 <<
              ",cmap=plt.cm.jet," <<
              "rstride=1, cstride=1, linewidth=0)\n" << "plt.show()\n";
    }
    py.close();
}

int main()
{
    auto hw = getHwaves(5, 4, 30, 30, 3);
    auto ew = getEwaves(5, 4, 20, 20, 3);
    write2py("hw.py", hw);
    write2py("ew.py", ew);
}

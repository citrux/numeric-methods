#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void solveThomas(int n,
           const double const *l,
           const double const *d,
           const double const *u,
           double *r)
{
    int i;
    double d1[n];

    d1[0] = d[0];
    for (i = 0; i < n - 1; i++)
    {
        d1[i+1] = d[i+1] - u[i+1] * l[i] / d1[i];
        r[i+1] -= r[i] * l[i] / d1[i];
    }

    r[n-1] /= d1[n-1];
    for (i = n-1; i > 0; i--)
    {
        r[i-1] -= r[i] * u[i];
        r[i-1] /= d1[i-1];
    }
}

void swap3(double **a, double **b, double **c)
{
    double *tmp;
    tmp = *c;
    *c = *b;
    *b = *a;
    *a = tmp;
}

void initPlot(char *name)
{
    char fname[20];
    sprintf(fname, "%s.gp", name);
    FILE *file = fopen(fname, "w");
    fprintf(file, "set term gif ");
    fprintf(file, "animate ");
    fprintf(file, "delay 1 ");
    fprintf(file, "loop 1 ");
    fprintf(file, "size 600, 600 ");
    fprintf(file, "background \"#ffffff\" \n");
    fprintf(file, "set output '%s.gif' \n", name);
    fprintf(file, "unset key\n");
    fprintf(file, "set xrange[0:1]\n");
    fprintf(file, "set yrange[-1.2:1.2]\n");
    fprintf(file, "set grid x y\n");
    fclose(file);
}

void addToPlot(char *name, double *x, double *y, int n)
{
    char fname[20];
    sprintf(fname, "%s.gp", name);
    FILE *file = fopen(fname, "a");
    int i;

    fprintf(file, "plot \"-\" w l lw 2 lc \"#222222\"\n");
    for (i = 0; i < n; i++)
        fprintf(file, "%f %f\n", x[i], y[i]);
    fprintf(file, "end\n");

    fclose(file);
}

// Граничные условия
double a0(double t)
{
    return 0;
}

double b0(double t)
{
    return 1;
}

double c0(double t)
{
    return 0;
}

double a1(double t)
{
    return 0;
}

double b1(double t)
{
    return 1;
}

double c1(double t)
{
    return 0;
}

// Начальные условия
double u0(double x)
{
    return sin(M_PI * x);
}

double du0(double x)
{
    return 0;
}

int main(int argc, const char *argv[])
{
    char* fname;
    if (argc == 2)
        fname = argv[1];
    else
        fname = "noname";

    double l = 1,
           tmax = 20;
    int n = 100, m = 200, i, j, t;
    double dx = l / n, dt = tmax / m, r = dt * dt / dx / dx;
    double *x, *u, *up, *un, *ml, *md, *mu;

    x = calloc(sizeof(double), n + 1);
    u = calloc(sizeof(double), n + 1);
    up = calloc(sizeof(double), n + 1);
    un = calloc(sizeof(double), n + 1);
    ml = calloc(sizeof(double), n + 1);
    md = calloc(sizeof(double), n + 1);
    mu = calloc(sizeof(double), n + 1);

    t = 0;
    initPlot(fname);

    for (i = 0; i <= n; i++)
    {
        x[i] = i * dx;
        u[i] = u0(i * dx);
        up[i] = u[i] - du0(i * dx) * dt;
    }

    for (j = 0; j < m; j++)
    {
        for (i = 0; i <= n; i++)
        {
            md[i] = 1 + r / 2;
            mu[i] = ml[i] = -r / 4;

            un[i] = 2 * u[i] - up[i] +
                    r/4 * (up[i-1] - 2 * up[i] + up[i+1]) +
                    r/2 * (u[i-1]  - 2 * u[i]  + u[i+1]);
        }
        md[0] = b0(t) - a0(t) / dx;
        mu[1] = a0(t) / dx;
        un[0] = c0(t);

        md[n] = b1(t) + a1(t) / dx;
        ml[n-1] = -a1(t) / dx;
        un[n] = c1(t);

        solveThomas(n + 1, ml, md, mu, un);

        swap3(&un, &u, &up);

        addToPlot(fname, x, u, n + 1);

        t += dt;
    }
    return 0;
}

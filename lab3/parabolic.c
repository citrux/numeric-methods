#include "common.h"
#include "parabolic.h"

void solveImplicit()
{
    int i, j, t;
    double dx = l / n, dt = tmax / m, r = dt / dx / dx;
    double *x, *u, *un, *ml, *md, *mu;

    x = calloc(sizeof(double), n + 1);
    u = calloc(sizeof(double), n + 1);
    un = calloc(sizeof(double), n + 1);
    ml = calloc(sizeof(double), n + 1);
    md = calloc(sizeof(double), n + 1);
    mu = calloc(sizeof(double), n + 1);

    t = 0;
    initAnimation(fname);

    for (i = 0; i <= n; i++)
    {
        x[i] = i * dx;
        u[i] = u0(i * dx);
    }

    for (j = 0; j < m; j++)
    {
        for (i = 0; i <= n; i++)
        {
            md[i] = 1 + 2 * r;
            mu[i] = ml[i] = -r;

            un[i] = u[i] + dt * f(x[i], t);
        }
        md[0] = b0(t) - a0(t) / dx;
        mu[1] = a0(t) / dx;
        un[0] = c0(t);

        md[n] = b1(t) + a1(t) / dx;
        ml[n-1] = -a1(t) / dx;
        un[n] = c1(t);

        solveThomas(n + 1, ml, md, mu, un);

        swap(&un, &u);

        if (j % k == 0)
            addToAnimation(fname, x, u, n + 1);

        t += dt;
    }
}

void solveExplicit()
{
    int i, j, t;
    double dx = l / n, dt = tmax / m, r = dt * dt / dx / dx;
    double *x, *u, *un, *ml, *md, *mu;

    x = calloc(sizeof(double), n + 1);
    u = calloc(sizeof(double), n + 1);
    un = calloc(sizeof(double), n + 1);

    t = 0;
    initAnimation(fname);

    for (i = 0; i <= n; i++)
    {
        x[i] = i * dx;
        u[i] = u0(i * dx);
    }

    for (j = 0; j < m; j++)
    {
        for (i = 1; i < n; i++)
            un[i] = (1 - 2 * r) * u[i] +
                r * (u[i-1] + u[i+1]) + dt * f(x[i], t);

        un[0] = (c0(t) - a0(t) * un[1] / dx) / (b0(t) - a0(t) / dx);
        un[n] = (c1(t) + a1(t) * un[n-1] / dx) / (b1(t) + a1(t) / dx);

        swap(&un, &u);

        if (j % k == 0)
            addToAnimation(fname, x, u, n + 1);

        t += dt;
    }
}

int main(int argc, const char *argv[])
{
    if (implicit)
        solveImplicit();
    else
        solveExplicit();
    return 0;
}

#include "common.h"
#include "hyperbolic.h"

void solveImplicit()
{
    int i, j, t;
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
    initAnimation(fname);

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

        addToAnimation(fname, x, u, n + 1);

        t += dt;
    }
}

void solveExplicit()
{
    int i, j, t;
    double dx = l / n, dt = tmax / m, r = dt * dt / dx / dx;
    double *x, *u, *up, *un, *ml, *md, *mu;

    x = calloc(sizeof(double), n + 1);
    u = calloc(sizeof(double), n + 1);
    up = calloc(sizeof(double), n + 1);
    un = calloc(sizeof(double), n + 1);

    t = 0;
    initAnimation(fname);

    for (i = 0; i <= n; i++)
    {
        x[i] = i * dx;
        u[i] = u0(i * dx);
        up[i] = u[i] - du0(i * dx) * dt;
    }

    for (j = 0; j < m; j++)
    {
        for (i = 1; i < n; i++)
            un[i] = 2 * (1 - r) * u[i] - up[i] +
                    r * (u[i-1] + u[i+1]);

        un[0] = (c0(t) - a0(t) * un[1] / dx) / (b0(t) - a0(t) / dx);
        un[n] = (c1(t) + a1(t) * un[n-1] / dx) / (b1(t) + a1(t) / dx);

        swap3(&un, &u, &up);

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

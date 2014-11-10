#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define PI 3.14159

double source(double x, double t)
{
    return 0;
}

double initial_condition(double x)
{
    return 4*2*(0.5-fabs(x - 0.5));
}

double initial_condition2(double x)
{
    return 0;
}

double lbc_a(double t)
{
    return 0;
}

double lbc_b(double t)
{
    return 1;
}

double lbc_c(double t)
{
    return 0;
}

double rbc_a(double t)
{
    return 0;
}

double rbc_b(double t)
{
    return 1;
}

double rbc_c(double t)
{
    return 0;
}

int main(int argc, const char *argv[])
{
    double l = 1,
           tmax = 8.0;

    unsigned int n = 1000,
                 m = 200,
                 k = m / 40,
                 i, j;

    double h = l / n,
           tau = tmax / m,
           r = tau * tau / h / h;

    double *state, *prev, *tmp, *L, *U, *D;

    state = (double*) calloc(sizeof(double), n + 1);
    prev = (double*) calloc(sizeof(double), n + 1);

    L = (double*) calloc(sizeof(double), n + 1);
    U = (double*) calloc(sizeof(double), n + 1);
    D = (double*) calloc(sizeof(double), n + 1);

    for (i = 0; i <= n; i++)
    {
        prev[i] = initial_condition(i * h);
        state[i] = prev[i] + initial_condition2(i * h) * tau;
    }

    for (j = 0; j <= m; j++)
    {
        // формирование матрицы
        for (i = 0; i <= n; i++)
        {
            L[i] = -r;
            U[i] = -r;
            D[i] = 1 + 2 * r;
        }
        L[n-1] = -rbc_a(j * tau) / h;
        U[1] = lbc_a(j * tau) / h;
        D[0] = lbc_b(j * tau) - lbc_a(j * tau) / h;
        D[n] = rbc_b(j * tau) + rbc_a(j * tau) / h;

        // формирование правой части
        prev[0] = lbc_c(j * tau);

        for (i = 1; i < n; i++)
            prev[i] = -prev[i] + 2 * state[i] + tau * tau * source(i*h, j*tau);

        prev[n] = rbc_c(j * tau);

        // прогонка:
        // прямая
        for (i = 0; i < n; i++)
        {
            D[i+1] -= U[i+1] / D[i] * L[i];
            prev[i+1] -= prev[i] / D[i] * L[i];
        }
        // обратная
        prev[n] /= D[n];
        for (i = n; i > 0; i--)
        {
            prev[i-1] -= prev[i] * U[i];
            prev[i-1] /= D[i-1];
        }

        tmp = prev;
        prev = state;
        state = tmp;

        // нужно вывести, отдать gnuplot и построить графики
        if (j % k == 0)
        {
            FILE* tmp = fopen("data.tmp", "w");
            for (i = 0; i<=n; i++)
                fprintf(tmp, "%lf %lf\n", i * h, state[i]);
            fclose(tmp);
            FILE* gnuplot = popen("gnuplot", "w");
            fprintf(gnuplot, "set term pngcairo\n");
            fprintf(gnuplot, "set yrange [-5: 5]\n");
            fprintf(gnuplot, "set output \"HYP_%04d.png\"\n", j / k);
            fprintf(gnuplot, "plot \"data.tmp\" using 1:2 with lines\n");
            fclose(gnuplot);
        }
    }
    free(prev);
    free(state);
    return 0;
}


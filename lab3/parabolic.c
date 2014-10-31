#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double source(double x, double t)
{
    if (fabs(x - 0.5) < 0.01)
        return 0.1;
    return 0;
}

double initial_condition(double x)
{
    return 10 * (x - x*x);
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
    return 1;
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
           tmax = 0.3;

    unsigned int n = 1000,
                 m = 1000,
                 k = m / 20,
                 i, j;

    double h = l / n,
           tau = tmax / m,
           r = tau / h / h;

    double *state, *L, *U, *D;

    state = (double*) calloc(sizeof(double), n + 1);

    L = (double*) calloc(sizeof(double), n + 1);
    U = (double*) calloc(sizeof(double), n + 1);
    D = (double*) calloc(sizeof(double), n + 1);

    for (i = 0; i <= n; i++)
        state[i] = initial_condition(i * h);

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
        state[0] = lbc_c(j * tau);

        for (i = 1; i < n; i++)
            state[i] += source(i*h, j*tau);

        state[n] = rbc_c(j * tau);

        // прогонка:
        // прямая
        for (i = 0; i < n; i++)
        {
            D[i+1] -= U[i+1] / D[i] * L[i];
            state[i+1] -= state[i] / D[i] * L[i];
        }
        // обратная
        state[n] /= D[n];
        for (i = n; i > 0; i--)
        {
            state[i-1] -= state[i] * U[i];
            state[i-1] /= D[i-1];
        }

        // нужно вывести, отдать gnuplot и построить графики
        if (j % k == 0)
        {
            FILE* tmp = fopen("data.tmp", "w");
            for (i = 0; i<=n; i++)
                fprintf(tmp, "%lf %lf\n", i * h, state[i]);
            fclose(tmp);
            FILE* gnuplot = popen("gnuplot", "w");
            fprintf(gnuplot, "set term pngcairo\n");
            fprintf(gnuplot, "set yrange [0:12]\n");
            fprintf(gnuplot, "set output \"PAR_%04d.png\"\n", j / k);
            fprintf(gnuplot, "plot \"data.tmp\" using 1:2 with lines\n");
            fclose(gnuplot);
        }
    }
    free(L);
    free(U);
    free(D);
    free(state);
    return 0;
}


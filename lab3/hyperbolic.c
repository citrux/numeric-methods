#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double source(double x, double t)
{
    return 0;
}

double initial_condition(double x)
{
    return 10 * (x - x*x);
}

double initial_condition2(double x)
{
    return 0;
}

double lbc_a(double t)
{
    return 1;
}

double lbc_b(double t)
{
    return 0;
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
           tmax = 3;

    unsigned int n = 1000,
                 m = 5000,
                 k = m / 100,
                 i, j;

    double h = l / n,
           tau = tmax / m,
           r = tau * tau / h / h;

    if (r >= 1)
    {
        printf("r = %.2lf > 1, exit\n", r);
        return 1;
    }

    double *future, *present, *past, *tmp;

    future = (double*) calloc(sizeof(double), n + 1);
    present = (double*) calloc(sizeof(double), n + 1);
    past  = (double*) calloc(sizeof(double), n + 1);

    for (i = 0; i <= n; i++)
    {
        past[i] = initial_condition(i * h);
        present[i] = past[i] + tau * initial_condition2(i * h);
    }

    for (j = 0; j <= m; j++)
    {
        // серединка
        for (i = 1; i < n; i++)
            future[i] = r * (present[i+1] + present[i-1]) + 2 * (1 - r) * present[i] - past[i] + tau * tau * source(i*h, j*tau);
        // края
        future[0] = lbc_c(j * tau) - future[1] * lbc_a(j * tau) / h;
        future[0] /= lbc_b(j * tau) - lbc_a(j * tau) / h;
        future[n] = rbc_c(j * tau) + future[1] * rbc_a(j * tau) / h;
        future[n] /= rbc_b(j * tau) + rbc_a(j * tau) / h;
        // обмены
        tmp = past;
        past = present;
        present = future;
        future = tmp;
        // нужно вывести, отдать gnuplot и построить графики
        if (j % k == 0)
        {
            FILE* tmp = fopen("data.tmp", "w");
            for (i = 0; i<=n; i++)
                fprintf(tmp, "%lf %lf\n", i * h, present[i]);
            fclose(tmp);
            FILE* gnuplot = popen("gnuplot", "w");
            fprintf(gnuplot, "set term pngcairo\n");
            fprintf(gnuplot, "set yrange [-5: 5]\n");
            fprintf(gnuplot, "set output \"HYP_%04d.png\"\n", j / k);
            fprintf(gnuplot, "plot \"data.tmp\" using 1:2 with lines\n");
            fclose(gnuplot);
        }
    }
    free(past);
    free(present);
    free(future);
    return 0;
}


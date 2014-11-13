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
    return (x > 0.333 && x < 0.667) ? 12 * (0.166-fabs(x - 0.5)) : 0;
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
    if (argc != 4)
    {
        puts("Неправильное число аргументов!");
        printf("Пример использования: %s 1 5.0 wave1\n", argv[0]);
        puts("Подробнее в readme.md");
        return 1;
    }

    int implicit = atoi(argv[1]);
    double tmax = atof(argv[2]);
    const char* outfile = argv[3];

    double l = 1;

    unsigned int n = 100, m, i, j, k;

    double h = l / n, tau, r, fps = 10;

    if (implicit)
    {
        k = 2;
        tau = 1.0 / k / fps;
        r = tau * tau / h / h;
    }
    else
    {
        r = 0.9025;
        tau = 0.95 * h;
        k = (int) (1.0 / tau / fps);
    }

    m = (int)(tmax / tau);

    double *state, *prev, *next, *tmp, *L, *U, *D;

    state = (double*) calloc(sizeof(double), n + 1);
    prev = (double*) calloc(sizeof(double), n + 1);
    next = (double*) calloc(sizeof(double), n + 1);

    if (implicit)
    {
        L = (double*) calloc(sizeof(double), n + 1);
        U = (double*) calloc(sizeof(double), n + 1);
        D = (double*) calloc(sizeof(double), n + 1);
    }

    for (i = 0; i <= n; i++)
    {
        prev[i] = initial_condition(i * h);
        state[i] = prev[i] + initial_condition2(i * h) * tau;
    }

    FILE* gnuplot = popen("gnuplot", "w");
    fprintf(gnuplot, "set term pngcairo\n");
    fprintf(gnuplot, "set yrange [-5: 5]\n");

    for (j = 0; j <= m; j++)
    {
        if (implicit)
        {
            // формирование матрицы
            for (i = 0; i <= n; i++)
            {
                L[i] = -r / 2;
                U[i] = -r / 2;
                D[i] = 1 + r;
            }
            L[n-1] = -rbc_a(j * tau) / h;
            U[1] = lbc_a(j * tau) / h;
            D[0] = lbc_b(j * tau) - lbc_a(j * tau) / h;
            D[n] = rbc_b(j * tau) + rbc_a(j * tau) / h;

            // формирование правой части
            next[0] = lbc_c(j * tau);

            for (i = 1; i < n; i++)
                next[i] = -(1 + r) * prev[i] + 2 * state[i] +
                    r / 2 * (prev[i - 1] + prev[i + 1]) +
                    tau * tau * source(i*h, j*tau);

            next[n] = rbc_c(j * tau);

            // прогонка:
            // прямая
            for (i = 0; i < n; i++)
            {
                D[i+1] -= U[i+1] / D[i] * L[i];
                next[i+1] -= next[i] / D[i] * L[i];
            }
            // обратная
            next[n] /= D[n];
            for (i = n; i > 0; i--)
            {
                next[i-1] -= next[i] * U[i];
                next[i-1] /= D[i-1];
            }
        }
        else
        {
            // считаем середину
            for (i = 1; i < n; i++) {
                next[i] = 2 * (1 - r) * state[i] + r * (state[i-1] + state[i+1])
                      - prev[i] + tau * tau * source(i * h, j * tau);
            }
            // считаем края
            next[0] = (lbc_c(j * tau) - state[1] * lbc_a(j * tau) / h) /
                      (lbc_b(j * tau) - lbc_a(j * tau) / h);
            next[n] = (rbc_c(j * tau) + state[n-1] * rbc_a(j * tau) / h) /
                      (rbc_b(j * tau) + rbc_a(j * tau) / h);
        }

        tmp = prev;
        prev = state;
        state = next;
        next = tmp;

        // нужно вывести, отдать gnuplot и построить графики
        if (j % k == 0)
        {
            char fname[20];
            sprintf(fname, "temp/%s_%04d.tmp", outfile, j / k);
            FILE* tmp = fopen(fname, "w");
            for (i = 0; i<=n; i++)
                fprintf(tmp, "%lf %lf\n", i * h, state[i]);
            fclose(tmp);
            fprintf(gnuplot, "set output \"temp/%s_%04d.png\"\n", outfile, j / k);
            fprintf(gnuplot, "plot \"%s\" with lines title \"%f\"\n", fname, j * tau);
        }
    }
    fclose(gnuplot);
    free(prev);
    free(state);
    return 0;
}


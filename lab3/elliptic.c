#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double source(double x, double y)
{
    if (fabs(x - 0.5) < 0.01 && fabs(y - 0.5) < 0.01)
        return 1;
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
double bbc_a(double t)
{
    return 0;
}

double bbc_b(double t)
{
    return 1;
}

double bbc_c(double t)
{
    return 0;
}

double tbc_a(double t)
{
    return 0;
}
double tbc_b(double t)
{
    return 1;
}
double tbc_c(double t)
{
    return 0;
}


int main(int argc, const char *argv[])
{
    double l1 = 1,
           l2 = 1;

    unsigned int n = 100,
                 m = 100,
                 i, j;

    double h1 = l1 / n,
           h2 = l2 / m;

    double *state, eps = 1e-4, delta = 1;

    double p = h1 * h1 * h2 * h2,
           q = h1 * h1 + h2 * h2;

    state = (double*) calloc(sizeof(double), (n + 1) * (m + 1));

    int c = 100000;
    while (--c)
    {
        for (i = 0; i <= n; i++)
            state[i] = 0;
        for (i = 0; i <= n; i++)
            state[m * (n+1) + i] = 0;
        // серединка
        for (j = 1; j < m; j++)
        {
            // серединка
            for (i = 1; i < n; i++)
                state[j * (n+1) + i] = (
                    h1 * h1 * (state[j * (n+1) + i + 1] + state[j * (n+1) + i - 1])
                    + h2 * h2 * (state[(j+1) * (n+1) + i] + state[(j-1) * (n+1) + i])
                    - p * source(i * h1, j * h2)) / 2 / q;
            // края
            state[j * (n+1)] = 0;
            state[j * (n+1) + n] = 0;
        }
    }

    FILE* tmp = fopen("data.tmp", "w");
    for (j = 0; j <= m; j++)
        for (i = 0; i<=n; i++)
        fprintf(tmp, "%lf %lf %lf\n", i * h1, j * h2, state[j * (n+1) + i]);
    fclose(tmp);

    /*FILE* gnuplot = popen("gnuplot -persistent", "w");*/
    /*fprintf(gnuplot, "set term pngcairo\n");*/
    /*fprintf(gnuplot, "set contour\n");*/
    /*fprintf(gnuplot, "set output \"elliptic.png\"\n");*/
    /*fprintf(gnuplot, "splot \"data.tmp\" using 1:2:3 with lines\n");*/
    /*fclose(gnuplot);*/

    free(state);
    return 0;
}


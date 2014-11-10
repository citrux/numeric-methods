#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define PI 3.14159

double source(double x, double y)
{
    if (fabs(x - 0.01) < 0.05 && fabs(y - 0.01) < 0.05)
        return -100;
    if (fabs(x - 0.99) < 0.05 && fabs(y - 0.99) < 0.05)
        return 100;
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
    return 1;
}
double rbc_b(double t)
{
    return 0;
}
double rbc_c(double t)
{
    return 0;
}
double bbc_a(double t)
{
    return 1;
}

double bbc_b(double t)
{
    return 0;
}

double bbc_c(double t)
{
    return 0;
}

double tbc_a(double t)
{
    return 1;
}
double tbc_b(double t)
{
    return 0;
}
double tbc_c(double t)
{
    return 0;
}


int main(int argc, const char *argv[])
{
    double l = 1;

    unsigned int n = 50,
                 m = 50,
                 i, j;

    double hx = l / n,
           hy = l / m;

    double *u, eps = 1e-4, delta = 1;

    double p = 1.0 / hx / hx,
           q = 1.0 / hy / hy,
           r = 2.0 / (1 + 2 * sin(PI * hx / 2));

    u = (double*) calloc(sizeof(double), (n + 1) * (m + 1));

    int c = 100000;
    while (--c)
    {
        for (j = 0; j <= n; j++)
            u[j] = (bbc_c(0) - bbc_a(0) / hx * u[m+1+j]) / (bbc_b(0) - bbc_a(0) / hx);
        for (j = 0; j <= n; j++)
            u[n * (m+1) + j] = (tbc_c(0) + tbc_a(0) / hx * u[(n-1)*(m+1)+j]) /
                               (tbc_b(0) + tbc_a(0) / hx);
        // серединка
        for (i = 1; i < n; i++)
        {
            // серединка
            for (j = 1; j < m; j++)
                u[i * (m+1) + j] = (
                    p * (u[(i - 1) * (m+1) + j] + u[(i + 1) * (m+1) + j]) +
                    q * (u[i * (m+1) + j-1] + u[i * (m+1) + j+1])
                    - source(i * hx, j * hy)) * r / 2.0 /(p + q) +
                    (1 - r) * u[i * (m + 1) + j];
            // края
            u[i * (m+1)] = (lbc_c(0) - lbc_a(0) / hy * u[i*(m+1)+1]) /
                           (lbc_b(0) - lbc_a(0) / hy);
            u[i * (m+1) + n] = (rbc_c(0) + rbc_a(0) / hy * u[i*(m+1)+n-1]) /
                               (rbc_b(0) + rbc_a(0) / hy);
        }
    }

    FILE* tmp = fopen("data.tmp", "w");
    for (i = 0; i<=n; i++)
    {
        for (j = 0; j <= m; j++)
            fprintf(tmp, "%lf %lf %lf\n", i * hx, j * hy, u[i * (m+1) + j]);
        fprintf(tmp, "\n");
    }
    fclose(tmp);


    FILE* gnuplot = popen("gnuplot -persistent", "w");
    fprintf(gnuplot, "set term pngcairo\n");
    fprintf(gnuplot, "set dgrid3d\n");
    fprintf(gnuplot, "set contour\n");
    fprintf(gnuplot, "set view map\n");
    fprintf(gnuplot, "set samples 10\n");
    fprintf(gnuplot, "unset surface\n");
    fprintf(gnuplot, "set output \"elliptic.png\"\n");
    fprintf(gnuplot, "splot \"data.tmp\" using 1:2:3 with lines\n");
    fclose(gnuplot);

    free(u);
    return 0;
}


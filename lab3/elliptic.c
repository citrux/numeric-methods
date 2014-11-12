#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define PI 3.14159

double source(double x, double y)
{
    if (fabs(x - 0.5) < 0.05 && fabs(y - 0.5) < 0.05)
        return -1000;
    /*if (fabs(x - 0.99) < 0.05 && fabs(y - 0.99) < 0.05)*/
        /*return 1000;*/
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
    double l = 1;

    unsigned int n = 50,
                 m = 50,
                 i, j;

    double hx = l / n,
           hy = l / m;

    double *u;

    double p = 1.0 / hx / hx,
           q = 1.0 / hy / hy,
           r = 2.0 / (1 + 2 * sin(PI * hx / 2));

    u = (double*) calloc(sizeof(double), (n + 1) * (m + 1));

    double delta, delta_max = 0, eps = 1e-7;
    while (delta_max > eps || delta_max == 0)
    {
        for (j = 0; j <= n; j++)
            u[j] = (bbc_c(0) - bbc_a(0) / hx * u[m+1+j]) / (bbc_b(0) - bbc_a(0) / hx);
        for (j = 0; j <= n; j++)
            u[n * (m+1) + j] = (tbc_c(0) + tbc_a(0) / hx * u[(n-1)*(m+1)+j]) /
                               (tbc_b(0) + tbc_a(0) / hx);
        // серединка
        delta_max = 0;
        for (i = 1; i < n; i++)
        {
            // серединка
            for (j = 1; j < m; j++)
            {
                delta = (
                    p * (u[(i - 1) * (m+1) + j] + u[(i + 1) * (m+1) + j]) +
                    q * (u[i * (m+1) + j-1] + u[i * (m+1) + j+1])
                    - source(i * hx, j * hy)) * r / 2.0 /(p + q)
                    - r * u[i * (m + 1) + j];

                u[i * (m + 1) + j] += delta;
                delta_max = fmax(fmin(fabs(delta),
                                fabs(delta / u[i * (m + 1) + j])),
                                delta_max);
            }
            // края
            u[i * (m+1)] = (lbc_c(0) - lbc_a(0) / hy * u[i*(m+1)+1]) /
                           (lbc_b(0) - lbc_a(0) / hy);
            u[i * (m+1) + n] = (rbc_c(0) + rbc_a(0) / hy * u[i*(m+1)+n-1]) /
                               (rbc_b(0) + rbc_a(0) / hy);
        }
    }

    double umin = 1e100, umax = -1e100;
    for (i = 0; i < (m + 1) * (n + 1); i++)
    {
        if (u[i] > umax)
            umax = u[i];
        else if (u[i] < umin)
            umin = u[i];
    }

    FILE* tmp = fopen("data.tmp", "w");
    for (i = 0; i<=n; i++)
    {
        for (j = 0; j <= m; j++)
            fprintf(tmp, "%lf %lf %lf\n", i * hx, j * hy, u[i * (m+1) + j]);
        fprintf(tmp, "\n");
    }
    fclose(tmp);


    FILE* gnuplot = popen("gnuplot -p", "w");
    /*fprintf(gnuplot, "set term pngcairo\n");*/
    fprintf(gnuplot, "set pm3d at s\n");
    fprintf(gnuplot, "set palette rgbformulae 33, 13, 10\n");
    fprintf(gnuplot, "set contour\n");
    fprintf(gnuplot, "set hidden3d\n");
    fprintf(gnuplot, "unset key\n");
    fprintf(gnuplot, "unset clabel\n");
    fprintf(gnuplot, "set cntrparam levels incremental %lf,%lf,%lf\n",
            umin, (umax - umin) / 20, umax);
    /*fprintf(gnuplot, "set output \"elliptic.png\"\n");*/
    fprintf(gnuplot, "sp \"data.tmp\" w l ls 7 palette notitle\n");
    fprintf(gnuplot, "pause mouse close\n");
    fclose(gnuplot);

    free(u);
    return 0;
}


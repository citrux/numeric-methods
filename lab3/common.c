#include "common.h"

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

void initAnimation(char *name)
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

void addToAnimation(char *name, double *x, double *y, int n)
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



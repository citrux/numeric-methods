#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int bounds = 1;
double eps = 1e-6;
char fname[100] = "quadrupole";


double lx = 1, ly = 1;

int n = 50,
    m = 50;


double source(double x, double y)
{
    if (fabs(x - 0.25) < 0.05 && fabs(y - 0.25) < 0.05)
        return -1000;
    if (fabs(x - 0.25) < 0.05 && fabs(y - 0.5) < 0.05)
        return 1000;
    if (fabs(x - 0.75) < 0.05 && fabs(y - 0.5) < 0.05)
        return 1000;
    if (fabs(x - 0.75) < 0.05 && fabs(y - 0.75) < 0.05)
        return -1000;
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



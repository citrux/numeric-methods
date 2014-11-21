#include <stdlib.h>
#include <math.h>

char* fname = "epangle";

int implicit = 0;

double l = 1, tmax = 2;

int n = 100, m = 210, k = 10;

// Граничные условия
double a0(double t)
{
    return 0;
}

double b0(double t)
{
    return 1;
}

double c0(double t)
{
    return 0;
}

double a1(double t)
{
    return 0;
}

double b1(double t)
{
    return 1;
}

double c1(double t)
{
    return 0;
}

// Начальные условия
double u0(double x)
{
    return 2 * (l / 2 - fabs(x - l / 2));
}

// источник
double f(double x, double t)
{
    return 0;
}

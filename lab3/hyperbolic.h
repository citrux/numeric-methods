#include <stdlib.h>
#include <math.h>

char* fname = "test1";

int implicit = 1;

double l = 1, tmax = 6;

int n = 100, m = 1200, k = 5;

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
    double y = 8 * M_PI * (x - l / 2);
    return (y != 0) ? sin(y) / y : 1;
}

double du0(double x)
{
    return 0;
}

// источник
double f(double x, double t)
{
    return 0;
}

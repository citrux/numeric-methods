#include <stdlib.h>
#include <math.h>

char* fname = "esin";

int implicit = 0;

double l = 1, tmax = 2;

int n = 100, m = 200;

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
    return sin(M_PI * x);
}

double du0(double x)
{
    return 0;
}

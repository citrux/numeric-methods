#include <stdio.h>

void solveThomas(int n,
           const double const *l,
           const double const *d,
           const double const *u,
           double *r);
void swap(double **a, double **b);
void swap3(double **a, double **b, double **c);
void initAnimation(char *name);
void addToAnimation(char *name, double *x, double *y, int n);

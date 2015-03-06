#pragma once
#include "vector.hpp"

typedef vector<vec> mat;
struct srow // sparse row
{
    vector<pair<size_t, double>> data;
    double & operator [] (const size_t i);
};
typedef vector<srow> smat; // sparse matrix

vec operator * (const smat & a, const vec & b);
smat operator * (smat a, const double b);

smat operator - (smat a);
smat & operator += (smat & a, const smat & b);
smat & operator -= (smat & a, const smat & b);
smat operator + (smat a, const smat & b);
smat operator - (smat a, const smat & b);

smat I(const size_t n);

vec operator * (const mat & a, const vec & b);
mat operator * (mat a, const double b);

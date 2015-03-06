#pragma once
#include <vector>
#include <iostream>

using namespace std;

typedef vector<double> vec;

double operator * (const vec & a, const vec & b);
vec & operator *= (vec & a, const double b);
vec operator * (vec a, const double b);
vec & operator /= (vec & a, const double b);
vec operator / (vec a, const double b);
vec & operator -= (vec & a, vec b);
vec operator - (vec a, const vec & b);
ostream & operator << (ostream &os, const vec &v);
double norm(const vec & a);


#include <cmath>
#include "vector.hpp"

using namespace std;

typedef vector<double> vec;

double operator * (const vec & a, const vec & b)
{
    double res = 0;
    for (size_t i = 0; i < a.size(); ++i)
        res += a[i] * b[i];
    return res;
}

vec & operator *= (vec & a, const double b)
{
    for (auto & i : a)
        i *= b;
    return a;
}

vec operator * (vec a, const double b) { return a *= b; }

vec & operator /= (vec & a, const double b)
{
    for (size_t i = 0; i < a.size(); ++i)
        a[i] /= b;
    return a;
}

vec operator / (vec a, const double b) { return a /= b; }

vec & operator -= (vec & a, vec b)
{
    for (size_t i = 0; i < a.size(); ++i)
        a[i] -= b[i];
    return a;
}

vec operator - (vec a, const vec & b)
{
    return a -= b;
}

ostream & operator << (ostream &os, const vec &v)
{
    for(auto i : v)
        os << i << " ";
    return os;
}
double norm(const vec & a) {return sqrt(a * a);}


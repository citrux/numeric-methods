module polynomials;

import std.math : pow;

real[] polynomFromRoots(real[] roots)
{
    real[] result = [1];
    foreach(x; roots)
        result = result.addRoot(x);
    return result;
}

real[] addRoot(real[] polynom, real root)
{
    auto result = [0.0L] ~ polynom;
    auto p = polynom ~ [0.0L];
    foreach(i, ref el; result)
        el -= root * p[i];
    return result;
}

real calculatePolynom(real[] polynom, real point)
{
    real result = 0;
    foreach(i, el; polynom)
        result += el * pow(point, i);
    return result;
}

real[] removeRoot(real[] polynom, real root)
{
    auto result = new real[polynom.length - 1];
    foreach_reverse(i, ref el; result)
    {
        if (i == result.length - 1)
            el = polynom[i + 1];
        else
            el = polynom[i + 1] + result[i + 1] * root;
    }
    return result;
}

real integratePolynom(real[] polynom)
{
    real result = 0;
    foreach(i, el; polynom)
        if (i % 2 == 0)
            result += polynom[i] / (i + 1);
    return 2 * result; 
}
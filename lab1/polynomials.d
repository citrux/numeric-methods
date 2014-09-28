module polynomials;

import std.math : pow;

//  Строим многочлен по известным корням
//  > вход  : массив корней         [x1, x2, .. , xn]
//  < выход : массив коэффициентов  [a0, a1, .. , an]
real[] polynomialFromRoots(real[] roots)
{
    real[] result = [1];
    foreach(x; roots)
        result = result.addRoot(x);
    return result;
}

//  Умножаем многочлен на (x - root)
//  > вход  : массив коэффициентов  [a0, a1, .. , an] и число root
//  < выход : массив коэффициентов  [b0, b1, .. , bn+1]
real[] addRoot(real[] polynomial, real root)
{
    auto result = [0.0L] ~ polynomial;
    auto p = polynomial ~ [0.0L];
    foreach(i, ref el; result)
        el -= root * p[i];
    return result;
}

//  Считаем значение многочлена в точке point
//  > вход  : массив коэффициентов  [a0, a1, .. , an] и число point
//  < выход : число P(point)
real calculatePolynom(real[] polynomial, real point)
{
    real result = 0;
    foreach(i, el; polynomial)
        result += el * pow(point, i);
    return result;
}

//  Делит многочлен на (x - root)
//  > вход  : массив коэффициентов  [a0, a1, .. , an] и число root
//  < выход : массив коэффициентов  [b0, b1, .. , bn-1]
real[] removeRoot(real[] polynomial, real root)
{
    auto result = new real[polynomial.length - 1];
    foreach_reverse(i, ref el; result)
        if (i == result.length - 1)
            el = polynomial[i + 1];
        else
            el = polynomial[i + 1] + result[i + 1] * root;
    return result;
}

//  Интегрируем многочлен на отрезке [-1, 1]
//  > вход  : массив коэффициентов  [a0, a1, .. , an]
//  < выход : число -- значение интеграла
real integratePolynomial(real[] polynomial)
{
    real result = 0;
    foreach(i, el; polynomial)
        if (i % 2 == 0)
            result += polynomial[i] / (i + 1);
    return 2 * result; 
}

module polynomials;

import std.math : abs, pow, cos, PI;
import std.algorithm : swap;

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
real calculatePolynomial(real[] polynomial, real point)
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

//  Дифференцирует многочлен
//  > вход  : массив коэффициентов  [a0, a1, .. , an]
//  < выход : массив коэффициентов  [b0, b1, .. , bn-1]
real[] derivative(real[] polynomial)
{
    auto result = new real[polynomial.length - 1];
    foreach(i, ref p; result)
        p = polynomial[i + 1] * (i + 1);
    return result;
}

//  Превращает массив коэффициентов в функцию
//  > вход  : массив коэффициентов  [a0, a1, .. , an]
//  < выход : функция P_n(x)
auto toFunc(real[] polynomial)
{
    return delegate(real x){return calculatePolynomial(polynomial, x);};
}

// Построение n-го многочлена Лежандра
// > вход : n -- порядок многочлена Лежандра
// < выход : массив коэффициентов [a0, .. , an]
real[] lejandrePolynomial(size_t n)
{
    real[] a = [1], b = [0, 1];

    if (n == 0)
        return a;
    if (n == 1)
        return b;

    foreach(i; 1 .. n)
    {
        swap(a, b);
        b = b ~ [0.0L, 0.0L];
        auto a1 = [0.0L] ~ a;
        foreach(j; 0 .. i + 2)
            b[j] = (2 * i + 1.0L) / (i + 1.0L) * a1[j] - i / (i+1.0L) * b[j];
    }
    return b;
}

// Нахождение корней полинома Лежандра
// > вход : n -- порядок многочлена Лежандра
// < выход : массив корней [x0, .. , xn-1]
real[] lejandreRoots(size_t n)
{
    auto p_n = lejandrePolynomial(n);
    auto dp_n = derivative(p_n);

    auto f = p_n.toFunc();
    auto d = dp_n.toFunc();

    auto result = new real[n];
    real delta;

    foreach(i, ref x; result)
    {
        x = cos(PI * (4 * i + 3) / (4 * n + 2));
        do
        {
            delta = f(x) / d(x);
            x -= delta;
        } while(abs(delta) > 2.0e-4 / n);
    }
    return result;
}

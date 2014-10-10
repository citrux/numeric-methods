module integral;

import std.math : abs, sqrt, cos, tanh, sinh, cosh, PI;
import matrix;
import polynomials;

real integrate(alias method, alias f)(real left, real right, real precision)
{
    auto s1 = method!f(left, right, 4);
    auto s2 = method!f(left, right, 8);
    size_t n = 8;
    real delta = abs(s2 - s1);
    while (delta > precision)
    {
        n *= 2;
        s1 = s2;
        s2 = method!f(left, right, n);
        if (abs(s2 - s1) > 2 * delta)
            return s1;
        else
            delta = abs(s2 - s1);
    }
    return s2;
}


real adaptive(alias f)(real left, real right, size_t count, real[] points)
{
    auto h = (right - left) / count;
    auto weights = lagrangeWeights(points);
    real result = 0;
    real x = left;
    foreach(i; 0 .. count)
    {
        foreach(j, p; points)
            result += weights[j] * f(x + (p + 1) * h / 2);
        x += h;
    }
    return result * h;
}


real lagrange(alias f)(real left, real right, real[] points)
{
    auto weights = lagrangeWeights(points);
    real result = 0;
    foreach(i, p; points)
        result += weights[i] * f((left + right) / 2 + p * (right - left) / 2);
    return result * (right - left);
}


real lagrange(alias f)(real left, real right, size_t n)
{
    return lagrange!f(left, right, chebyshevRoots(n));
}


real[] lagrangeWeights(real[] points)
{
    auto p = polynomialFromRoots(points);
    auto result = new real[points.length];
    foreach(i, x; points)
    {
        auto pi = p.removeRoot(x);
        auto value = calculatePolynomial(pi, x);
        result[i] = 1.0L / 2 / value * integratePolynomial(pi);
    }
    return result;
}

auto gaussLejendre(alias f)(real left, real right, size_t n)
{
    auto d = derivative(lejendrePolynomial(n)).toFunc();
    auto roots = lejendreRoots(n);

    auto weights = new real[n];
    foreach(i, ref x; roots)
        weights[i] = 1.0L / (1 - x * x) / d(x) / d(x);

    real result = 0;
    foreach(i, x; roots)
        result += weights[i] * f((left + right) / 2 + x * (right - left) / 2);
    return result * (right - left);
}


auto gaussChebyshev(alias f)(real left, real right, size_t n)
{
    auto roots = chebyshevRoots(n);
    auto weights = new real[n];

    foreach(i, x; roots)
        weights[i] = 0.5 * PI / n * sqrt(1 - x * x);

    real result = 0;
    foreach(i, x; roots)
        result += weights[i] * f((left + right) / 2 + x * (right - left) / 2);
    return result * (right - left);
}

auto polynomial(alias f)(real left, real right, real[] points)
{
    auto n = points.length;

    auto ps = new real[n];
    foreach(i, ref p; ps)
        p = (right + left) / 2 + points[i] * (right - left) / 2;

    auto A = Matrix(n);
    auto b = Col(n);
    foreach(i, p; points)
    {
        A[i, 0] = 1;
        b[i] = f(ps[i]);
        foreach(j; 1 .. n)
            A[i, j] = A[i, j-1] * p;
    }
    auto polynomial = LUPsolve(A, b);

    real result = 0;
    foreach(i; 0 .. n)
        if (i % 2 == 0)
            result += polynomial[i] / (i + 1);

    return result * (right - left);
}


auto polynomial(alias f)(real left, real right, size_t n)
{
    return polynomial!f(left, right, chebyshevRoots(n));
}

real tanhSinh(alias f)(real left, real right, size_t n)
{
    real max = 3.0L;
    real h = 2 * max / (n - 1);

    real result = 0;
    foreach(k; 0 .. n)
    {
        auto x = -max + k * h;
        auto p = tanh(0.5 * PI * sinh(x));
        auto w = 0.5 * PI * cosh(x) /
                    pow(cosh(0.5 * PI * sinh(x)), 2);
        auto p1 = (left + right) / 2 + p * (right - left) / 2;
        result += w * f(p1);
    }

    return result * h * (right - left) / 2;
}

auto rightRectangles(alias f)(real left, real right, size_t count)
{
    return adaptive!f(left, right, count, [1.0L]);
}

auto leftRectangles(alias f)(real left, real right, size_t count)
{
    return adaptive!f(left, right, count, [-1.0L]);
}

auto middleRectangles(alias f)(real left, real right, size_t count)
{
    return adaptive!f(left, right, count, [0.0L]);
}

auto trapezoids(alias f)(real left, real right, size_t count)
{
    return adaptive!f(left, right, count, [-1.0L, 1.0L]);
}

auto parabolas(alias f)(real left, real right, size_t count)
{
    return adaptive!f(left, right, count, [-1.0L, 0.0L, 1.0L]);
}

unittest
{
    import std.math : sin, cos, sqrt, exp, log;

    bool test(real output, real answer, real precision)
    {
        return abs(output - answer) < precision;
    }

    auto f = function(real x){return sqrt(x);};
    real left = 0, right = 9, precision = 1e-4, answer = 18;

    assert(test(
        integrate!(lagrange, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(polynomial, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(gaussLejendre, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(rightRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(leftRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(middleRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(parabolas, f)(left, right, precision), answer, precision));


    f = function(real x){return sin(x);};
    left = 0, right = 3.1415926, precision = 1e-4, answer = 2;

    assert(test(
        integrate!(lagrange, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(polynomial, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(gaussLejendre, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(rightRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(leftRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(middleRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(parabolas, f)(left, right, precision), answer, precision));


    f = function(real x){return cos(x);};
    left = 0, right = 3.1415926, precision = 1e-4, answer = 0;

    assert(test(
        integrate!(lagrange, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(polynomial, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(gaussLejendre, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(rightRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(leftRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(middleRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(parabolas, f)(left, right, precision), answer, precision));


    f = function(real x){return exp(x);};
    left = 0, right = 3, precision = 1e-4, answer = exp(right) - exp(left);

    assert(test(
        integrate!(lagrange, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(polynomial, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(gaussLejendre, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(rightRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(leftRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(middleRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(parabolas, f)(left, right, precision), answer, precision));


    f = function(real x){return log(x);};
    left = 1, right = 100, precision = 1e-4;
    answer = right * log(right) - right - left * log(left) + left;

    assert(test(
        integrate!(lagrange, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(polynomial, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(gaussLejendre, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(rightRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(leftRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(middleRectangles, f)(left, right, precision), answer, precision));
    assert(test(
        integrate!(parabolas, f)(left, right, precision), answer, precision));
}

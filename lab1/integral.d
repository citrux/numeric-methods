module integral;

import std.math : abs, sqrt, cos, PI;
import matrix;
import polynomials;


real integrate(real function(real) f,
               real left, real right, real precision,
               real delegate(real function(real), real, real) stepFunc)
{
    auto s1 = integrate(f, left, right, 1, stepFunc);
    auto s2 = integrate(f, left, right, 2, stepFunc);
    size_t n = 2;
    while (abs(s1 - s2) > precision)
    {
        n *= 2;
        s1 = s2;
        s2 = integrate(f, left, right, n, stepFunc);
    }
    return s2;
}


real integrate(real function(real) f,
               real left, real right, size_t count,
               real delegate(real function(real), real, real) stepFunc)
{
    auto h = (right - left) / count;
    real result = 0;
    real x = left;
    foreach(i; 0 .. count)
    {
        result += stepFunc(f, x, x + h);
        x += h;
    }
    return result;
}


auto lagrange(real[] points)
{
    auto weights = lagrangeWeights(points);
    auto stepFunc = delegate(real function(real) f, real left, real right)
    {
        real result = 0;
        foreach(i, p; points)
            result += weights[i] * f((left + right) / 2 + p * (right - left) / 2);
        return result * (right - left);
    };
    return stepFunc;
}


auto lagrange(size_t n)
{
    return lagrange(chebyshevRoots(n));
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

auto gaussLejendre(size_t n)
{
    auto d = derivative(lejendrePolynomial(n)).toFunc();
    auto roots = lejendreRoots(n);

    auto weights = new real[n];
    foreach(i, ref x; roots)
        weights[i] = 1.0L / (1 - x * x) / d(x) / d(x);

    auto stepFunc = delegate(real function(real) f, real left, real right)
    {
        real result = 0;
        foreach(i, x; roots)
            result += weights[i] * f((left + right) / 2 + x * (right - left) / 2);
        return result * (right - left);
    };
    return stepFunc;
}

auto gaussChebyshev(size_t n)
{ 
    auto roots = chebyshevRoots(n);
    auto weights = new real[n];

    foreach(i, x; roots)
        weights[i] = 0.5 * PI / n * sqrt(1 - x * x);

    auto stepFunc = delegate(real function(real) f, real left, real right)
    {
        real result = 0;
        foreach(i, x; roots)
            result += weights[i] * f((left + right) / 2 + x * (right - left) / 2);
        return result * (right - left);
    };
    return stepFunc;
}

auto polynomial(real[] points)
{
    auto n = points.length;
    auto stepFunc = delegate(real function(real) f, real left, real right)
    {
        auto ps = new real[n];
        foreach(i, ref p; ps)
            p = (right + left) / 2 + points[i] * (right - left) / 2;

        auto A = Matrix(n);
        auto b = Col(n);
        foreach(i; 0 .. n)
        {
            A[i, 0] = 1;
            b[i] = f(ps[i]);
            foreach(j; 1 .. n)
                A[i, j] = A[i, j-1] * ps[i];
        }
        auto polynomial = LUPsolve(A, b);

        auto limits = Matrix(1, n);
        real li = left, ri = right;
        foreach(i; 0 .. n)
        {
            limits[0, i] = (ri - li) / (i + 1);
            li *= left;
            ri *= right;
        }

        return (limits * polynomial)[0, 0];
    };
    return stepFunc;
}


auto polynomial(size_t n)
{
    return polynomial(chebyshevRoots(n));
}


auto right_rectangles()
{
    return lagrange([1.0L]);
}

auto left_rectangles()
{
    return lagrange([-1.0L]);
}

auto middle_rectangles()
{
    return lagrange([0.0L]);
}

auto trapezoids()
{
    return lagrange([-1.0L, 1.0L]);
}

auto parabolas()
{
    return lagrange([-1.0L, 0.0L, 1.0L]);
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
        integrate(f, left, right, precision, lagrange(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, polynomial(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, gaussLejendre(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, right_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, left_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, middle_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, parabolas), answer, precision));

    
    f = function(real x){return sin(x);};
    left = 0, right = 3.1415926, precision = 1e-4, answer = 2;

    assert(test(
        integrate(f, left, right, precision, lagrange(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, polynomial(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, gaussLejendre(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, right_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, left_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, middle_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, parabolas), answer, precision));

    
    f = function(real x){return cos(x);};
    left = 0, right = 3.1415926, precision = 1e-4, answer = 0;

    assert(test(
        integrate(f, left, right, precision, lagrange(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, polynomial(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, gaussLejendre(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, right_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, left_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, middle_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, parabolas), answer, precision));

    
    f = function(real x){return exp(x);};
    left = 0, right = 3, precision = 1e-4, answer = exp(right) - exp(left);

    assert(test(
        integrate(f, left, right, precision, lagrange(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, polynomial(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, gaussLejendre(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, right_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, left_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, middle_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, parabolas), answer, precision));


    f = function(real x){return log(x);};
    left = 1, right = 100, precision = 1e-4;
    answer = right * log(right) - right - left * log(left) + left;

    assert(test(
        integrate(f, left, right, precision, lagrange(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, polynomial(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, gaussLejendre(10)), answer, precision));
    assert(test(
        integrate(f, left, right, precision, right_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, left_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, middle_rectangles), answer, precision));
    assert(test(
        integrate(f, left, right, precision, parabolas), answer, precision));
}

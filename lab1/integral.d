module integral;

import std.math : abs;
import polynomials;

auto integrateStep(real function(real) f, real[] points, real[] weights)
{
    auto g = delegate(real a, real b)
    {
        real result = 0;
        foreach(i, p; points)
            result += weights[i] * f((a + b) / 2 + p * (b - a) / 2) * (b - a);
        return result;
    };
    return g;
}

auto integrate(real function(real) f, real[] points, real[] weights, real left, real right, size_t count)
{
    auto h = (right - left) / count;
    real result = 0;
    real x = left;
    auto g = integrateStep(f, points, weights);
    foreach(i; 0 .. count)
    {
        result += g(x, x + h);
        x += h;
    }
    return result;
}

auto integrate(real function(real) f, real[] points, real left, real right, size_t count)
{
    return integrate(f, points, weights(points), left, right, count);
}

auto integrate(real function(real) f, uint n, real left, real right, size_t count)
{
    auto points = new real[n+1];
    foreach(i, ref el; points)
        el = -1.0L + 2.0L / n * i;
    return integrate(f, points, weights(points), left, right, count);
}

real[] weights(real[] points)
{
    auto p = polynomialFromRoots(points);
    auto result = new real[points.length];
    foreach(i, x; points)
    {
        auto pi = p.removeRoot(x);
        auto value = calculatePolynom(pi, x);
        result[i] = 1.0L / 2 / value * integratePolynomial(pi);
    }
    return result;
}

real right_rectangles(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [1.0L], left, right, count);
}

real left_rectangles(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [-1.0L], left, right, count);
}

real middle_rectangles(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [0.0L], left, right, count);
}

real trapezoids(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, 1, left, right, count);
}

real parabolas(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, 2, left, right, count);
}

unittest
{
    bool test(real output, real answer, real precision)
    {
        return abs(output - answer) < precision;
    }

    assert(test(right_rectangles(function(real x){return 1;}, -1, 1, 5),
                2, .0001));
    assert(test(right_rectangles(function(real x){return 1.0L;}, -1, 1, 8),
                2, .0001));
    assert(test(middle_rectangles(function(real x){return x;}, -1, 1, 8),
                0, .0001));
    assert(test(left_rectangles(function(real x){return x * x;}, -1, 1, 8),
                2.0 / 3, .1));
}
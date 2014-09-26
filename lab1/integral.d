module integral;

import std.math : abs;

auto integrate_step(real function(real) f, real[] points, real[] weights)
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
    auto g = integrate_step(f, points, weights);
    foreach(i; 0 .. count)
    {
        result += g(x, x + h);
        x += h;
    }
    return result;
}

real right_rectangles(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [1], [1], left, right, count);
}

real left_rectangles(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [-1], [1], left, right, count);
}

real middle_rectangles(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [0], [1], left, right, count);
}

real trapezoids(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [-1, 1], [1.0/2, 1.0/2], left, right, count);
}

real parabolas(real function(real) f, real left, real right, size_t count)
{
    return integrate(f, [-1, 0, 1], [1.0/6, 4.0/6, 1.0/6], left, right, count);
}

unittest
{
    //bool test(real function(real function(real), real, real, size_t) method,
    //          real function(real) f, real left, real right, size_t count,
    //          real answer, real precision)
    //{
    //    auto integral = method(f, left, right, count);
    //    return abs(integral - answer) < precision;
    //}
    //assert(test(right_rectangles, function(real x){return 1;}, -1, 1, 5, 2, .0001));
    assert(abs(right_rectangles(function(real x){return 1.0L;}, -1, 1, 8) - 2) < .0001);
    assert(abs(middle_rectangles(function(real x){return x;}, -1, 1, 8) - 0) < .0001);
    assert(abs(left_rectangles(function(real x){return x * x;}, -1, 1, 8) - 2.0 / 3) < .1);
}
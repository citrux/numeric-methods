module integral;

import std.math : abs;

real right_rectangles(real function(real) f, real left, real right, size_t count)
{
    auto h = (right - left) / count;
    real result = 0;
    real x = left;
    foreach(i; 0 .. count)
    {
        x += h;
        result += f(x) * h;
    }
    return result;
}

real left_rectangles(real function(real) f, real left, real right, size_t count)
{
    auto h = (right - left) / count;
    real result = 0;
    real x = left;
    foreach(i; 0 .. count)
    {
        result += f(x) * h;
        x += h;
    }
    return result;
}

real middle_rectangles(real function(real) f, real left, real right, size_t count)
{
    auto h = (right - left) / count;
    real result = 0;
    real x = left + h / 2;
    foreach(i; 0 .. count)
    {
        result += f(x) * h;
        x += h;
    }
    return result;
}

real parabolas(real function(real) f, real left, real right, size_t count)
{
    auto h = (right - left) / count;
    real result = 0;
    real x = left;
    foreach(i; 0 .. count)
    {
        result += (f(x) + 4 * f(x + h / 2) + f(x + h)) * h / 6;
        x += h;
    }
    return result;
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
    assert(abs(right_rectangles(function(real x){return 1.0L;}, -1, 1, 5) - 2) < .0001);
    assert(abs(middle_rectangles(function(real x){return x;}, -1, 1, 5) - 0) < .0001);
    assert(abs(left_rectangles(function(real x){return x * x;}, -1, 1, 5) - 2.0 / 3) < .01);
}
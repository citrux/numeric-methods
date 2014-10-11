module main;

import integral;

import std.stdio;
import std.math;
import std.datetime;

void test(real function(real) f, real left, real right, size_t n)
{
    SysTime ts;
    real t, s;

    ts = Clock.currTime();
    s = lagrange!f(left, right, n);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("lagrange       : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = polynomial!f(left, right, n);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("polynomial     : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = gaussLejendre!f(left, right, n);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("gaussLejendre  : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = gaussChebyshev!f(left, right, n);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("gaussChebyshev : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = tanhSinh!f(left, right, n);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("tanhSinh       : %4.3f, %4.3f ms", s, t);

    writeln();
}

void testPrec(real function(real) f, real left, real right, real precision)
{
    SysTime ts;
    real t, s;

    ts = Clock.currTime();
    s = integrate!(leftRectangles, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("leftRectangles   : %4.3f , %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(rightRectangles, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("rightRectangles  : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(middleRectangles, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("middleRectangles : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(trapezoids, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("trapezoids       : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(parabolas, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("parabolas        : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(polynomial, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("polynomial       : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(lagrange, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("lagrange         : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(gaussLejendre, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("gaussLejendre    : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(gaussChebyshev, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("gaussChebyshev   : %4.3f, %4.3f ms", s, t);

    ts = Clock.currTime();
    s = integrate!(tanhSinh, f)(left, right, precision);
    t = (Clock.currTime().stdTime() - ts.stdTime()) / 10000.0L;
    writefln("tanhSinh         : %4.3f, %4.3f ms", s, t);
    writeln();

    writeln();
}

void demo()
{
    real left = 0, right = 4;
    size_t n;

    auto f = function(real x){return 1 / sqrt(x);};
    n = 5;
    writeln("int_0^4 1 / sqrt(x) dx по 5 точкам: ");
    test(f, left, right, n);

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    n = 3;
    writeln("int_0^4 1 / sqrt(x(4-x)) dx по 3 точкам: ");
    test(f, left, right, n);

    f = function(real x){return sqrt(x * (4 - x));};
    n = 3;
    writeln("int_0^4 sqrt(x(4-x)) dx по 3 точкам: ");
    test(f, left, right, n);

    f = function(real x){return sqrt(x);};
    n = 15;
    writeln("int_0^4 sqrt(x) dx по 15 точкам: ");
    test(f, left, right, n);

    f = function(real x){return x;};
    n = 2;
    writeln("int_0^4 x dx по 2 точкам: ");
    test(f, left, right, n);

    f = function(real x){return 1;};
    n = 15;
    writeln("int_0^4 dx по 15 точкам: ");
    test(f, left, right, n);

    f = function(real x){return 1 + x + x * x + x * x * x;};
    n = 2;
    writeln("int_0^4 x^3 + x^2 + x + 1 dx по 2 точкам: ");
    test(f, left, right, n);

    f = function(real x){return log(x);};
    n = 10;
    writeln("int_0^1 ln x dx по 10 точкам: ");
    test(f, left, 1, n);

    f = function(real x){return log(x) / sqrt(x);};
    n = 10;
    writeln("int_0^1 ln x / sqrt(x) dx по 10 точкам: ");
    test(f, left, 1, n);
}


void demoPrecision()
{
    real left = 0, right = 4, precision = 1e-3;

    writeln("Интегрирование с точностью ", precision);
    auto f = function(real x){return 1 / sqrt(x);};
    writeln("int_0^4 1 / sqrt(x) dx");
    testPrec(f, left, right, precision);

    f = function(real x){return 1 / sqrt(x * (4 - x));};
    writeln("int_0^4 1 / sqrt(x(4-x)) dx: ");
    testPrec(f, left, right, precision);

    f = function(real x){return sqrt(x * (4 - x));};
    writeln("int_0^4 sqrt(x(4-x)) dx: ");
    testPrec(f, left, right, precision);

    f = function(real x){return sqrt(x);};
    writeln("int_0^4 sqrt(x) dx: ");
    testPrec(f, left, right, precision);

    f = function(real x){return x;};
    writeln("int_0^4 x dx: ");
    testPrec(f, left, right, precision);

    f = function(real x){return 1;};
    writeln("int_0^4 dx: ");
    testPrec(f, left, right, precision);

    f = function(real x){return 1 + x + x * x + x * x * x;};
    writeln("int_0^4 x^3 + x^2 + x + 1 dx: ");
    testPrec(f, left, right, precision);

    f = function(real x){return log(x);};
    right = 1;
    writeln("int_0^1 ln x dx: ");
    testPrec(f, left, right, precision);

    //f = function(real x){return log(x) / sqrt(x);};
    //writeln("int_0^1 ln x / sqrt(x) dx: ");
    //testPrec(f, left, right, precision);
}


void main()
{
    demo();
    demoPrecision();
}


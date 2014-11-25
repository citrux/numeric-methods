from math import log2, sin, cos, tan, atan, pi, e
from cmath import phase
from matplotlib import rc, pyplot as plt
import random


def bit_reverse(i, n):
    res = 0
    while i:
        n //= 2
        res += (i % 2) * n
        i //= 2
    return res


def bit_reverse_permutation(x):
    n = len(x)
    y = [0] * n
    for i in range(n):
        y[i] = x[bit_reverse(i, n)]
    return y


def fft(x, inverse=False):
    y = bit_reverse_permutation(x)
    n = len(x)
    for s in range(int(log2(n))):
        m = 2 ** (s + 1)
        wm = e ** (2j * pi / m)

        if inverse:
            wm = 1 / wm

        for k in range(0, n, m):
            w = 1
            for j in range(m // 2):
                t = w * y[k + j + m // 2]
                u = y[k + j]
                y[k + j] = u + t
                y[k + j + m // 2] = u - t
                w *= wm

    if inverse:
        y = [i / n for i in y]
    return y;


def main():
    rc("font", family="Open Sans", size=12)
    n = 128
    x = list(range(n))
    #s = [e ** (-3 * i / n) for i in range(n)]
    #s = [sin(6 * 2 * pi * i / n) + sin(8 * 2 * pi * i / n) for i in range(n)]
    s = [e ** (-2 * i / n) * sin(6 * 2 * pi * i / n) for i in range(n)]
    a = fft(s)
    c = fft(a, inverse=True)

    plt.subplot(221)
    plt.vlines(x, 0, s)
    plt.plot(c, "g-", lw=0.5)
    plt.grid(True)
    plt.axhline(y=0, color='black')
    plt.axvline(x=0, color='black')

    plt.subplot(222)
    plt.vlines(x, 0, [i.real for i in a], 'r')
    plt.vlines(x, 0, [i.imag for i in a], 'b')
    plt.plot([i.real for i in a], 'r', lw=0.5, label="real")
    plt.plot([i.imag for i in a], 'b', lw=0.5, label="imag")
    plt.legend();
    plt.grid(True)
    plt.axhline(y=0, color='black')
    plt.axvline(x=0, color='black')
    plt.subplot(223)
    plt.grid(True)
    plt.axhline(y=0, color='black')
    plt.axvline(x=0, color='black')
    plt.vlines(x, 0, [abs(a[i]) for i in range(n)])
    plt.subplot(224)
    plt.grid(True)
    plt.axhline(y=0, color='black')
    plt.axvline(x=0, color='black')
    plt.vlines(x, 0, [phase(a[i]) for i in range(n)])
    plt.show()


if __name__ == '__main__':
    main()

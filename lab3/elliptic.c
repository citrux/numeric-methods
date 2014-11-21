#include "elliptic.h"

#define mod(x, y) (((x) % (y) + (y)) % (y))
#define u(i, j) u[(mod (i, n+1)) * (m + 1) + (mod(j, m+1))]

int main(int argc, const char *argv[])
{
    int i, j;
    double hx = lx / n,
           hy = ly / m;

    double *u;

    double p = 1.0 / hx / hx,
           q = 1.0 / hy / hy,
           r = 2.0 / (1 + 2 * sin(M_PI * hx / 2));

    u = (double*) calloc(sizeof(double), (n + 1) * (m + 1));

    double delta, delta_max = 0;
    while (delta_max > eps || delta_max == 0)
    {
        delta_max = 0;
        if (bounds)
        {
            for (j = 0; j <= m; j++)
                u(0, j) = (bbc_c(0) - bbc_a(0) / hx * u(1, j)) /
                    (bbc_b(0) - bbc_a(0) / hx);
            for (j = 0; j <= m; j++)
                u(n, j) = (tbc_c(0) + tbc_a(0) / hx * u(n-1, j)) /
                    (tbc_b(0) + tbc_a(0) / hx);
            // серединка
            for (i = 1; i < n; i++)
            {
                // серединка
                for (j = 1; j < m; j++)
                {
                    delta = (
                        p * (u(i-1, j) + u(i + 1, j)) +
                        q * (u(i, j-1) + u(i, j+1))
                        - source(i * hx, j * hy)) * r / 2.0 /(p + q)
                        - r * u(i, j);

                    u(i, j) += delta;
                    delta_max = fmax(fmin(fabs(delta),
                                    fabs(delta / u(i, j))),
                                    delta_max);
                }
                // края
                u(i,0) = (lbc_c(0) - lbc_a(0) / hy * u[i, 1]) /
                               (lbc_b(0) - lbc_a(0) / hy);
                u(i,n) = (rbc_c(0) + rbc_a(0) / hy * u[i, n-1]) /
                                   (rbc_b(0) + rbc_a(0) / hy);
            }
        }
        else
        {
             for (i = 0; i <= n; i++)
            {
                for (j = 0; j <= m; j++)
                {
                    delta = (
                        p * (u(i-1, j) + u(i + 1, j)) +
                        q * (u(i, j-1) + u(i, j+1))
                        - source(i * hx, j * hy)) * r / 2.0 /(p + q)
                        - r * u(i, j);

                    u(i, j) += delta;
                    delta_max = fmax(fmin(fabs(delta),
                                    fabs(delta / u(i, j))),
                                    delta_max);
                }
            }
        }
        printf("\b\b\b\b\b\b\b\b%f", delta_max);
    }
    double umin = 1e100, umax = -1e100;
    for (i = 0; i < (m + 1) * (n + 1); i++)
    {
        if (u[i] > umax)
            umax = u[i];
        else if (u[i] < umin)
            umin = u[i];
    }

    FILE* gp = popen("gnuplot -p", "w");
    fprintf(gp, "set pm3d at s\n");
    fprintf(gp, "set palette rgbformulae 33, 13, 10\n");
    fprintf(gp, "set contour\n");
    fprintf(gp, "set hidden3d\n");
    fprintf(gp, "unset key\n");
    fprintf(gp, "unset clabel\n");
    fprintf(gp, "set cntrparam levels incremental %lf,%lf,%lf\n",
            umin, (umax - umin) / 20, umax);
    fprintf(gp, "sp \"-\" w l ls 7 palette notitle\n");
    for (i = 0; i<=n; i++)
    {
        for (j = 0; j <= m; j++)
            fprintf(gp, "%lf %lf %lf\n", i * hx, j * hy, u(i,j));
        fprintf(gp, "\n");
    }

    fprintf(gp, "end\n");
    fprintf(gp, "pause mouse close\n");
    fclose(gp);

    free(u);
    return 0;
}


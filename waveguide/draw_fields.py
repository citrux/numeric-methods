import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import ew
import hw


def plot_fields(t, i, f):
    # plt.cla()
    # print(">  plot %s_z 3d" % t)
    # ax = plt.axes(projection='3d')
    # ax.plot_surface(f['x'], f['y'], f['Z'], cmap=plt.cm.jet, rstride=1,
    #                 cstride=1, linewidth=0)
    # print(">  save")
    # plt.xlabel("$x$")
    # plt.ylabel("$y$")
    # ax.set_zlabel("$%s_z$" % t)
    # plt.tick_params(reset=True)
    # plt.savefig(t + "%d_z.png" % (i + 1))

    # plt.cla()
    # plt.axes(projection='rectilinear')
    # print(">  plot E_perp")
    # plt.streamplot(f['x'], f['y'], f['Ex'], f['Ey'], color='k')
    # print(">  plot H_perp")
    # plt.streamplot(f['x'], f['y'], f['Hx'], f['Hy'], color='b')
    # print(">  save")
    # plt.xlabel("$x$")
    # plt.ylabel("$y$")
    # plt.xlim([0, f['a']])
    # plt.ylim([0, f['b']])
    # plt.tick_params(
    #     axis='both',
    #     which='both',
    #     bottom='off',
    #     top='off',
    #     left='off',
    #     right='off',
    #     labelbottom='off',
    #     labeltop='off',
    #     labelleft='off',
    #     labelright='off')
    # plt.title("$a = %.2f,\ b = %.2f,\ g^2 = %4f$" % (f['a'], f['b'], f['g2']))
    # plt.savefig(t + "%d_xy.png" % (i + 1))

    if t == "E":
        plt.cla()
        z_min , z_max = 0, 2 * np.pi
        z_points = np.linspace(z_min, z_max, 21)
        Ez = f["Z"][f["n"] // 4,:].reshape(f["m"], 1) * np.cos(z_points)
        Ex = f["Ex"][f["n"] // 4,:].reshape(f["m"], 1) * np.sin(z_points) 
        plt.streamplot(z_points, np.linspace(0, f['a'], f['m']), Ez, Ex, color='k')
        plt.xlabel("$z$")
        plt.ylabel("$x$")
        plt.xlim([z_min, z_max])
        plt.ylim([0, f['a']])
        plt.tick_params(
            axis='both',
            which='both',
            bottom='off',
            top='off',
            left='off',
            right='off',
            labelbottom='off',
            labeltop='off',
            labelleft='off',
            labelright='off')
        plt.title("$E_{zx},\ a = %.2f,\ b = %.2f,\ g^2 = %4f$" % (f['a'], f['b'], f['g2']))
        plt.savefig(t + "%d_zx.png" % (i + 1))

        plt.cla()
        Ez = f["Z"][:,f["m"] // 4].reshape(f["n"], 1) * np.cos(z_points)
        Ey = f["Ey"][:,f["m"] // 4].reshape(f["n"], 1) * np.sin(z_points) 
        plt.streamplot(z_points, np.linspace(0, f['b'], f['n']), Ez, Ey, color='k')
        plt.xlabel("$z$")
        plt.ylabel("$y$")
        plt.xlim([z_min, z_max])
        plt.ylim([0, f['b']])
        plt.tick_params(
            axis='both',
            which='both',
            bottom='off',
            top='off',
            left='off',
            right='off',
            labelbottom='off',
            labeltop='off',
            labelleft='off',
            labelright='off')
        plt.title("$E_{zy},\ a = %.2f,\ b = %.2f,\ g^2 = %4f$" % (f['a'], f['b'], f['g2']))
        plt.savefig(t + "%d_zy.png" % (i + 1))
    else:
        plt.cla()
        z_min , z_max = 0, 2 * np.pi
        z_points = np.linspace(z_min, z_max, 21)
        Hz = f["Z"][f["n"] // 4,:].reshape(f["m"], 1) * np.cos(z_points)
        Hx = f["Hx"][f["n"] // 4,:].reshape(f["m"], 1) * np.sin(z_points) 
        plt.streamplot(z_points, np.linspace(0, f['a'], f['m']), Hz, Hx, color='b')
        plt.xlabel("$z$")
        plt.ylabel("$x$")
        plt.xlim([z_min, z_max])
        plt.ylim([0, f['a']])
        plt.tick_params(
            axis='both',
            which='both',
            bottom='off',
            top='off',
            left='off',
            right='off',
            labelbottom='off',
            labeltop='off',
            labelleft='off',
            labelright='off')
        plt.title("$H_{zx},\ a = %.2f,\ b = %.2f,\ g^2 = %4f$" % (f['a'], f['b'], f['g2']))
        plt.savefig(t + "%d_zx.png" % (i + 1))

        plt.cla()
        Hz = f["Z"][:,f["m"] // 4].reshape(f["n"], 1) * np.cos(z_points)
        Hy = f["Hy"][:,f["m"] // 4].reshape(f["n"], 1) * np.sin(z_points) 
        plt.streamplot(z_points, np.linspace(0, f['b'], f['n']), Hz, Hy, color='b')
        plt.xlabel("$z$")
        plt.ylabel("$y$")
        plt.xlim([z_min, z_max])
        plt.ylim([0, f['b']])
        plt.tick_params(
            axis='both',
            which='both',
            bottom='off',
            top='off',
            left='off',
            right='off',
            labelbottom='off',
            labeltop='off',
            labelleft='off',
            labelright='off')
        plt.title("$H_{zy},\ a = %.2f,\ b = %.2f,\ g^2 = %4f$" % (f['a'], f['b'], f['g2']))
        plt.savefig(t + "%d_zy.png" % (i + 1))


def main():
    for i, f in enumerate(ew.modes):
        print("E_%d" % (i+1))
        plot_fields("E", i, f)

    for i, f in enumerate(hw.modes):
        print("H_%d" % (i+1))
        plot_fields("H", i, f)

if __name__ == '__main__':
    main()

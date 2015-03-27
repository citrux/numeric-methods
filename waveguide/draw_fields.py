import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import ew
import hw

def remove_ticks():
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


def set_labels(xlabel, ylabel):
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)


def set_limits(xlims, ylims):
    plt.xlim(xlims)
    plt.ylim(ylims)


def create_streamplot(x, y, fx, fy, color):
    f = np.sqrt(fx * fx + fy * fy)
    fmax = f.max()
    lw = 1.5 * f / fmax
    plt.streamplot(x, y, fx, fy, color=color, linewidth=lw)
    set_limits([x.min(), x.max()], [y.min(), y.max()])
    remove_ticks()


def plot_fields(t, i, f):
    plt.cla()
    print(">  plot %s_z 3d" % t)
    ax = plt.axes(projection='3d')
    ax.plot_surface(f['x'], f['y'], f['Z'], cmap=plt.cm.jet, rstride=1,
                    cstride=1, linewidth=0)
    print(">  save")
    set_labels("$x$", "$y$")
    ax.set_zlabel("$%s_z$" % t)
    plt.tick_params(reset=True)
    plt.savefig(t + "%d_z.png" % (i + 1))

    plt.cla()
    plt.axes(projection='rectilinear').set_aspect("equal")
    
    print(">  plot E_xy")
    create_streamplot(f['x'], f['y'], f['Ex'], f['Ey'], 'k')
    
    print(">  plot H_xy")
    create_streamplot(f['x'], f['y'], f['Hx'], f['Hy'], 'b')
    
    print(">  save")
    set_labels("$x$", "$y$")
    plt.title("$a = %.2e,\ b = %.2e,\ g^2 = %4e$" % (f['a'], f['b'], f['g2']))
    plt.savefig(t + "%d_xy.png" % (i + 1))

    h = f['g2'] ** .5
    z_min , z_max = 0, 2 * np.pi / h
    z_points = np.linspace(z_min, z_max, 51)
    x_points = np.linspace(0, f['a'], f['m'])
    y_points = np.linspace(0, f['b'], f['n'])

    if t == "E":
        print(">  plot %s_xz" % t)
        plt.cla()
        Ez = f["Z"][f["n"] // 4,:].reshape(f["m"], 1) * np.cos(h * z_points)
        Ex = f["Ex"][f["n"] // 4,:].reshape(f["m"], 1) * np.sin(h * z_points) 
        create_streamplot(z_points, x_points, Ez, Ex, 'k')
        set_labels("$z$", "$x$")
        plt.title("$E_{zx},\ a = %.2e,\ b = %.2e,\ g^2 = %4e$" % (f['a'], f['b'], f['g2']))
        print(">  save")
        plt.savefig(t + "%d_zx.png" % (i + 1))

        print(">  plot %s_yz" % t)
        plt.cla()
        Ez = f["Z"][:,f["m"] // 4].reshape(f["n"], 1) * np.cos(h * z_points)
        Ey = f["Ey"][:,f["m"] // 4].reshape(f["n"], 1) * np.sin(h * z_points) 
        create_streamplot(z_points, y_points, Ez, Ey, 'k')
        set_labels("$z$", "$y$")

        plt.title("$E_{zy},\ a = %.2e,\ b = %.2e,\ g^2 = %4e$" % (f['a'], f['b'], f['g2']))
        print(">  save")
        plt.savefig(t + "%d_zy.png" % (i + 1))
    else:
        print(">  plot %s_xz" % t)
        plt.cla()
        z_min , z_max = 0, 2 * np.pi / h
        z_points = np.linspace(z_min, z_max, 21)
        Hz = f["Z"][f["n"] // 4,:].reshape(f["m"], 1) * np.cos(h * z_points)
        Hx = f["Hx"][f["n"] // 4,:].reshape(f["m"], 1) * np.sin(h * z_points)
        
        create_streamplot(z_points, x_points, Hz, Hx, 'b')
        set_labels("$z$", "$x$")
        plt.title("$H_{zx},\ a = %.2e,\ b = %.2e,\ g^2 = %4e$" % (f['a'], f['b'], f['g2']))
        print(">  save")
        plt.savefig(t + "%d_zx.png" % (i + 1))

        print(">  plot %s_yz" % t)
        plt.cla()
        Hz = f["Z"][:,f["m"] // 4].reshape(f["n"], 1) * np.cos(h * z_points)
        Hy = f["Hy"][:,f["m"] // 4].reshape(f["n"], 1) * np.sin(h * z_points)
        
        create_streamplot(z_points, y_points, Hz, Hy, 'b')
        set_labels("$z$", "$y$")
        plt.title("$H_{zy},\ a = %.2e,\ b = %.2e,\ g^2 = %4e$" % (f['a'], f['b'], f['g2']))
        print(">  save")
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

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
import numpy as np

def main():
    nerve_range = np.arange(100)
    aggro_range = np.arange(100)
    fatigue_range = np.arange(100)
    
    data_to_plot = np.zeros((len(aggro_range), len(nerve_range)))
    fatigue_constant = 100
    for idx, x in enumerate(aggro_range):
        for idy, y in enumerate(nerve_range):
            data_to_plot[idy, idx] = (x**2 - 2*y**1.6) / 150 + fatigue_constant

    data_to_plot[data_to_plot > 100] = 100
    data_to_plot[data_to_plot < 0] = 0

    fig = plt.figure(figsize=(8, 8))
    ax = fig.add_subplot(111, projection='3d')
    ax.view_init(35, -135)

    x, y = np.meshgrid(nerve_range, aggro_range)

    ax.plot_surface(x, y, data_to_plot)

    plt.xlabel("Nerve")
    plt.ylabel("Aggro")
    ax.set_zlim([0, 100])

    plt.show()



    # fig = plt.figure()
    # ax = fig.add_subplot(111, projection='3d')
    # ax.view_init(45, 60)

    # ax.plot_surface(aggro_surface, nerve_surface, fatigue_range, facecolors=cm.Oranges(chance))

if __name__ == "__main__":
    main()
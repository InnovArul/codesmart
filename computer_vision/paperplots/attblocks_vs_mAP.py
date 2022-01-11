import matplotlib.pyplot as plt
plt.style.use('science')

config = {
  "x": "num_blocks",
  "num_blocks": [1,2,3,4,5,6,7,8,9,10],
  "y": ["ped_mAP", "veh_mAP", "gflops", "params"],
  "ped_mAP": [61.67, 65.11, 67.29, 67.8, 68.78, 69.33, 69.06, 69.44, 69.45, 69.05],
  "veh_mAP": [43.17, 48.66, 52.54, 53.78, 54.87, 55.75, 57.92, 58.35, 58.72, 59.21],
  "gflops": [34.49, 65.9, 97.3, 128.71, 160.12, 191.52, 222.93, 254.34, 285.74, 317.15],
  "params": [0.24, 0.26, 0.29, 0.32, 0.34, 0.37, 0.39, 0.42, 0.44, 0.47],
  "x_label": "#within-center attention blocks",
  "y_labels": ["Pedestrian mAP", "Vehicle mAP", "GFlops", "#Params (M)"],
  "is_same_y": [True, True, False, False],
}

def make_patch_spines_invisible(ax):
    ax.set_frame_on(True)
    ax.patch.set_visible(False)
    for sp in ax.spines.values():
        sp.set_visible(False)


fig, host = plt.subplots()
fig.subplots_adjust(right=0.75)

par1 = host.twinx()
par2 = host.twinx()

# Offset the right spine of par2.  The ticks and label have already been
# placed on the right by twinx above.
par2.spines["right"].set_position(("axes", 1.2))
# Having been created by twinx, par2 has its frame off, so the line of its
# detached spine is invisible.  First, activate the frame but make the patch
# and spines invisible.
make_patch_spines_invisible(par2)
# Second, show the right spine.
par2.spines["right"].set_visible(True)

p1, = host.plot(config[config['x']], config[config["y"][0]], label="Density")
p2, = host.plot(config[config['x']], config[config["y"][1]], label="Density")
p3, = par1.plot(config[config['x']], config[config["y"][2]], label="Temperature")
p4, = par2.plot(config[config['x']], config[config["y"][3]], label="Velocity")

host.set_xlim(0, 11)
host.set_ylim(30, 80)
par1.set_ylim(20, 750)
par2.set_ylim(0.1, 0.8)

host.set_xlabel("Distance")
host.set_ylabel("Density")
par1.set_ylabel("Temperature")
par2.set_ylabel("Velocity")

host.yaxis.label.set_color(p1.get_color())
par1.yaxis.label.set_color(p2.get_color())
par2.yaxis.label.set_color(p3.get_color())

tkw = dict(size=4, width=1.5)
host.tick_params(axis='y', colors=p1.get_color(), **tkw)
par1.tick_params(axis='y', colors=p2.get_color(), **tkw)
par2.tick_params(axis='y', colors=p3.get_color(), **tkw)
host.tick_params(axis='x', **tkw)

lines = [p1, p2, p3]

host.legend(lines, [l.get_label() for l in lines])

plt.show()

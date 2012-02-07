#!/usr/bin/env python

# plot pyevolve statistics file

import numpy as np
import pylab as pl

# intrinsic / hw
# datafile = "ga-hw/data/ga2-hw-run2-stats-len016-popsz010-numgen030-mutrate0.02.csv"
# simulation
# datafile = "ga-hw/data/ga2-sim-run3-stats-len016-popsz010-numgen020-mutrate0.02.csv"
# simulation
datafile = "ga-hw/data/ga2-sim-run2-stats-len128-popsz020-numgen300-mutrate0.01.csv"
rec = np.genfromtxt(datafile, delimiter=";")


# pl.plot(rec[:,1:10])

# 03: rawMin
# 04: rawAvg
# 05: fitMin
# 08: fitAvg
# 09: fitMax
# 10: rawMax

# these indices vs. values are weird
data_indices = [2,7,9]
pl.plot(rec[:,data_indices])
# raw fit only
# pl.plot(rec[:,[4,7,8]])
# raw only
# pl.plot(rec[:,[2,3,9]])
pl.legend(("Min", "Avg", "Max"))
pl.show()

# save data for pgf plotting
for data_index in data_indices:
    if data_index == 2:
        data_name = "min"
    elif data_index == 7:
        data_name = "avg"
    elif data_index == 9:
        data_name = "max"
    t = np.arange(len(rec))
    pgfplotfile = re.sub("\.csv$", "-%d-%s.dat" % (data_index, data_name), datafile)
    # print pgfplotfile
    np.savetxt(pgfplotfile, np.vstack((t, rec[:,data_index])).T)

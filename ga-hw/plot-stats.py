#!/usr/bin/env python

# plot pyevolve statistics file

import numpy as np
import pylab as pl

# rec = np.recfromcsv("/home/src/HDL/evol/stats.csv", delimiter=";")
rec = np.genfromtxt("/home/src/HDL/evol/stats.csv", delimiter=";")

# pl.plot(rec[:,1:10])

# 9: fitMax
# 10: rawMax
# 5: fitMin
# 3: rawMin
# 8: fitAvg
# 4: rawAvg

pl.plot(rec[:,[2,7,9]])
pl.show()

#!/usr/bin/env python

# bitfile analysis: use fft on xilinx bitstream

import pywt
import numpy as np
from matplotlib import pylab as pl
#from scipy import he

def bin(s):
    return str(s) if s<=1 else bin(s>>1) + str(s&1)

def pad2eight(s):
    return '0' * (8 - len(s)) + s

#file = '/home/lib/projects/hwsv/DPR/experiments/reconf_linux/pa05/pa05.runs/identity/identity.bit'
#file = "/home/src/HDL/bitinfo-0.3-mod-icap/identity-raw.bit"
file = "/home/src/HDL/bitinfo-0.3-mod-icap/identity_partial-raw.bit"
file = "/home/lib/projects/hwsv/DPR/experiments/modules/directbit/simple_inv/simple_inv.bit"

fd = open(file, 'rb');
rawbits = fd.read()
fd.close()

# cut header: done with stripheader from bitinfo-0.3-mod-icap

# convert
bitstring = bytearray(rawbits)
bitstring_n = np.zeros(len(bitstring), dtype='uint8')
#bitstring_n = np.array(bitstring, dtype='uint8')
for i in len(bitstring):
    bitstring_n[i] = bitstring[i]
#bitstring_f = uint8(fread(fd, 'uint8'));

bitstring_bits = np.zeros(len(bitstring_n) * 8)
bitstring_bits2 = np.zeros(len(bitstring_n) * 8)
start = time.time()
for d in range(len(bitstring_n)):
    # if d > 100:
    #     continue
    tmp = pad2eight(bin(bitstring_n[d]))
    # takes longer than the loop below
    bitstring_bits2[8*d:8*(d+1)] = list(tmp)
    for e in range(len(tmp)):
        bitstring_bits[8*d+e] = tmp[e]
        #print tmp[e]
end = time.time()

print "time:", end-start

pl.subplot(211)
pl.plot(bitstring_bits)
pl.ylim((0.0, 1.2))
pl.subplot(212)
pl.plot(bitstring_bits2)
pl.ylim((0.0, 1.2))

# do analysis
BS_BITS = np.fft.fft(bitstring_bits, 262144)

pl.subplot(111)
pl.plot(np.abs(BS_BITS[0:len(BS_BITS)/2]))


#!/usr/bin/env python
# generate oszillator2 module with line-lengths from 2 - 78

import sys, os
from string import Template
from shutil import copyfile

target = "osc_gate_ring"
vhdtmpl = "%s.vhtmpl" % target
substdict = {"linelength": 2}
target_proj = "../../../../DPR/experiments/reconf_linux_directbit/implementation/"
module_base = "osc_directout_gate_ring_"
module_bbname = "osc_directout_wrapped.ngc"

# linelengths are multiple of two
for linelength in range(2,80,2):
    substdict["linelength"] = linelength
    # load vhd template and substitute linelength
    f = open(vhdtmpl, "r") 
    vhdtmpl_s = Template(f.read()) # create tmpl
    f.close()
    vhdtmpl_t = vhdtmpl_s.substitute(substdict)
    f = open(target + ".vhd", "w") # open vhd for writing
    f.write(vhdtmpl_t)
    f.close()
    # synthesize netlist
    os.system("make")
    # create implementation dir in target-project and copy netlist
    destpath = target_proj + module_base + str(linelength)
    # os.mkdir(destpath)
    os.system("mkdir -pv " + destpath)
    copyfile(target + ".ngc", destpath + "/" + module_bbname)

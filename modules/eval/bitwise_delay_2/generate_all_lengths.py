#!/usr/bin/env python
# generate oszillator2 module with line-lengths from 2 - 78

import sys, os
from string import Template
from shutil import copyfile

target = "bitwise_delay_2"
vhdtmpl = "%s.vhtmpl" % target
substdict = {"linelength": 2}
target_proj = "../../../../DPR/experiments/reconf_linux_directbit/implementation/"
module_base = "eval_osc_bitwise_delay_2_w32_d"
module_bbname = "eval_osc_wrapped.ngc"

# delays are multiple of two
for delay in range(2,16,1):
    substdict["delay"] = delay
    # load vhd template and substitute delay
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
    destpath = ("%s%s%2.2d") % (target_proj, module_base, delay)
    # os.mkdir(destpath)
    os.system("mkdir -pv " + destpath)
    copyfile(target + ".ngc", destpath + "/" + module_bbname)

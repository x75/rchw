#!/usr/bin/env python

# generate make infrastructure for HDL projects
#  - x ISE synthesis
#  - ghdl
#  - myhdl
#  - vhdlparse

import sys, os
from optparse import OptionParser
from string import Template

#DEVICE := xc5vfx70tff1136-1
#DEVICE := 5vsx50tff1136-1
#DEVICE := xc5vlx50t-1-ff1136

outf_make = "makefile"
#outf_xst = ""

def main():
    parser = OptionParser()

    parser.add_option("-m", "--mode", dest="mode",
                      help="set mode", metavar="MODE",
                      default="makefile")
    parser.add_option("-t", "--target", dest="target",
                      help="set target (top vhdl file)", metavar="TARGET",
                      default="none")
    parser.add_option("-d", "--device", dest="device",
                      help="device to build for (string)", metavar="DEVICE",
                      default="xc5vfx70tff1136-1")
    # parser.add_option("-q", "--quiet",
    #                   action="store_false", dest="verbose", default=True,
    #                   help="don't print status messages to stdout")

    (options, args) = parser.parse_args()
    # print options
    # print args

    # print 'sys.argv[0] =', sys.argv[0]             
    pathname = os.path.dirname(sys.argv[0])        
    # print 'path =', pathname
    # print 'full path =', os.path.abspath(pathname)

    # get makefile template
    f = open(pathname + "/tmpl_makefile", "r")
    tmpl_makefile_s = f.read()
    f.close()

    # get .xst file template
    f = open(pathname + "/tmpl_xstfile", "r")
    tmpl_xstfile_s = f.read()
    f.close()

    # get .prj file template

    tmpl_dict = {
        "device": options.device,
        "target": options.target,
        }

    # write makefile
    s = Template(tmpl_makefile_s)
    text_makefile = s.substitute(tmpl_dict)
    f = open(outf_make, "w")
    f.write(text_makefile)
    f.close()

    # write xst file
    s = Template(tmpl_xstfile_s)
    text_xstfile = s.substitute(tmpl_dict)
    f = open(options.target + ".xst", "w")
    f.write(text_xstfile)
    f.close()

    # write .prj file
    # get *.vhd files
    f = open(options.target + ".prj", "w")
    vhdfiles_s = os.popen("ls *.vhd").read()
    vhdfiles = vhdfiles_s.split("\n")
    del vhdfiles[-1]
    for vhdfile in vhdfiles:
        f.write("vhdl work \"" + vhdfile + "\"\n")
    f.close()

    # write lso file
    f = open(options.target + ".lso", "w")
    f.write("work\n")
    f.close()

if __name__ == "__main__":
    sys.exit(main())

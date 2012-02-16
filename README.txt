                rchw - Re-Configurable HardWare
                ===============================

Author: Oswald Berthold
Date: 2012-02-16 17:10:51 CET


2010, 2011, 2012 Oswald Berthold
GPL where applicable

A collection of different tools, scripts and documentation on
reconfigurable hardware (FPGAs). As usual this is not meant as a
canonical toolset. Rather most of the stuff in here is ad-hoc
and provided as is.

Table of Contents
=================
1 Modules 
    1.1 dbm 
    1.2 elinux 
        1.2.1 icap-writer 
    1.3 ga-hw 
    1.4 genmake 
    1.5 modules 
    1.6 util 
    1.7 vhdlparse 
2 Related 


1 Modules 
----------

1.1 dbm 
========

Direct Bitstream Manipulation. Rapidsmith modules performing
in-place bitstream changes.

1.2 elinux 
===========

Software intended to run on the embedded system.

1.2.1 icap-writer 
~~~~~~~~~~~~~~~~~~

modified "bitinfo" project to write bitstreams headerless to
/dev/icap

1.3 ga-hw 
==========

Genetic algorithm with pyevolve for evolution of hardware
circuits

1.4 genmake 
============

generate makefiles for using the Xilinx toolchain to synthesise
single modules

1.5 modules 
============

various HDL sources for module implementations

1.6 util 
=========

some utilities for working with embedded systems on Xilinx FPGAs

1.7 vhdlparse 
==============

parse vhdl entities and generate a wrapper for use with xps,
generate tikz graphics for entity representation.

2 Related 
----------

See the following items for more information
 - [https://en.wikipedia.org/wiki/Reconfigurable\_computing]
 - Xilinx Partial Reconfiguration Documentation
 - Rapid Creation of FPGA CAD Tools for Xilinx FPGAs: [http://rapidsmith.sourceforge.net/]
 - Tools for Open Reconfigurable Computing: [http://torc-isi.sourceforge.net/]
 - Reconfigure in the Open!: [http://openpr-vt.sourceforge.net/OpenPR/OpenPR.html]
 - [http://www2.informatik.hu-berlin.de/~oberthol/html/Hardware.html]


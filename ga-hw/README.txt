                 evolvable hardware sub-project
                 ==============================

Author: Oswald Berthold
Date: 2012-01-05 15:51:49 CET


20110819, oswald berthold, part of diploma thesis on DPR / Linux

the goal here is to get evolutionary methods applied to FPGA
subcircuit design

Table of Contents
=================
1 the plan is as follows 
    1.1 implement genetic algorithm in pure python 
    1.2 implement genetic algorithm in DPR/Linux system 
    1.3 implement genetic algorithm with netlists and simulation 


1 the plan is as follows 
-------------------------

1.1 implement genetic algorithm in pure python 
===============================================
 - ga1.py: straightforward LUT evolution test
 - ga2.py: re-implement ga1.py with pyevolve

1.2 implement genetic algorithm in DPR/Linux system 
====================================================
  - evolution manager on Embedded Linux
  - genotype to phenotype mapping with RapidSmith via remote
    Linux PC (because of java/ppc)
  - intrinsic fitness evaluation

1.3 implement genetic algorithm with netlists and simulation 
=============================================================

with real LUTs with either MyHDL or straight VHDL and evaluate
the result by netlist simulation

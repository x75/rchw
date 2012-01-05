#!/usr/bin/env python

# test pyevolve with binary/bittring type genomes
# execute evolution on-chip
# 20110819 oswald berthold

import numpy as np
import pylab as pl
import math, os, sys

# bittring classes to handle bitarrays
from bitstring import BitArray, BitStream, ConstBitArray, ConstBitStream

from pyevolve import G1DBinaryString
from pyevolve import GSimpleGA
from pyevolve import Selectors
from pyevolve import Mutators
from pyevolve import DBAdapters

from subprocess import Popen, PIPE

bitstrlen = 16
bitstrbase = ""
for i in range(bitstrlen):
    bitstrbase = bitstrbase + str(np.random.randint(2))
# print bitstrbase

#target = BitArray("0b1110000000010000")
target = BitArray("0b" + bitstrbase)
print target.bin

def hamming_weight(a, b):
    return (a^b).count(True)

# This function is the evaluation function, we want
# to give high score to more zero'ed chromosomes
def eval_func(chromosome):
    score = 0.0
    # print type(chromosome)
    # iterate over the chromosome
    cnt = 0
    # print "chr-gleich",  == "11100000"
    a = BitArray("0b" + chromosome.getBinary())
    #print len(target), len(a)
    score = bitstrlen - hamming_weight(target, a)
    #print "eval_func", chromosome.getBinary()
    # for value in chromosome:
    #     if cnt % 2 == 0:
    #         if value == 0:
    #             score += 0.1
    #     else:
    #         if value == 1:
    #             score += 0.1
    #     cnt += 1
    return score

############################################################
# intrinsic evolution
def generate_bitstring_from_chromosome(chromosome):
    RAPIDSMITH_PATH = "/home/src/HDL/rapidsmith/rapidSmith"
    os.environ["RAPIDSMITH_PATH"] = RAPIDSMITH_PATH
    classpath = [
        RAPIDSMITH_PATH + "/jars/hessian-4.0.6.jar",
        RAPIDSMITH_PATH + "/jars/jopt-simple-3.2.jar",
        RAPIDSMITH_PATH + "/jars/qtjambi-4.6.3.jar",
        RAPIDSMITH_PATH + "/jars/qtjambi-linux32-gcc-4.6.3.jar",
        RAPIDSMITH_PATH + "",
        ]
    os.environ["CLASSPATH"] = str.join(":", classpath)

    # chromosome_binary = chromosome.getBinary()
    a = BitArray("0b" + chromosome.getBinary())
    lutconfhex = (a.hex)[2:len(a.hex)].upper()
    output_bs = "/home/lib/projects/hwsv/DPR/experiments/reconf_linux_directbit/pa02_lut/pa02_lut.runs/id_lut0001/id_lut" + lutconfhex + "_rs_frompy.bit"
    
    java = "/usr/bin/java"
    args = [
        "edu.byu.ece.rapidSmith.bitstreamTools.dprtests.FrameModderLogic",
        "-i",
        "/home/lib/projects/hwsv/DPR/experiments/reconf_linux_directbit/pa02_lut/pa02_lut.runs/id_lut0001/id_lut0001_fourlut_wrapper_0_fourlut_wrapper_0_fourlut_wrapped_inst_lut4_0001_partial.bit",
        "-s",
        "70426",
        "-l",
        chromosome.getBinary(),
        "-o",
        output_bs,
        ]
    (out, err) = Popen([java] + args, stdout=PIPE).communicate()
    print out
    #print args
    return output_bs

def upload_and_evaluate_phenotype(ph):
    print ph
    (out, err) = Popen(["scp", ph, "molly:evobit/"], stdout=PIPE).communicate()
    print out
    bitfilepath = ph.split("/")
    bitfile = bitfilepath[len(bitfilepath)-1]
    print bitfile
    (out, err) = Popen(["ssh", "molly", "./src/bitinfo-0.3/bitinfo", "./evobit/" + bitfile], stdout=PIPE).communicate()
    print out
    (out, err) = Popen(["ssh", "molly", "./src/evo_binfunc"], stdout=PIPE).communicate()
    print out
    b = BitArray("0b" + out)
    score = bitstrlen - hamming_weight(target, b)
    # return np.random.rand()
    return score

def eval_func_onhardware(chromosome):
    #print chromosome.getBinary()
    # 1. generate bitstring from chromosome
    ph = generate_bitstring_from_chromosome(chromosome)
    # 2. upload and evaluate individual
    score = upload_and_evaluate_phenotype(ph)
    # 3. receive score from intrinsic evaluation
    # 4. return that score
    print score
    return score

def run_main():
    
    
    # Genome instance
    genome = G1DBinaryString.G1DBinaryString(bitstrlen)

    # The evaluator function (objective function)
    genome.evaluator.set(eval_func)
    # genome.evaluator.set(eval_func_onhardware)
    genome.mutator.set(Mutators.G1DBinaryStringMutatorFlip)

    # Genetic Algorithm Instance
    ga = GSimpleGA.GSimpleGA(genome)
    #ga.setElitism(True)
    ga.setMutationRate(0.02) # for use with long strings 0.01, default: 0.02
    ga.selector.set(Selectors.GTournamentSelector)
    ga.setPopulationSize(10)
    ga.setGenerations(30)
    # ga.setInteractiveGeneration(10)

    csv_adapter = DBAdapters.DBFileCSV(identify="run1", filename="stats.csv")
    ga.setDBAdapter(csv_adapter)

    # Do the evolution, with stats dump
    # frequency of 10 generations
    ga.evolve(freq_stats=1)

    # Best individual
    print ga.bestIndividual()
    print target.bin

    f = open("best-ind.txt", "w")
    f.write(str(ga.bestIndividual()))
    f.write("\n")
    f.write(str(target.bin))
    f.write("\n")
    f.close()
    

if __name__ == "__main__":
   run_main()

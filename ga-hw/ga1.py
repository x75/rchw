#!/usr/bin/env python

# first experiments with binary evolutionary stuff
# 20110819 oswald berthold

# the usual suspects
import numpy as np
import math

# bittring classes to handle bitarrays
from bitstring import BitArray, BitStream, ConstBitArray, ConstBitStream
 
# initialize data-structures
#  - individual: genome, fitness
class Ind():
    def __init__(self):
        self.genome = 1
        self.fitness = 0.0
        return

    def tostring(self):
        return "genome: %d, fitness: %f" % (self.genome, self.fitness)
#  - population
#  - generations


# # bitstring tests
# a = BitArray('0xff01')
# b = BitArray('0b110')

# a.bin
# b.bin
# a.int
# b.int

# b.bytes
# (b + [0]).hex

# create some random bitstrings
bslen = 8
num = np.random.randint(2**bslen)
b1 = BitArray(uint=num, length=bslen)
num = np.random.randint(2**bslen)
b2 = BitArray(uint=num, length=bslen)

# LUT class: a read-only memory
class binLUT():
    def __init__(self, size):
        self.mem = {}
        for i in range(2**size):
            self.mem[ConstBitArray(uint=i,length=size)] = False

    def mem_(self):
        for key in self.mem: print key, self.mem[key]

############################################################
# first experiment: evolve a genome that represents the desired
# memory content for the LUT, a specific binary function

# define some necessary functions

# define hamming distance
def hamming_weight(a, b):
    return (a^b).count(True)

def gen_sort_by_fitness(a,b):
    if a["fitness"] > b["fitness"]:
        return 1
    if a["fitness"] == b["fitness"]:
        return 0
    if a["fitness"] < b["fitness"]:
        return -1

# define parent selection
def select_parents(generation):
    # maxerr = len(generation) * len(generation[0]["genome"])
    maxerr = len(generation[0]["genome"])
    print "maxerr:", maxerr
    errsum = 0
    weights = []
    for i in generation:
        weights.append(maxerr - i["fitness"])
        errsum = errsum + weights[-1]
    print weights, errsum
    ind_index_1 = weighted_choice(weights)
    print "ind_index_1:", ind_index_1
    ind_index_2 = ind_index_1
    # avoid auto-replication
    while ind_index_2 == ind_index_1:
        ind_index_2 = weighted_choice(weights)
    print "ind_index_2:", ind_index_2
    return [ind_index_1, ind_index_2]

# define weighted selection
def weighted_choice(weights):
    totals = []
    running_total = 0

    for w in weights:
        running_total += w
        totals.append(running_total)

    rnd = np.random.random() * running_total
    for i, total in enumerate(totals):
        if rnd < total:
            return i

# define crossover
def crossover(a, b):
    # length of genome
    genome_len = len(a["genome"])
    print "genome_len:", genome_len
    # determine single crossover point
    # FIXME: biased because ind1 always occupies first part of bitstring?
    co_point = np.random.randint(genome_len-1)
    print "co_point:", co_point
    # return new crossovered individual
    return {"genome": a["genome"][0:co_point] + b["genome"][co_point:genome_len], "fitness": 100}

# define mutation
def mutate(ind):
    print "mutate ind:", ind
    for i in range(len(ind["genome"])):
        if np.random.random() < 0.05:
            ind["genome"][i] = not(ind["genome"][i])
    return ind

# get going
# set result length
bslen = 8
# reference result
result = BitArray("0b11100100")

# init generations array
generations = []
# iterate generations
for g in range(20):
    print "generation:", g
    if g == 0:
        # populate first generation
        generations.append([
            {"genome": BitArray(uint=np.random.randint(2**bslen), length=bslen), "fitness": 100} for i in range(8)])
        print generations[0]
    else:
        # populate consequent generations
        print generations[g-1]
        # construct new generation
        gentmp = []
        # use elitism of size 1
        gentmp.append(generations[g-1][0])
        # fill remaining slots with offspring
        for i in range(1,len(generations[g-1])):
            (ind_a, ind_b) = select_parents(generations[g-1])
            indtmp = crossover(generations[g-1][ind_a], generations[g-1][ind_b])
            indtmp = mutate(indtmp)
            gentmp.append(indtmp)
        generations.append(gentmp)
        print "current generation:", generations[g]

    # evaluate fitness
    for i in generations[g]:
        i["fitness"] = hamming_weight(result, i["genome"])
    # sort by fitness
    generations[g].sort(cmp=gen_sort_by_fitness)

    for i in generations[g]:
        # i["fitness"] = np.random.randint(10)
        print "fitness:", i["fitness"]
# for ind in generations[0]:
#     print hamming_weight(result, ind["genome"])


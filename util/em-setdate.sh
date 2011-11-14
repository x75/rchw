#!/bin/sh

# set date on memoryless embedded systems

cmd="ssh molly date `date +%m%d%H%M%Y`"
echo $cmd

($cmd)


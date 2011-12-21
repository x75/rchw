#!/bin/sh

mdl=dsrc_countm1

xst -intstyle xflow -ifn ${mdl}.xst -ofn ${mdl}.syr
cp ${mdl}.ngc ../../../implementation/${mdl}/dsrc_act.ngc

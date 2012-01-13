#!/bin/sh
proj=reconf_linux
for dir in edk implementation image tools ; do
	mkdir -p ${proj}/${dir}
done


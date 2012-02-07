#!/bin/sh
# blink LEDs

GPIO=$1

cleanup() { # release gpio
	echo $GPIO >/sys/class/gpio/unexport
	exit
}

# open gpio port

echo $GPIO >/sys/class/gpio/export


trap cleanup SIGINT

#while [ "1" = "1" ] ; do
	echo "high" >/sys/class/gpio/gpio$GPIO/direction
	#sleep 1
	echo "low" >/sys/class/gpio/gpio$GPIO/direction
	#sleep 1
#done

cleanup


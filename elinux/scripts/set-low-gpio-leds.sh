# 8 bit GP LEDs
for i in 248 249 250 251 252 253 254 255 ; do echo low >/sys/class/gpio/gpio${i}/direction ; done
# 5 bit NESWC LEDs
for i in 243 244 245 246 247 ; do echo low >/sys/class/gpio/gpio${i}/direction ; done

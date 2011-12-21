all: synth

XST := xst
NGDBUILD := ngdbuild
MAP := map
PAR := par
TRCE := trce
XDL := xdl
BITGEN := bitgen

target = osc_freqdiv_1

DEVICE := xc5vfx70t-1ff1136

#$(target).vhd: $(target).py
#	python $(target).py

#genhdl: $(target).vhd

xstdir:
	mkdir -p xst/projnav.tmp

synth: xstdir $(target).vhd
	$(XST) -ifn $(target).xst -intstyle xflow

# impl: synth
# 	$(NGDBUILD) -intstyle xflow -p $(DEVICE) $(target).ngc
# 	$(MAP)  -intstyle xflow -w -pr b $(target).ngd
# 	$(PAR) -intstyle xflow $(target).ncd -w $(target)_routed.ncd
# 	$(TRCE) -intstyle xflow -o $(target).twr -v 30 -l 30 $(target)_routed.ncd $(target).pcf

# impl_ucf: synth
# 	$(NGDBUILD) -intstyle xflow -p $(DEVICE) -uc $(target).ucf $(target).ngc
# 	$(MAP)  -intstyle xflow -w -pr b $(target).ngd $(target).pcf
# 	$(PAR) -intstyle xflow $(target).ncd -w $(target)_routed.ncd $(target).pcf
# 	$(TRCE) -intstyle xflow -o $(target).twr -v 30 -l 30 $(target)_routed.ncd $(target).pcf -ucf $(target).ucf

# xdl: impl_ucf
# 	$(XDL) -secure -ncd2xdl -nopips $(target)_routed.ncd $(target)_routed.xdl

# bit: impl_ucf
# 	$(BITGEN) $(target)_routed.ncd $(target).bit $(target).pcf -b -n -w -intstyle xflow

clean:
	rm -rf *.srp *.ngc *.xrpt xst *.bld *.cmd_log *~

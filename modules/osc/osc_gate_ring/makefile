all: synth

XST := xst
NGDBUILD := ngdbuild
MAP := map
PAR := par
TRCE := trce
XDL := xdl
BITGEN := bitgen

target = oszillator2

DEVICE := xc5vfx70tff1136-1

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

# # $(NGDBUILD) -intstyle xflow -dd _ngo -nt timestamp -uc $(target).ucf -p $(DEVICE) $(target).ngc
# # $(MAP)  -intstyle xflow -p $(DEVICE) -w -logic_opt off -ol high -t 1 -register_duplication off -global_opt off -mt off -cm area -ir off -pr off -lc off -power off -o $(target)_map.ncd $(target).ngd $(target).pcf
# # $(PAR) -w -intstyle xflow -ol high -mt off $(target)_map.ncd $(target).ncd $(target).pcf
# # $(TRCE) -intstyle xflow -v 3 -s 1 -n 3 -fastpaths -xml $(target).twx $(target).ncd -o $(target).twr $(target).pcf -ucf $(target).ucf

# xdl: impl_ucf
# 	$(XDL) -secure -ncd2xdl -nopips $(target)_routed.ncd $(target)_routed.xdl

# bit: impl_ucf
# 	$(BITGEN) $(target)_routed.ncd $(target).bit $(target).pcf -b -n -w -intstyle xflow

# # EAStep ngdbuild -intstyle ise -p $(DEVICE) -uc "fir.ucf" -bm /home/oberthol/work/DPR/experiments/reconf_linux/edk/implementation/system.bmm "fir.edf"
# # EAStep map -intstyle ise -w -pr b "fir.ngd"
# # EAStep par -intstyle ise "fir.ncd" -w "fir_routed.ncd"
# # EAStep trce -intstyle ise -o "fir.twr" -v 30 -l 30 "fir_routed.ncd" "fir.pcf"
# # EAStep xdl -secure -ncd2xdl -nopips "fir_routed.ncd" "fir_routed.xdl"
# # EAStep bitgen "fir_routed.ncd" "fir.bit" "fir.pcf" -b -n -w -intstyle pa


clean:
	rm -rf *.srp *.ngc *.xrpt xst *.bld *.cmd_log *~

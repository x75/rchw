# source me
ghdl -m bitwise_delay_1_tb
./bitwise_delay_1_tb --stop-time=1us --vcd=bitwise_delay_1_tb.vcd
gtkwave bitwise_delay_1_tb.vcd


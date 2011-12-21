
TARGETS = dbuf_fifo dbuf_fifo_tb

SRCS = dbuf_fifo_tb.vhd dbuf_fifo.vhd
EXT = vhd

# IEEE = standard
IEEE = synopsys
STOP_TIME = 10000ns

# OBJS = $(patsubst %.$(EXT), %.o, $(SRCS))

# all: $(TARGETS)

# $(TARGETS): $(OBJS)

# $(OBJS): %.o: %.$(EXT)
# 	ghdl -a --ieee=$(IEEE) $<

all: prep

prep: $(TARGETS)

dbuf_fifo_tb:
	ghdl -a --ieee=$(IEEE) dbuf_fifo_tb.vhd
	ghdl -e --ieee=$(IEEE) dbuf_fifo_tb

dbuf_fifo:
	ghdl -a --ieee=$(IEEE) dbuf_fifo.vhd
	ghdl -e --ieee=$(IEEE) dbuf_fifo

#%.vcd: dbuf_fifo_tb dbuf_fifo
#run: prep

sim: prep # %.vcd
# ./dbuf_fifo_tb --vcd=dbuf_fifo_tb.vcd --stop-time=200ns
	ghdl -r  --ieee=$(IEEE) dbuf_fifo_tb --vcd=dbuf_fifo_tb.vcd --stop-time=$(STOP_TIME)

waveview: sim
	gtkwave dbuf_fifo_tb.vcd


#$(TARGETS): $(SRCS)

#elaborate: %.o: %.vhd
#	ghdl -e --ieee=$(IEEE) $<

#dbuf_fifo_tb:
#	ghdl -e --ieee=$(IEEE) $<

#elaborate: $(TARGETS)

#analyze:
#	echo blub

#$OBJS = $(patsubst %.$(EXT), %.o, $(SRCS))

#analyze: .o

%.o: %.vhd
	ghdl -a --ieee=$(IEEE) $<

clean:
	$(RM) $(RMFLAGS) *.o $(TARGETS) *.cf *.vcd *~
# Makefile for bitfile routines

CC = gcc
CFLAGS = -c -g -Wall
LDFLAGS = 
OBJECTS = bitinfo.o bitfile.o
OBJECTS_2 = stripheader.o bitfile.o
OBJECTS_TRIG = bitinfo-trigger.o bitfile.o
OBJECTS_COLL = bitinfo-collect-bits.o bitfile.o
OBJECTS_TIME = bitinfo-timing.o bitfile.o


all: bitinfo stripheader bitinfo-trigger \
	bitinfo-collect-bits bitinfo-timing

bitinfo.o: bitinfo.c bitfile.h
	${CC} ${CFLAGS} bitinfo.c -o bitinfo.o

bitfile.o: bitfile.c bitfile.h
	${CC} ${CFLAGS} bitfile.c -o bitfile.o

bitinfo: bitinfo.o bitfile.o
	${CC} ${LDFLAGS} ${OBJECTS} -o bitinfo

stripheader.o: stripheader.c bitfile.h
	${CC} ${CFLAGS} stripheader.c -o stripheader.o

stripheader: stripheader.o bitfile.o
	${CC} ${LDFLAGS} ${OBJECTS_2} -o stripheader

bitinfo-trigger.o: bitinfo-trigger.c bitfile.h
	${CC} ${CFLAGS} bitinfo-trigger.c -o bitinfo-trigger.o

bitinfo-collect-bits.o: bitinfo-collect-bits.c bitfile.h
	${CC} ${CFLAGS} bitinfo-collect-bits.c -o bitinfo-collect-bits.o

bitinfo-timing.o: bitinfo-timing.c bitfile.h
	${CC} ${CFLAGS} bitinfo-timing.c -o bitinfo-timing.o

bitinfo-trigger: bitinfo-trigger.o bitfile.o
	${CC} ${LDFLAGS} ${OBJECTS_TRIG} -o bitinfo-trigger

bitinfo-collect-bits: bitinfo-collect-bits.o bitfile.o
	${CC} ${LDFLAGS} ${OBJECTS_COLL} -o bitinfo-collect-bits

bitinfo-timing: bitinfo-timing.o bitfile.o
	${CC} ${LDFLAGS} ${OBJECTS_TIME} -o bitinfo-timing


clean:
	rm -f ${OBJECTS} bitinfo stripheader bitinfo-trigger \
	bitinfo-collect-bits bitinfo-timing

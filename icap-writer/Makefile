# Makefile for bitfile routines

CC = gcc
CFLAGS = -c -g -Wall
LDFLAGS = 
OBJECTS = bitinfo.o bitfile.o
OBJECTS_2 = stripheader.o bitfile.o


all: bitinfo stripheader

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

clean:
	rm -f ${OBJECTS} bitinfo stripheader

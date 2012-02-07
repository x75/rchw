// evo_binfunc

// 20110830 oswald berthold

// feed input into module via gpio
// read response from module via gpio

// compile with
// gcc -o evo_binfunc evo_binfunc.c

#include <stdio.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdint.h>
#include <assert.h>

#include <sys/time.h>
#include <sys/timeb.h>

// network stuff 
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>


//#include "xparams-dsrconly.h"
#include "xparameters.h"

#define XPAR_FOURLUT_WRAPPER_0_COMM_RANGE 16

int main (int argc, char *argv[]) {
	int fd;
	unsigned int *bf_in, *bf_in2; // bram
	unsigned int *bf_out, *bf_out2; // bram
	int i;

	// open memory
	fd = open("/dev/mem", O_RDWR);
	if(fd == -1) {
		printf("Err: cannot open /dev/mem\n");
		return -1;
	}

	// map gpio: get pointer to gpio core channel 1 (input)
	bf_in = MAP_FAILED;
	bf_in = mmap(
								 (void *)XPAR_FOURLUT_WRAPPER_0_COMM_BASEADDR,
								 XPAR_FOURLUT_WRAPPER_0_COMM_RANGE,
								 PROT_READ|PROT_WRITE, MAP_SHARED, fd,
								 XPAR_FOURLUT_WRAPPER_0_COMM_BASEADDR);
	assert(bf_in == (void *)XPAR_FOURLUT_WRAPPER_0_COMM_BASEADDR);
	//if (bf_in < 1)
	//	perror("mmap: bf_in");	

	// save basepointer
	bf_in2 = bf_in;

	// get pointer to gpio core channel 2 (output)
	bf_out = bf_in+2;

	// loop over possible input values (0000, 0001, ..., 1111)
	for(i = 0; i<16; i++) {
		*(bf_in) = i;
		usleep(10); // wait
		//printf("bf: in: %d, out: %d\n", i, *(bf_out));
		printf("%d", *(bf_out));
	}
	printf("\n");
}

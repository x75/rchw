// evo_oszillator

// 20110830 oswald berthold

// feed input into module via gpio
// read response from module via gpio

// compile with
// gcc -o evo_oszillator evo_oszillator.c

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

#define XPAR_OSC_WRAPPER_0_COMM_RANGE 16

int main (int argc, char *argv[]) {
	int fd;
	unsigned int *osc_in, *osc_in2; // bram
	unsigned int *osc_out, *osc_out2; // bram
	int i;

	int num_vals = 10000;
	char vals[num_vals];

	// open memory
	fd = open("/dev/mem", O_RDWR);
	if(fd == -1) {
		printf("Err: cannot open /dev/mem\n");
		return -1;
	}

	// map gpio: get pointer to gpio core channel 1 (input)
	osc_in = MAP_FAILED;
	osc_in = mmap(
								 (void *)XPAR_OSC_WRAPPER_0_COMM_BASEADDR,
								 XPAR_OSC_WRAPPER_0_COMM_RANGE,
								 PROT_READ|PROT_WRITE, MAP_SHARED, fd,
								 XPAR_OSC_WRAPPER_0_COMM_BASEADDR);
	assert(osc_in == (void *)XPAR_OSC_WRAPPER_0_COMM_BASEADDR);
	//if (osc_in < 1)
	//	perror("mmap: osc_in");	

	// save basepointer
	osc_in2 = osc_in;

	// get pointer to gpio core channel 2 (output)
	osc_out = osc_in+2;

	i = 1;
	*(osc_in) = 1;
	//sleep(10);

	// start time

	// loop over possible input values (0000, 0001, ..., 1111)
	for(i = 0; i<num_vals; i++) {
		//usleep(10); // wait
		//printf("bf: in: %d, out: %d\n", i, *(osc_out));
		printf("%d,", *(osc_out));
		//printf("%d\n", *(osc_out));
		vals[i] = (*(osc_out)) + 32;
	}
	vals[i] = 0;

	// end time
	printf("%s", vals);
	printf("\n");
}

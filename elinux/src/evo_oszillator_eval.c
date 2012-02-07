// evo_oszillator_eval

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
#define XPAR_EVAL_OSC_WRAPPER_0_COMM_IN_RANGE 16
#define XPAR_EVAL_OSC_WRAPPER_0_COMM_OUT_RANGE 16

int main (int argc, char *argv[]) {
	int fd;
	unsigned int *osc_in, *osc_in2; // bram
	unsigned int *osc_out;
	unsigned int *osc_eval_in, *osc_eval_in2; // bram
	unsigned int *osc_eval_out, *osc_eval_out2; // bram
	int i;

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

	// map gpio: get pointer to gpio core channel 1 (input)
	osc_eval_in = MAP_FAILED;
	osc_eval_in = mmap(
								 (void *)XPAR_EVAL_OSC_WRAPPER_0_COMM_IN_BASEADDR,
								 XPAR_EVAL_OSC_WRAPPER_0_COMM_IN_RANGE,
								 PROT_READ|PROT_WRITE, MAP_SHARED, fd,
								 XPAR_EVAL_OSC_WRAPPER_0_COMM_IN_BASEADDR);
	assert(osc_eval_in == (void *)XPAR_EVAL_OSC_WRAPPER_0_COMM_IN_BASEADDR);
	//if (osc_eval_in < 1)
	//	perror("mmap: osc_eval_in");	

	// save basepointer
	osc_eval_in2 = osc_eval_in;

	// get pointer to gpio core channel 2 (output)
	osc_eval_out = MAP_FAILED;
	osc_eval_out = mmap(
								 (void *)XPAR_EVAL_OSC_WRAPPER_0_COMM_OUT_BASEADDR,
								 XPAR_EVAL_OSC_WRAPPER_0_COMM_OUT_RANGE,
								 PROT_READ|PROT_WRITE, MAP_SHARED, fd,
								 XPAR_EVAL_OSC_WRAPPER_0_COMM_OUT_BASEADDR);
	assert(osc_eval_out == (void *)XPAR_EVAL_OSC_WRAPPER_0_COMM_OUT_BASEADDR);

	//osc_eval_out = osc_eval_out+2;

	// get pointer to gpio core channel 2 (output)
	osc_out = osc_in+2;


	//i = 1;
	*(osc_in) = 1;

	// loop over possible input values (0000, 0001, ..., 1111)
	//	for(i = 0; i<10000; i++) {

	uint32_t old;
	uint32_t cur;

	old = cur = 0;

	i = 0;
	while (1) {
		//usleep(10); // wait
		//printf("bf: in: %d, out: %d\n", i, *(osc_eval_out));
		//printf("%d-", *(osc_out));

		*(osc_eval_out) = i;
		i++;
		cur = *(osc_eval_in);
		//printf("%u\n", cur - old);
		printf("i: %u, shifted: %u\n", i, cur);
		old = cur;
		//usleep(90000);
		usleep(1000000);
		//printf("%d\n", *(osc_eval_out));
	}
	printf("\n");
}

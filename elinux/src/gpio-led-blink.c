// test: read from bram

// compile with:
// gcc -o gpio-led-blink gpio-led-blink.c


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

//#include "xparams.h"
#include "xparameters.h"

// chw bram
//#define XPAR_CHW_BRAM_IF_CNTLR_01_BASEADDR 0x81850000
// #define XPAR_CHW_BRAM_IF_CNTLR_01_RANGE 64*1024
//#define XPAR_CHW_BRAM_IF_CNTLR_01_RANGE 2048
// Pushbuttons
//#define XPAR_CHW_BRAM_IF_CNTLR_01_BASEADDR 0x81400000
//#define XPAR_CHW_BRAM_IF_CNTLR_01_RANGE 16
// DIP switches
//#define XPAR_CHW_BRAM_IF_CNTLR_01_BASEADDR 0x81460000
//#define XPAR_CHW_BRAM_IF_CNTLR_01_RANGE 16
// chw ctrl
//#define XPAR_CHW_BRAM_IF_CNTLR_01_BASEADDR 0x81830000
//#define XPAR_CHW_BRAM_IF_CNTLR_01_RANGE 16
// chw ctrl input
//#define XPAR_CHW_CTRL_IN_BASEADDR 0x81440000
// #define XPAR_CHW_CTRL_IN_RANGE 16
#define XPAR_LEDS_8BIT_RANGE 8 // XPAR_LEDS_8BIT_HIGHADDR - XPAR_LEDS_8BIT_BASEADDR
#define XPAR_PUSH_BUTTONS_5BIT_RANGE 16

int main (int argc, char *argv[]) {
	int fd;
	// FILE* datei;
	// unsigned int *ptr;
	// unsigned int *ptr2;
	uint32_t *leds8, *leds82;
	unsigned int *pb, *pb2;
	int i;

	fd = open("/dev/mem", O_RDWR);
	if(fd == -1) {
		printf("Err: cannot open /dev/mem\n");
		return -1;
	}

	// map gpio
	leds8 = MAP_FAILED;
	leds8 = mmap(XPAR_LEDS_8BIT_BASEADDR, XPAR_LEDS_8BIT_RANGE,
						PROT_READ|PROT_WRITE, MAP_SHARED, fd,
						XPAR_LEDS_8BIT_BASEADDR);	
	assert(leds8 == XPAR_LEDS_8BIT_BASEADDR);
	if (leds8 < 1)
		perror("mmap: leds8");	

	// save basepointer
	leds82 = leds8;

	// map gpio
	pb = MAP_FAILED;
	pb = mmap(XPAR_PUSH_BUTTONS_5BIT_BASEADDR, XPAR_PUSH_BUTTONS_5BIT_RANGE,
						PROT_READ|PROT_WRITE, MAP_SHARED, fd,
						XPAR_PUSH_BUTTONS_5BIT_BASEADDR);	
	assert(pb == XPAR_PUSH_BUTTONS_5BIT_BASEADDR);
	if (pb < 1)
		perror("mmap: pb");	

	// save basepointer
	pb2 = pb;

	// reset hardware
	//*leds8 = 0;
	//sleep(1);
	//*leds8 = 1;
	//sleep(1);
	//*leds8 = 0;


	//datei = fopen("speicherdump.dump","wb");
	//printf("Dateihandler: %i\n",datei);
	

	// fill bram for testing
	/* for (i=0; i<XPAR_CHW_BRAM_IF_CNTLR_01_RANGE / 4; i++) {
		*ptr = i + 1000;
		ptr++;
	} */

	uint8_t pbval;

	while(1) {
		// for (i = 0; i < 20; i++)
		//fwrite(ptr,1,4,datei);
		//printf("x: %d, %x, ", i, *ptr);
		//if(i % 4 == 2) {
		//if((*ptr % 100000000) < 10000) {
		// printf("x: %d, %u, ", i, *ptr);
			
		// printf("x: %d, %u, ", i, *ptr);
		// printf("x: %d, %d, %d, ", i, (*ptr) >> 16, ((*ptr) << 16) >> 16);
		// printf("x: %d, %d, %d, ", i, (int16_t)(*ptr) >> 16, (int16_t)(((*ptr) << 16) >> 16));
		//printf("%d\n", (int16_t)(((*ptr) << 16) >> 16));
		//		printf("%d\n", );
		for(i=0; i < 256 ; i++) {
			// printf("led istate: %d\n", *leds8);
			//*(leds8) = (uint32_t)(1 << i);
			*(leds8) = (uint32_t)i;

			pbval = *pb;
			printf("button: %d\n", pbval);
			usleep(250000);

			//printf("led on\n");
			//*leds8 = 1;
			//sleep(1);
			
			//}
			//}
			//printf("\n");
		}
		printf("blub\n");
	}
	
	//munmap(ptr2, XPAR_CHW_BRAM_IF_CNTLR_01_RANGE);
	munmap(leds8, XPAR_LEDS_8BIT_RANGE);
	close(fd);
	return 0;
}


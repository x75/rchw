// bram2net

// 20101012 Oswald Berthold

// read from bram interface
// write to network

// compile with:
// gcc -o bram2net bram2net.c

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

// chw bram
//#define XPAR_DPROC_BRAM_CNTLR_BASEADDR 0x81850000
#define XPAR_DPROC_BRAM_CNTLR_RANGE 64*1024
//#define XPAR_DPROC_BRAM_CNTLR_RANGE 2048
// Pushbuttons
//#define XPAR_DPROC_BRAM_CNTLR_BASEADDR 0x81400000
//#define XPAR_DPROC_BRAM_CNTLR_RANGE 16
// DIP switches
//#define XPAR_DPROC_BRAM_CNTLR_BASEADDR 0x81460000
//#define XPAR_DPROC_BRAM_CNTLR_RANGE 16
// chw ctrl
//#define XPAR_DPROC_BRAM_CNTLR_BASEADDR 0x81830000
//#define XPAR_DPROC_BRAM_CNTLR_RANGE 16
// chw ctrl input
//#define XPAR_DPROC_WRAPPER_TO_BRAM_0_DBG_BASEADDR 0x81440000
#define XPAR_DPROC_WRAPPER_TO_BRAM_0_DBG_RANGE 16
#define XPAR_DPROC_WRAPPER_WIRE_0_DBG_RANGE XPAR_DPROC_WRAPPER_WIRE_0_DBG_HIGHADDR - XPAR_DPROC_WRAPPER_WIRE_0_DBG_BASEADDR

//#define AUDIO_BUF_SIZE	1024
#define AUDIO_BUF_SIZE 512	

#define TERM_WIDTH 4

// keeping time
time_t tt;
struct tm *timeinfo;
int now;
struct timeb tb;
int tstmp0, tstmp1;
int tmstmp0, tmstmp1;
int t_total; // total time elapsed

// network stuff
int sock;
struct sockaddr_in server_addr;
struct hostent *host;
char txbuf[AUDIO_BUF_SIZE];

void dump_array(int32_t* d, int l) {
	int i;
	for(i = 0; i < l; i++) {
		printf("s(%5d): %5d:%5d,", i, (int16_t)(d[i] >> 16), (int16_t)d[i]);
		if(i % TERM_WIDTH == (TERM_WIDTH-1))
			printf("\n");
	}
	printf("\n");
}

void dump_array_raw(int32_t* d, int l) {
	fwrite(d, sizeof(int32_t), l, stdout);
	fflush(stdout);
}

int dump_array_net(int32_t* d, int l) {
	int txbytes;
	txbytes = sendto(sock, d, l * sizeof(int32_t), 0,
			(struct sockaddr *)&server_addr, sizeof(struct sockaddr));
	return txbytes;
}

int main (int argc, char *argv[]) {
	int fd;
	// FILE* datei;
	unsigned int *ptr, *ptr2; // bram
	unsigned int *ctrl_o, *ctrl_o2; // control out, local viewpoint
	unsigned int *ctrl_i, *ctrl_i2; // control in, local viewpoint
	int i;

	// init network
	host = (struct hostent *) gethostbyname((char *)"192.168.2.1");

	if ((sock = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
	{
		perror("socket");
		exit(1);
	}

	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(5000);
	server_addr.sin_addr = *((struct in_addr *)host->h_addr);
	bzero(&(server_addr.sin_zero),8);



	// open memory
	fd = open("/dev/mem", O_RDWR);
	if(fd == -1) {
		printf("Err: cannot open /dev/mem\n");
		return -1;
	}

	// map block ram
	ptr = MAP_FAILED; // Initialize to bad value
	ptr = mmap((void *)XPAR_DPROC_BRAM_CNTLR_BASEADDR, XPAR_DPROC_BRAM_CNTLR_RANGE,
				PROT_READ|PROT_WRITE, MAP_SHARED, fd,
				XPAR_DPROC_BRAM_CNTLR_BASEADDR);
	assert(ptr == (void *)XPAR_DPROC_BRAM_CNTLR_BASEADDR);
	//if (ptr < 1 )
	//	perror("mmap: bram");


	if(ptr==MAP_FAILED) {
		printf("Err: cannot access address!\n");
		return -1;
	}

	// save basepointer
	ptr2=ptr;

	// map gpio: ctrl input
	ctrl_o = MAP_FAILED;
	ctrl_o = mmap((void *)XPAR_DPROC_WRAPPER_TO_BRAM_0_DBG_BASEADDR, XPAR_DPROC_WRAPPER_TO_BRAM_0_DBG_RANGE,
						PROT_READ|PROT_WRITE, MAP_SHARED, fd,
						XPAR_DPROC_WRAPPER_TO_BRAM_0_DBG_BASEADDR);	
	assert(ctrl_o == (void *)XPAR_DPROC_WRAPPER_TO_BRAM_0_DBG_BASEADDR);
	//if (ctrl_o < 1)
	//	perror("mmap: ctrl_o");	

	// save basepointer
	ctrl_o2 = ctrl_o;

	// map gpio: ctrl output
	ctrl_i = MAP_FAILED;
	ctrl_i = mmap((void *)XPAR_DPROC_WRAPPER_WIRE_0_DBG_BASEADDR, XPAR_DPROC_WRAPPER_WIRE_0_DBG_RANGE,
						PROT_READ|PROT_WRITE, MAP_SHARED, fd,
						XPAR_DPROC_WRAPPER_WIRE_0_DBG_BASEADDR);	
	assert(ctrl_i == (void *)XPAR_DPROC_WRAPPER_WIRE_0_DBG_BASEADDR);
	//if (ctrl_i < 1)
	//	perror("mmap: ctrl_i");	

	// save basepointer
	ctrl_o2 = ctrl_o;

	// map gpio: ctrl output

	// reset hardware
	//*ctrl_o = 0;
	//sleep(1);
	//*ctrl_o = 1;
	//sleep(1);
	//*ctrl_o = 0;


	//datei = fopen("speicherdump.dump","wb");
	//printf("Dateihandler: %i\n",datei);
	
	//printf("init value in 0: %x\n",*ptr);
	// exit(1);	



	// fill bram for testing
	/* for (i=0; i<XPAR_DPROC_BRAM_CNTLR_RANGE / 4; i++) {
		*ptr = i + 1000;
		ptr++;
	} */

	ptr = ptr2;

	// control signals, timing
	int c0, c1, cd; // control_in_t0, control_in_t-1
  	int tstamp;
	int newsamp, nsc = 0;
	// data
	int32_t d1[AUDIO_BUF_SIZE];
	int32_t d2[AUDIO_BUF_SIZE];

	c0 = c1 = *ctrl_o;
	i = 0;

	// printf("los gehts ...\n");


	/*
	sprintf(txbuf, "blub, blub\n");

	sendto(sock, txbuf, strlen(txbuf), 0,
			(struct sockaddr *)&server_addr, sizeof(struct sockaddr));
	*/

	while(1) {
		//printf("ctrl_i: %d\n", *ctrl_i);
		c1 = c0;
		c0 = *ctrl_o;
		cd = c0 - c1;

		newsamp = *(ctrl_o+2);
		//if(newsamp == 1)
		//	printf("\ndebug: %d(%d)\n", newsamp, nsc++);
		//else
		// 	printf(".");

		if(cd != 0) {
  			tstamp = time(&tt);
  			ftime(&tb);
			//printf("%d,%d\n", tstamp, tb.millitm);

			//printf("status change: %d\n", cd);
			if(cd > 0) { // positive edge: state 2
				// memcpy(d2, ptr+AUDIO_BUF_SIZE, AUDIO_BUF_SIZE * sizeof(int32_t));
				// dump_array(d2, AUDIO_BUF_SIZE);
				dump_array_net(ptr+AUDIO_BUF_SIZE, AUDIO_BUF_SIZE);
				// dump_array_raw(ptr+AUDIO_BUF_SIZE, AUDIO_BUF_SIZE);
			}
			else { // negative edge: state 1
				// memcpy(d1, ptr, AUDIO_BUF_SIZE * sizeof(int32_t));	
				// dump_array(d1, AUDIO_BUF_SIZE);
				dump_array_net(ptr, AUDIO_BUF_SIZE);
				// dump_array_raw(ptr, AUDIO_BUF_SIZE);
			}
			i++;
		}
		//for (i = 0; i < 0; i++) 
		//for (i = 0; i < XPAR_DPROC_BRAM_CNTLR_RANGE / 4; i++)
		// for (i = 0; i < 20; i++)
		//{
			//fwrite(ptr,1,4,datei);
			//printf("x: %d, %x, ", i, *ptr);
			//if(i % 4 == 2) {
			//if((*ptr % 100000000) < 10000) {
			// printf("x: %d, %u, ", i, *ptr);
			
			// printf("x: %d, %u, ", i, *ptr);
			// printf("x: %d, %d, %d, ", i, (*ptr) >> 16, ((*ptr) << 16) >> 16);
			// printf("x: %d, %d, %d, ", i, (int16_t)(*ptr) >> 16, (int16_t)(((*ptr) << 16) >> 16));
		//	printf("%d\n", (int16_t)(((*ptr) << 16) >> 16));
		//	usleep(10);
			
			//}
			//}
		//	if(i % 4 == 3) {
		//		 printf("\n");
		//		// printf("x: %d\n", i, *ptr);
		//	}
		//	ptr++;
		//}
		//printf("\n");
		//ptr = ptr2;

		// if(i==16)
		//	break;	
	}
	
	munmap(ptr2, XPAR_DPROC_BRAM_CNTLR_RANGE);
	close(fd);
	return 0;
}


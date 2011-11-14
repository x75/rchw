/* bitinfo.c
 *
 * Main function to parse Xilinx bit file header, version 0.2.
 *
 * Copyright 2001, 2002 by David Sullins
 *
 * This file is part of Bitinfo.
 * 
 * Bitinfo is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, version 2 of the License.
 * 
 * Bitinfo is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * Bitinfo; if not, write to the Free Software Foundation, Inc., 59 Temple
 * Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 * You may contact the author at djs@naspa.net.
 */


#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <errno.h>
#include "bitfile.h"

enum faults_t {
	USAGE_f,
	DEVICAP_f,
	BITFILE_f
};

void handle_fault(int fault) {
	switch(fault) {
		case USAGE_f:
			printf("usage: %s bitfile.bit\n", "bitinfo");
			exit(1);
		case DEVICAP_f:
			perror("icap");
			exit(1);
		case BITFILE_f:
			perror("bitfile");
			exit(1);
		default:
			break;
	}
	return;
}

/* read a bit file from stdin */
int main(int argc, char **argv)
{
	int t;
	struct bithead bh;
	FILE *BITFILE;
	FILE *ICAP;
	const char devicap[] = "/dev/icap0";
	uint8_t *bitbuf;

	if(argc <= 1)
		handle_fault(USAGE_f);

	printf("Opening %s\n", devicap);
	ICAP = fopen(devicap, "w");
	if(!ICAP)
		handle_fault(DEVICAP_f);
	BITFILE = fopen(argv[1], "r");
	if(!BITFILE)
		handle_fault(BITFILE_f);

	// init bitheader struct
	initbh(&bh);
	
	/* read header */
	t = readhead(&bh, BITFILE);
	if (t)
	{
		printf("Invalid bit file header.\n");
		exit(1);
	}
	
	/* output header info */
	printf("\n");
	printf("Bit file created on %s at %s.\n", bh.date, bh.time);
	printf("Created from file %s for Xilinx part %s.\n", bh.filename, 
	       bh.part);
	printf("Bitstream length is %d bytes.\n", bh.length);
	printf("\n");

	int dummy = 7;
	//write(ICAP, &dummy, 1);	
	//read(ICAP, &dummy, 1);
	printf("dummy: %d\n", dummy);
	// write remaining stream into /dev/icap
	int i;
	//for(i=0; i < bh.length; i++) {
	//	printf("writing byte #%d\n", i);
	//	write(ICAP+i, BITFILE+i, 1);
	//}

	// fast forward
	//BITFILE += 40;
	//bh.length -= 40;

	fseek(BITFILE, 40, SEEK_CUR);
	bh.length -= 40;

	bitbuf = (uint8_t *)malloc(bh.length);
	i = fread(bitbuf, 1, bh.length, BITFILE);	
	printf("read %d bytes from %s\n", i, argv[1]);
	/*
	for(i=0; i<bh.length; i++) {
		printf("%x, ", *(bitbuf+i));
	}
	printf("\n");
	*/
	i = fwrite(bitbuf, 1, bh.length, ICAP);
	//i = write(ICAP, BITFILE, bh.length);
	printf("wrote %d bytes to %s\n", i, devicap);

	// clean up	
	freebh(&bh);

	fclose(ICAP);
	fclose(BITFILE);	
	return 0;
}
